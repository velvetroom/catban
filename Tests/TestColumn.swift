import XCTest
@testable import Catban

class TestColumn:XCTestCase {
    private var column:Column!
    
    override func setUp() {
        super.setUp()
        self.column = Column()
    }
    
    func testAddingCard() {
        let text:String = "lorem ipsum"
        self.column.addCard(text:text)
        XCTAssertEqual(self.column.cards.count, 1, "Not added")
        if self.column.cards.count == 1 {
            XCTAssertEqual(self.column.cards.first!.text, text, "Invalid text")
        }
    }
    
    func testDeletingCard() {
        let text:String = "hello world"
        self.column.addCard(text:text)
        guard let card:Card = self.column.cards.first else { return }
        self.column.addCard(text:"Another one")
        self.column.delete(card:card)
        XCTAssertEqual(self.column.cards.count, 1, "Should have 1 card")
        XCTAssertNotEqual(text, self.column.cards.first?.text, "Deleted wrong card")
    }
}
