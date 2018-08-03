import XCTest
@testable import Domain

class TestFactory:XCTestCase {
    func testAvoidMoreThanOneLibraries() {
        let libraryA:LibraryProtocol = Factory.makeLibrary()
        let libraryB:LibraryProtocol = Factory.makeLibrary()
        XCTAssertTrue(libraryA === libraryB, "Different instances")
    }
}
