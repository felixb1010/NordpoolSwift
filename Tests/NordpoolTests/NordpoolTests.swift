import XCTest
@testable import Nordpool

final class NordpoolTests: XCTestCase {
    let client = Nordpool()
    func testNowPrice() async throws {
        guard let now = await NPPrice.now else { fatalError("Failed Fetching") }
        let currentHour = Calendar.current.component(.hour, from: Date())
        let nowHour = Calendar.current.component(.hour, from: now.date())
        XCTAssert(nowHour == currentHour, "Elspot is not now")
    }
    
    func testHourlyPrice() async throws {
        guard let hourly = await NPPrice.hourly else { fatalError("Failed fethcing hourly") }
        XCTAssert(hourly.count >= 10, "There are less than 10 hourly prices")
    }
    
    func testDailyPrice() async throws {
        guard let daily = await NPPrice.daily else { fatalError("Failed fethcing daily") }
        XCTAssert(daily.count >= 10, "There are less than 10 Daily prices")
    }
    
    func testWeeklyPrice() async throws {
        guard let weekly = await NPPrice.weekly else { fatalError("Failed fethcing daily") }
        XCTAssert(weekly.count >= 20, "There are less than 20 Weekly prices")
    }
    
    func testMonthlyPrice() async throws {
        guard let monthly = await NPPrice.monthly else { fatalError("Failed fethcing daily") }
        XCTAssert(monthly.count >= 50, "There are less than 50 Monthly prices")
    }
    
    func testYearlyPrice() async throws {
        guard let yearly = await NPPrice.yearly else { fatalError("Failed fethcing daily") }
        XCTAssert(yearly.count >= 5, "There are less than 5 Yearly prices")
    }
}
