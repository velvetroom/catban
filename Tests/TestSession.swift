import XCTest
@testable import Catban

class TestSession:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        super.setUp()
        self.session = Session()
    }
    
    func testCodingBoards() {
        let identifierA:String = "hello world"
        let identifierB:String = "lorem ipsum"
        self.session.boards[identifierA] = Board()
        self.session.boards[identifierB] = Board()
        let data:Data
        do { try data = JSONEncoder().encode(self.session) }
        catch {
            XCTFail("Not encoding")
            return
        }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) }
        catch {
            XCTFail("Failed type")
            return
        }
        XCTAssertEqual(newSession.boards.keys.count, 2, "Invalid amount")
        XCTAssertTrue(newSession.boards.keys.contains(identifierA), "Invalid identifier")
        XCTAssertTrue(newSession.boards.keys.contains(identifierB), "Invalid identifier")
    }
    
    func testCodingCardsFont() {
        let session:Session = Session()
        session.cardsFont = 55
        let data:Data
        do { try data = JSONEncoder().encode(session) } catch { return }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) } catch {
            XCTFail("Failed type")
            return
        }
        XCTAssertEqual(newSession.cardsFont, session.cardsFont, "Invalid font")
    }
    
    func testCodingNoPreviousCardsFont() {
        let dictionary:[String:[String]] = ["boards":[]]
        let data:Data
        do { try data = JSONEncoder().encode(dictionary) } catch { return }
        let session:Session
        do { try session = JSONDecoder().decode(Session.self, from:data) }
        catch {
            XCTFail("Failed to decode")
            return
        }
        XCTAssertEqual(session.boards.count, 0, "Should have 0 boards")
        XCTAssertEqual(session.cardsFont, Session.cardsFont, "Should have default cards font")
    }
    
    func testCodingDefaultColumns() {
        let session:Session = Session()
        session.defaultColumns = false
        let data:Data
        do { try data = JSONEncoder().encode(session) } catch { return }
        let newSession:Session
        do { try newSession = JSONDecoder().decode(Session.self, from:data) } catch {
            XCTFail("Failed type")
            return
        }
        XCTAssertEqual(newSession.defaultColumns, session.defaultColumns, "Invalid default columns")
    }
    
    func testNewSessionHasDefaultCardsFont() {
        XCTAssertEqual(Session().cardsFont, Session.cardsFont, "Should have default cards font")
    }
    
    func testNewSessionHasDefaultColumns() {
        XCTAssertTrue(Session().defaultColumns, "Should have default columns")
    }
}
