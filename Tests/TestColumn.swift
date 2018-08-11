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
}
