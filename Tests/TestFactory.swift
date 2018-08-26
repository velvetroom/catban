import XCTest
@testable import Catban

class TestFactory:XCTestCase {
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
    }
    
    func testAvoidMoreThanOneLibraries() {
        XCTAssertTrue(Factory.makeLibrary() === Factory.makeLibrary())
    }
}
