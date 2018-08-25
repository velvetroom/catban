import XCTest
@testable import Catban

class TestFactory:XCTestCase {
    override func setUp() {
        super.setUp()
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
    }
    
    func testAvoidMoreThanOneLibraries() {
        let libraryA:Library = Factory.makeLibrary()
        let libraryB:Library = Factory.makeLibrary()
        XCTAssertTrue(libraryA === libraryB, "Different instances")
    }
}
