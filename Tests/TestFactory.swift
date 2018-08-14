import XCTest
@testable import Catban

class TestFactory:XCTestCase {
    override func setUp() {
        super.setUp()
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
    }
    
    func testAvoidMoreThanOneLibraries() {
        let libraryA:LibraryProtocol = Factory.makeLibrary()
        let libraryB:LibraryProtocol = Factory.makeLibrary()
        XCTAssertTrue(libraryA === libraryB, "Different instances")
    }
    
    func testAddIdentifierToCard() {
        XCTAssertFalse(Card().identifier.isEmpty, "No identifier")
    }
    
    func testAddIdentifierToColumn() {
        XCTAssertFalse(Column().identifier.isEmpty, "No identifier")
    }
}
