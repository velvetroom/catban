import XCTest
@testable import Domain

class TestFactory:XCTestCase {
    override func setUp() {
        super.setUp()
        Configuration.cacheService = MockCacheServiceProtocol.self
        Configuration.databaseService = MockDatabaseServiceProtocol.self
    }
    
    func testAvoidMoreThanOneLibraries() {
        let libraryA:LibraryProtocol = Factory.makeLibrary()
        let libraryB:LibraryProtocol = Factory.makeLibrary()
        XCTAssertTrue(libraryA === libraryB, "Different instances")
    }
}
