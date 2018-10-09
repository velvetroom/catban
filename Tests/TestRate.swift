import XCTest
@testable import Catban

class TestRate:XCTestCase {
    private var library:Library!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
    }
    
    func testNoRateAtFirst() {
        XCTAssertFalse(library.rate())
    }
    
    func testRateIfMoreThan1Project() {
        library.session.counter = 2
        XCTAssertTrue(library.rate())
        XCTAssertFalse(library.session.rates.isEmpty)
    }
    
    func testNoRateIfRatedRecently() {
        library.session.counter = 2
        library.session.rates = [Date()]
        XCTAssertFalse(library.rate())
    }
    
    func testRateIfRatedMoreThan2MonthsAgo() {
        var components = DateComponents()
        components.month = 4
        let date = Calendar.current.date(byAdding:components, to:Date())!
        library.session.counter = 2
        library.session.rates = [date]
        XCTAssertEqual(date, library.session.rates.last!)
        XCTAssertTrue(library.rate())
        XCTAssertNotEqual(date, library.session.rates.last!)
    }
}
