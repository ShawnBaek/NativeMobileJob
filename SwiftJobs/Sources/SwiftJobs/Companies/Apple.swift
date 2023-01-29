//
//  Apple.swift
//  
//
//  Created by Sungwook Baek on 2023/01/15.
//

import Foundation
import SwiftSoup

public struct Apple: Fetchable {
    static var pageNumber: Int = 0
    static let baseURL = URL(string: "https://jobs.apple.com/en-us/search")!
    static let detailURL = "https://jobs.apple.com/en-sg/details/"
    static let basicQueryItems = [
        URLQueryItem(name: "sort", value: "newest"),
        URLQueryItem(name: "key", value: "ios")
    ]
    static var dateFormatter = DateFormatter()
    static let dateFormat = "dd MM YYYY"
    static let fetchableItemElements: [FetchableItemElement] = [
        .parent(tagName: "tbody", className: nil, idName: nil),
        .jobTitle(tagName: "a", className: "table--advanced-search__title", idName: nil),
        .jobId(tagName: "a", className: nil, idName: "jotTitle"),
        .role(tagName: "span", className: "table--advanced-search__role", idName: nil),
        .postedDate(tagName: "span", className: "table--advanced-search__date", idName: nil),
        .location(tagName: "span", className: nil, idName: "storeName_container"),
        .page(tagName: "span", className: "pageNumber", idName: "")
    ]
    
    static var regexExpression = try! NSRegularExpression(pattern: "-(\\d+)")
    
    static func jobId(text: String) -> String? {
        let match = regexExpression.firstMatch(
            in: text, range: NSRange(location: 0, length: text.utf16.count)
        )
        guard let match = match, let range = Range(match.range(at: 1), in: text) else {
            return nil
        }
        let number = text[range]
        return String(number)
    }

    static func updateTotalPage(doc: Document) {
        guard let pageClassName = fetchableItemElements[.page]?.className,
                let pageItems = try? doc.getElementsByClass(pageClassName) else {
            return
        }
        for page in pageItems {
            if let pageText = try? page.text(), let pageNumber = Int(pageText) {
                print("🚀 \(pageNumber)")
                self.pageNumber = pageNumber
            }
        }
    }
    
    static func fetchDocument(lastPage: Int) async throws -> [Document] {
        try await withThrowingTaskGroup(of: Document.self, body: { group in
            var result = [Document]()
            for page in 1...lastPage {
                group.addTask {
                    let html = try await paging(page: page)
                    let doc: Document = try SwiftSoup.parse(html)
                    return doc
                }
            }
            for try await doc in group {
                result.append(doc)
            }
            return result
        })
    }
    
    public static func jobs() async throws -> [SwiftJob] {
        let html = try await paging(page: 0)
        let doc: Document = try SwiftSoup.parse(html)
        updateTotalPage(doc: doc)
        
        var docs = [doc]
        let remainingDocs = try await fetchDocument(lastPage: pageNumber)
        docs.append(contentsOf: remainingDocs)
        
        var results = [SwiftJob]()
        for document in docs {
            let tables = try document.getElementsByTag("tbody")
            //storeName_container
            for table in tables {
                let innerTable: Element = table
                
                var fetchedJobTitle: String?
                var fetchedJobId: String?
                var fetchedDescription: String?
                var fetchedPosted: Date?
                var fetchedLocation: String?
                
                for element in try innerTable.getAllElements() {
                    let className = try? element.className()
                    let idName = element.id()
                    if let className, !className.isEmpty {
                        if let jobTitleClass = fetchClassName(item: .jobTitle), className.contains(jobTitleClass),
                           let jobTitle = try? element.text(), !jobTitle.isEmpty {
                            print("✅ Job: \(jobTitle)")
                            if !isContainsKeywords(title: String(jobTitle)) {
                                continue
                            }
                            fetchedJobTitle = jobTitle
                            if let jobIdName = fetchableItemElements[.jobId]?.idName,
                                idName.contains(jobIdName),
                                let jobId = jobId(text: idName) {
                                print("✅ JobID: \(jobId)")
                                fetchedJobId = jobId
                            }
                        }
                        else if let roleClass = fetchClassName(item: .role), className.contains(roleClass),
                                let role = try? element.text(), !role.isEmpty {
                            print("✅ Role: \(role)")
                            fetchedDescription = role
                        }
                        else if let dateClass = fetchClassName(item: .postedDate), className.contains(dateClass),
                                    let date = try? element.text(), !date.isEmpty {
                            print("✅ Posted: \(date)")
                            fetchedPosted = transformDate(text: date)
                        }
                    }
                    
                    if let locationName = fetchIdName(item: .location), !idName.isEmpty, let location = try? element.text(), !location.isEmpty, idName.contains(locationName) {
                        print("✅ Location: \(location)")
                        fetchedLocation = location
                    }
                }
                if let jobId = fetchedJobId, let jobTitle = fetchedJobTitle, let jobURL = URL(string: detailURL + jobId) {
                    let job = SwiftJob(
                        id: jobId,
                        title: jobTitle,
                        location: fetchedLocation,
                        description: fetchedDescription,
                        applyURL: jobURL,
                        posted: fetchedPosted,
                        targetOS: nil,
                        company: .apple
                    )
                    results.append(job)
                }
            }
        }
        return results
    }
    
    static func paging(page: Int) async throws -> String {
        let pageQueryItem = URLQueryItem(name: "page", value: "\(page)")
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        var queryItems = basicQueryItems
        queryItems.append(pageQueryItem)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            throw FetchError.wrongURL
        }
        return try await html(url: url)
    }
}
