import XCTest
@testable import Catban

class TestCard:XCTestCase {
    func testSaveNewCard() {
        let card = Card()
        card.content = "hello world"
        guard
            let data = try? JSONEncoder().encode(card),
            let decoded = try? JSONDecoder().decode(Card.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual("hello world", decoded.content)
    }
}
