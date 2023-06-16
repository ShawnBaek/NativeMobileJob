import Foundation
import SwiftUI

public struct SwiftJob: Identifiable {
    public let id: String
    public let title: String
    public let location: String?
    public let description: String?
    public let applyURL: URL
    public let posted: Date?
    public let targetOS: Double?
    public let company: CompanyType
}
