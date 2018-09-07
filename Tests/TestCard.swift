import XCTest
@testable import Catban

class TestCard:XCTestCase {
    func testLoadLegacyCard() {
        guard
            let data = try? JSONSerialization.data(withJSONObject:["text":"hello world"]),
            let card = try? JSONDecoder().decode(Card.self, from:data)
        else { return XCTFail() }
        XCTAssertEqual("hello world", card.content)
    }
    
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
