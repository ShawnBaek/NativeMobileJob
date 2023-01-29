//
//  Fetchable.swift
//  
//
//  Created by Sungwook Baek on 2023/01/15.
//

import Foundation
import SwiftSoup

protocol Fetchable {
    static var baseURL: URL { get }
    static var detailURL: String { get }
    static var pageNumber: Int { get set }
    static var dateFormat: String { get }
    static var dateFormatter: DateFormatter { get set }
    static var fetchableItemElements: [FetchableItemElement] { get }
    static var basicQueryItems: [URLQueryItem] { get }
    static var regexExpression: NSRegularExpression { get }
    static var keywords: [String] { get }
    
    static func paging(page: Int) async throws -> String
    static func updateTotalPage(doc: Document)
    static func html(url: URL) async throws -> String
    static func jobs() async throws -> [SwiftJob]
    static func jobId(text: String) -> String?
    static func fetchTagName(item: FetchableItemKey) -> String?
    static func fetchClassName(item: FetchableItemKey) -> String?
    static func fetchIdName(item: FetchableItemKey) -> String?
    static func isContainsKeywords(title: String) -> Bool
    static func transformDate(text: String) -> Date?
}

extension Fetchable {
    static var keywords: [String] {
        ["iOS", "Swift"]
    }
    
    static func html(url: URL) async throws -> String {
        try String(contentsOf: url)
    }
    
    static func fetchTagName(item: FetchableItemKey) -> String? {
        fetchableItemElements[item]?.tagName
    }
    
    static func fetchClassName(item: FetchableItemKey) -> String? {
        fetchableItemElements[item]?.className
    }
    
    static func fetchIdName(item: FetchableItemKey) -> String? {
        fetchableItemElements[item]?.idName
    }
    
    static func isContainsKeywords(title: String) -> Bool {
        for word in keywords {
            if title.contains(word) {
                return true
            }
        }
        return false
    }
    
    static func transformDate(text: String) -> Date? {
        dateFormatter.date(from: text)
    }
}
