import XCTest
@testable import Nordpool

final class NordpoolTests: XCTestCase {
    let client = Nordpool()
    func testNowPrice() async throws {
        let now = try await client.currentPrice(area: .Oslo, currency: .NOK)
        let currentHour = Calendar.current.component(.hour, from: Date())
        let nowHour = Calendar.current.component(.hour, from: now.date())
        XCTAssert(nowHour == currentHour, "Elspot is not now")
    }
    
    func testHourlyPrice() async throws {
        let hourly = try await client.price(area: .Oslo, currency: .NOK, TimeScale: .hourly)
        XCTAssert(hourly.count >= 10, "There are less than 10 hourly prices")
    }
    
    func testDailyPrice() async throws {
        let daily = try await client.price(area: .Oslo, currency: .NOK, TimeScale: .daily)
        XCTAssert(daily.count >= 10, "There are less than 10 Daily prices")
    }
    
    func testWeeklyPrice() async throws {
        let weekly = try await client.price(area: .Oslo, currency: .NOK, TimeScale: .weekly)
        XCTAssert(weekly.count >= 20, "There are less than 20 Weekly prices")
    }
    
    func testMonthlyPrice() async throws {
        let monthly = try await client.price(area: .Oslo, currency: .NOK, TimeScale: .monthly)
        XCTAssert(monthly.count >= 50, "There are less than 50 Monthly prices")
    }
    
    func testYearlyPrice() async throws {
        let yearly = try await client.price(area: .Oslo, currency: .NOK, TimeScale: .yearly)
        XCTAssert(yearly.count >= 5, "There are less than 5 Yearly prices")
    }
}
