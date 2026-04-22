import XCTest
@testable import Countix

@MainActor
final class CountixTests: XCTestCase {
    func testMakeDraftTrimsTitleAndCombinesDateAndTime() {
        let viewModel = EventFormViewModel()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        viewModel.title = "  Product Launch  "
        viewModel.eventDate = calendar.date(from: DateComponents(year: 2026, month: 6, day: 10))!
        viewModel.eventTime = calendar.date(from: DateComponents(hour: 14, minute: 45))!
        viewModel.displayMode = .minutesOnly

        let draft = viewModel.makeDraft()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: draft.eventDate)

        XCTAssertEqual(draft.title, "Product Launch")
        XCTAssertEqual(draft.displayMode, .minutesOnly)
        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.month, 6)
        XCTAssertEqual(components.day, 10)
        XCTAssertEqual(components.hour, 14)
        XCTAssertEqual(components.minute, 45)
    }

    func testInitWithEventPrefillsFields() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let eventDate = calendar.date(from: DateComponents(year: 2027, month: 1, day: 8, hour: 9, minute: 5))!
        let event = Event(title: "Morning Briefing", eventDate: eventDate, displayMode: .daysOnly)

        let viewModel = EventFormViewModel(event: event)

        XCTAssertEqual(viewModel.title, "Morning Briefing")
        XCTAssertEqual(viewModel.displayMode, .daysOnly)
        XCTAssertEqual(viewModel.eventDate, eventDate)
        XCTAssertEqual(viewModel.eventTime, eventDate)
    }

    func testApplyUpdatesEventFromDraft() {
        let originalDate = Date(timeIntervalSince1970: 10_000)
        let event = Event(title: "Before", eventDate: originalDate, displayMode: .full)
        let viewModel = EventFormViewModel(event: event)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        viewModel.title = "  After  "
        viewModel.eventDate = calendar.date(from: DateComponents(year: 2028, month: 12, day: 1))!
        viewModel.eventTime = calendar.date(from: DateComponents(hour: 22, minute: 30))!
        viewModel.displayMode = .monthsOnly

        viewModel.apply(to: event)

        XCTAssertEqual(event.title, "After")
        XCTAssertEqual(event.displayMode, .monthsOnly)

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: event.eventDate)
        XCTAssertEqual(components.year, 2028)
        XCTAssertEqual(components.month, 12)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.hour, 22)
        XCTAssertEqual(components.minute, 30)
    }
}
