import XCTest
@testable import Catban

class TestSession:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        session = Session()
    }
    
    func testCodingBoards() {
        session.boards["lorem ipsum"] = Board()
        session.boards["hello world"] = Board()
        let data:Data
        do { try data = JSONEncoder().encode(session) } catch { return XCTFail() }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) } catch { return XCTFail() }
        XCTAssertEqual(2, newSession.boards.keys.count)
        XCTAssertTrue(newSession.boards.keys.contains("lorem ipsum"))
        XCTAssertTrue(newSession.boards.keys.contains("hello world"))
    }
    
    func testCodingCardsFont() {
        let session = Session()
        session.cardsFont = 55
        let data:Data
        do { try data = JSONEncoder().encode(session) } catch { return XCTFail() }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) } catch { return XCTFail() }
        XCTAssertEqual(newSession.cardsFont, session.cardsFont)
    }
    
    func testCodingNoPreviousCardsFont() {
        let data:Data
        do { try data = JSONEncoder().encode(["boards":[]] as! [String:[String]]) } catch { return XCTFail() }
        let session:Session
        do { try session = JSONDecoder().decode(Session.self, from:data) } catch { return XCTFail() }
        XCTAssertEqual(0, session.boards.count)
        XCTAssertEqual(session.cardsFont, Session.cardsFont)
    }
    
    func testCodingDefaultColumns() {
        let session = Session()
        session.defaultColumns = false
        let data:Data
        do { try data = JSONEncoder().encode(session) } catch { return XCTFail() }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) } catch { return XCTFail() }
        XCTAssertEqual(newSession.defaultColumns, session.defaultColumns)
    }
    
    func testNewSessionHasDefaultCardsFont() {
        XCTAssertEqual(Session.cardsFont, Session().cardsFont)
    }
    
    func testNewSessionHasDefaultColumns() {
        XCTAssertTrue(Session().defaultColumns)
    }
}
