//
//  FetchableItemElement.swift
//  
//
//  Created by Sungwook Baek on 2023/01/15.
//

import Foundation

enum FetchableItemElement {
    case parent(tagName: String, className: String?, idName: String?)
    case jobTitle(tagName: String, className: String?, idName: String?)
    case jobId(tagName: String, className: String?, idName: String?)
    case role(tagName: String, className: String?, idName: String?)
    case postedDate(tagName: String, className: String?, idName: String?)
    case applyLink(tagName: String, className: String?, idName: String?)
    case location(tagName: String, className: String?, idName: String?)
    case page(tagName: String, className: String?, idName: String?)
}

enum FetchableItemKey {
    case parent
    case jobTitle
    case jobId
    case role
    case postedDate
    case applyLink
    case location
    case page
}

extension FetchableItemElement {
    var tagName: String {
        switch self {
        case let .parent(tagName, _, _):
            return tagName
        case let .jobTitle(tagName, _, _):
            return tagName
        case let .jobId(tagName: tagName, _, _):
            return tagName
        case let .role(tagName, _, _):
            return tagName
        case let .postedDate(tagName, _, _):
            return tagName
        case let .applyLink(tagName, _, _):
            return tagName
        case let .location(tagName, _, _):
            return tagName
        case let .page(tagName, _, _):
            return tagName
        }
    }
    
    var idName: String? {
        switch self {
        case let .parent(_, _, idName):
            return idName
        case let .jobTitle(_, _, idName):
            return idName
        case let .jobId(_, _, idName):
            return idName
        case let .role(_, _, idName):
            return idName
        case let .postedDate(_, _, idName):
            return idName
        case let .applyLink(_, _, idName):
            return idName
        case let .location(_, _, idName):
            return idName
        case let .page(_, _, idName):
            return idName
        }
    }
    
    var className: String? {
        switch self {
        case let .parent(_, className, _):
            return className
        case let .jobTitle(_, className, _):
            return className
        case let .jobId(_, className, _):
            return className
        case let .role(_, className, _):
            return className
        case let .postedDate(_, className, _):
            return className
        case let .applyLink(_, className, _):
            return className
        case let .location(_, className, _):
            return className
        case let .page(_, className, _):
            return className
        }
    }
}

extension Collection where Element == FetchableItemElement {
    subscript(item: FetchableItemKey) -> FetchableItemElement? {
        get {
            switch item {
            case .parent:
                return first { item in
                    if case .parent = item {
                        return true
                    }
                    return false
                }
            case .jobTitle:
                return first { item in
                    if case .jobTitle = item {
                        return true
                    }
                    return false
                }
            case .jobId:
                return first { item in
                    if case .jobId = item {
                        return true
                    }
                    return false
                }
            case .role:
                return first { item in
                    if case .role = item {
                        return true
                    }
                    return false
                }
            case .postedDate:
                return first { item in
                    if case .postedDate = item {
                        return true
                    }
                    return false
                }
            case .applyLink:
                return first { item in
                    if case .applyLink = item {
                        return true
                    }
                    return false
                }
            case .location:
                return first { item in
                    if case .location = item {
                        return true
                    }
                    return false
                }
            case .page:
                return first { item in
                    if case .page = item {
                        return true
                    }
                    return false
                }
            }
        }
    }
}
