import XCTest
@testable import SwiftJobs

final class SwiftJobsTests: XCTestCase {
    //MARK: TODO
    func testApple() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let results = try await Apple.jobs()
        
        XCTAssertNotNil(results, "Results should not be nil")
        for item in results {
            print("\(item.title) - \(item.description) - \(item.location)")
        }
    }
    
    //MARK: TODO
    func testUber() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let results = try await Uber.jobs()
        
        XCTAssertNotNil(results, "Results should not be nil")
        for item in results {
            print("\(item.title) - \(item.description) - \(item.location)")
        }
    }
}
