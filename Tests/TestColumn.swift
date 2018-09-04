import XCTest
@testable import Catban

class TestColumn:XCTestCase {
    private var column:Column!
    
    override func setUp() {
        column = Column()
    }
    
    func testAddingCard() {
        column.addCard(text:"lorem ipsum")
        XCTAssertEqual(1, column.cards.count)
        XCTAssertEqual("lorem ipsum", column.cards.first?.content)
    }
    
    func testDeletingCard() {
        column.addCard(text:"hello world")
        column.addCard(text:"Another one")
        column.delete(card:column.cards.first!)
        XCTAssertEqual(1, column.cards.count)
        XCTAssertNotEqual("hello world", column.cards.first?.content)
    }
    
    func testInsertingCardAfterAnother() {
        let subject = Card()
        column.addCard(text:"Another")
        column.addCard(text:"Other")
        column.insert(card:subject, after:column.cards.first!)
        XCTAssertEqual(3, column.cards.count)
        XCTAssertTrue(subject === column.cards[1])
    }
    
    func testMakeCardFirst() {
        let subject = Card()
        column.addCard(text:"Another")
        column.addCard(text:"Other")
        column.makeFirst(card:subject)
        XCTAssertEqual(3, column.cards.count)
        XCTAssertTrue(subject === column.cards.first)
    }
}
