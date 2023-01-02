import XCTest
@testable import Nordpool

final class NordpoolTests: XCTestCase {
    let client = Nordpool()
    let options: NPOptions = NPOptions(zone: .Oslo, currency: .NOK, tax: 0.25, fee: 0.16, timeScale: .hourly)
    func testNowPrice() async throws {
        guard let now = try? await NPPrice.now(options) else { fatalError("Failed Fetching") }
        let currentHour = Calendar.current.component(.hour, from: Date())
        let nowHour = Calendar.current.component(.hour, from: now.date())
        XCTAssert(nowHour == currentHour, "Elspot is not now")
    }
    
    func testHourlyPrice() async throws {
        guard let hourly = try? await NPPrice.price(.init(zone: options.zone, currency: options.currency, tax: options.tax, fee: options.fee, timeScale: .hourly)) else { fatalError("Failed fethcing hourly") }
        XCTAssert(hourly.count >= 10, "There are less than 10 hourly prices")
    }
}
