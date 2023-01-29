//
//  File.swift
//  
//
//  Created by Sungwook Baek on 2023/01/23.
//

import Foundation
import SwiftSoup
import UIKit

public struct Uber: Fetchable {
    static var baseURL: URL = URL(string: "https://www.uber.com/us/en/careers/list/")!
    static var detailURL = "https://www.uber.com"
    static var pageNumber = 0
    static var dateFormat = ""
    static var dateFormatter = DateFormatter()
    
    
    static var fetchableItemElements: [FetchableItemElement] = [
        .parent(tagName: "div", className: "css-bnia-Dv", idName: nil),
        .jobTitle(tagName: "a", className: "css-bNzNOn", idName: nil),
        .role(tagName: "span", className: "css-dCwqLp", idName: nil),
        .location(tagName: "span", className: "css-dCwqLp", idName: nil)
    ]
    
    static let basicQueryItems = [
        URLQueryItem(name: "department", value: "Engineering"),
        URLQueryItem(name: "team", value: "iOS")
    ]
    //MARK:
    static var regexExpression = try! NSRegularExpression(pattern: "-(\\d+)")
    
    static func html(url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.setValue("text/html", forHTTPHeaderField: "Accept")
        let (data, _) = try await URLSession.shared.data(for: request)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    static func paging(page: Int) async throws -> String {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = basicQueryItems
        guard let url = urlComponents?.url else {
            throw FetchError.wrongURL
        }
        return try await html(url: url)
    }
    
    static func updateTotalPage(doc: SwiftSoup.Document) {
        
    }
    
    public static func jobs() async throws -> [SwiftJob] {
        let html = try await paging(page: 0)
        let doc: Document = try SwiftSoup.parse(html)
        var results = [SwiftJob]()
        
        guard let parentTag = fetchableItemElements[.parent]?.tagName else {
            return results
        }
        let items = try doc.getElementsByTag(parentTag)
        for item in items {
            let innerItem: Element = item
            var jobTitle: String?
            var jobRole: String?
            var jobLocation: String?
            var jobApplyURL: String?
            for element in try innerItem.getAllElements() {
                let className = try? element.className()
                if element.tagName() == fetchableItemElements[.jobTitle]?.tagName,
                    className == fetchableItemElements[.jobTitle]?.className, let href = try? element.attr("href") {
                    print("😁 Job Title: \(try? element.text()), \(href)\n")
                    jobTitle = try? element.text()
                    jobApplyURL = href
                }
                else if element.tagName() == fetchableItemElements[.role]?.tagName,
                        className == fetchableItemElements[.role]?.className, let hasATag = try? element.select("a"), hasATag.isEmpty() {
                    if jobRole == nil {
                        jobRole = try? element.text()
                    }
                    else {
                        if jobLocation != nil {
                            continue
                        }
                        jobLocation = try? element.text()
                    }
                    
                    if let title = jobTitle, let applyURL = jobApplyURL, let role = jobRole, let location = jobLocation {
                        print("\(title)")
                        print("\(role)")
                        print("\(location)")
                        print("============")
                        jobTitle = nil
                        jobRole = nil
                        jobLocation = nil
                        jobApplyURL = nil
                        
                        let job = SwiftJob(id: applyURL.components(separatedBy: "/").last ?? "", title: title, location: location, description: role, applyURL: URL(string: detailURL + applyURL)!, posted: nil, targetOS: 13, company: .uber)
                        results.append(job)
                    }
                }
            }
        }
        return results
    }
    
    static func jobId(text: String) -> String? {
        nil
    }
}
