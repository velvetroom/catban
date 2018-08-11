import XCTest
@testable import Catban

class TestSession:XCTestCase {
    private var session:Session!
    
    override func setUp() {
        super.setUp()
        self.session = Factory.makeSession()
    }
    
    func testAddBoard() {
        let identifier:String = "hello world"
        self.session.add(board:identifier)
        XCTAssertEqual(self.session.boards.count, 1, "Not added")
        XCTAssertNotNil(self.session.boards[identifier], "Invalid board")
    }
    
    func testUpdatingBoard() {
        let identifier:String = "hello world"
        self.session.update(identifier:identifier, board:Factory.makeBoard())
        XCTAssertEqual(self.session.boards.count, 1, "Not added")
        XCTAssertNotNil(self.session.boards[identifier], "Invalid board")
    }
    
    func testRemoveBoard() {
        let identifier:String = "lorem ipsum"
        self.session.add(board:"First")
        self.session.add(board:identifier)
        self.session.add(board:"Another")
        self.session.remove(board:identifier)
        XCTAssertEqual(self.session.boards.count, 2, "Should have 2")
        XCTAssertNil(self.session.boards[identifier], "Removed wrong board")
    }
    
    func testEncoding() {
        let identifierA:String = "hello world"
        let identifierB:String = "lorem ipsum"
        self.session.add(board:identifierA)
        self.session.add(board:identifierB)
        let data:Data
        do { try data = JSONEncoder().encode(self.session) }
        catch {
            XCTFail("Not encoding")
            return
        }
        let dictionary:[String:[String]]
        do { try dictionary = JSONDecoder().decode([String:[String]].self, from:data) }
        catch {
            XCTFail("Failed type")
            return
        }
        guard
            let array:[String] = dictionary["boards"]
        else {
            XCTFail("Failed contents")
            return
        }
        XCTAssertEqual(array.count, 2, "Invalid amount")
        XCTAssertTrue(array.contains(identifierA), "Invalid identifier")
        XCTAssertTrue(array.contains(identifierB), "Invalid identifier")
    }
    
    func testDecoding() {
        let identifierA:String = "hello world"
        let identifierB:String = "lorem ipsum"
        let dictionary:[String:[String]] = ["boards":[identifierA, identifierB]]
        let data:Data
        do { try data = JSONEncoder().encode(dictionary) } catch { return }
        let session:Session
        do { try session = JSONDecoder().decode(Session.self, from:data) }
        catch {
            XCTFail("Failed to decode")
            return
        }
        XCTAssertEqual(session.boards.count, 2, "Should have 2 boards")
        XCTAssertNotNil(session.boards[identifierA], "Invalid identifier")
        XCTAssertNotNil(session.boards[identifierB], "Invalid identifier")
    }
}
