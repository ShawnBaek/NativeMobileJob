//
//  Company.swift
//  
//
//  Created by Sungwook Baek on 2023/01/15.
//

import Foundation
import SwiftUI

//We added companies which are native friendly company only.
public enum CompanyType: String, CaseIterable {
    case uber
    case apple
}

extension CompanyType {
    public var logoImage: Image {
        switch self {
        case .uber:
            return SwiftJobsAsset.uber.swiftUIImage
        case .apple:
            return SwiftJobsAsset.apple.swiftUIImage
        }
    }
}
