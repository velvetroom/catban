import XCTest
@testable import Catban

class TestLibrary_Properties:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCache!
    private var database:MockDatabase!
    
    override func setUp() {
        super.setUp()
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.cache = self.library.cache as? MockCache
        self.database = self.library.database as? MockDatabase
        self.library.session = Session()
        self.library.state = Library.stateReady
    }
    
    func testUpdateCardsFontSavesSession() {
        let font:Int = 99
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        self.cache.onSaveSession = {
            XCTAssertEqual(self.library.session.cardsFont, font, "Not updated")
            expect.fulfill()
        }
        self.library.cardsFont = font
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testUpdateDefaultColumnsSavesSession() {
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        self.cache.onSaveSession = {
            XCTAssertFalse(self.library.session.defaultColumns, "Not updated")
            expect.fulfill()
        }
        self.library.defaultColumns = false
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}
