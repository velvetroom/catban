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
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(2, newSession.boards.keys.count)
        XCTAssertTrue(newSession.boards.keys.contains("lorem ipsum"))
        XCTAssertTrue(newSession.boards.keys.contains("hello world"))
    }
    
    func testCodingCardsFont() {
        let session = Session()
        session.cardsFont = 55
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(session.cardsFont, newSession.cardsFont)
    }
    
    func testCodingNoPreviousCardsFont() {
        guard
            let data = try? JSONEncoder().encode(["boards":[]] as! [String:[String]]),
            let session = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(0, session.boards.count)
        XCTAssertEqual(Session.cardsFont, session.cardsFont)
    }
    
    func testCodingDefaultColumns() {
        let session = Session()
        session.defaultColumns = false
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(session.defaultColumns, newSession.defaultColumns)
    }
    
    func testNewSessionHasDefaultCardsFont() {
        XCTAssertEqual(Session.cardsFont, Session().cardsFont)
    }
    
    func testNewSessionHasDefaultColumns() {
        XCTAssertTrue(Session().defaultColumns)
    }
    
    func testCodingCounter() {
        let session = Session()
        session.counter = 99
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(99, newSession.counter)
    }
    
    func testCodingNoPreviousCounter() {
        guard
            let data = try? JSONEncoder().encode(["boards":[]] as! [String:[String]]),
            let session = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(0, session.counter)
    }
    
    func testCodingRates() {
        let session = Session()
        session.rates = [Date(), Date()]
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(2, newSession.rates.count)
    }
    
    func testCodingNoPreviousRates() {
        guard
            let data = try? JSONEncoder().encode(["boards":[]] as! [String:[String]]),
            let session = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertTrue(session.rates.isEmpty)
    }
    
    func testCodingSkin() {
        let session = Session()
        session.skin = .dark
        guard
            let data = try? JSONEncoder().encode(session),
            let newSession = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(Skin.dark, newSession.skin)
    }
    
    func testCodingNoPreviousSkin() {
        guard
            let data = try? JSONEncoder().encode(["boards":[]] as! [String:[String]]),
            let session = try? JSONDecoder().decode(Session.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual(Skin.light, session.skin)
    }
}
