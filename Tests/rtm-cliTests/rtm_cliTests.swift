import XCTest
@testable import rtm_cli

final class rtm_cliTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(rtm_cli().text, "Hello, World!")
    }
}
