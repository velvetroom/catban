import XCTest
@testable import Catban

class TestLibrary_Properties:XCTestCase {
    private var library:Library!
    private var cache:MockCache!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
        cache = library.cache as? MockCache
    }
    
    func testUpdateCardsFontSavesSession() {
        let expect = expectation(description:String())
        cache.onSaveSession = {
            XCTAssertEqual(99, self.library.session.cardsFont)
            expect.fulfill()
        }
        library.cardsFont = 99
        waitForExpectations(timeout:1)
    }
    
    func testUpdateDefaultColumnsSavesSession() {
        let expect = expectation(description:String())
        cache.onSaveSession = {
            XCTAssertFalse(self.library.session.defaultColumns)
            expect.fulfill()
        }
        library.defaultColumns = false
        waitForExpectations(timeout:1)
    }
}
