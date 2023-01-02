import Foundation

public struct Nordpool {
    
    static let shared = Nordpool()
    
    private let session = URLSession.shared
    
    private let baseURL = "https://www.nordpoolspot.com/api"

    public init() {
    }
    
    public func currentPrice(area: NPZone, currency: NPCurrency) async throws -> NPPrice {
        guard let url = makeURL(timeScale: .hourly) else { throw APIServiceError.invalidURL }
        do {
            let (data, _): (Data, Int) = try await fetch(url: url)
            let parsed = try await parseJSON(data: data, area: area)
            guard let current = parsed.current() else {throw APIServiceError.invalidData }
            return current
        } catch jsonError.parseError {
            throw APIServiceError.invalidResponseType
        } catch {
            throw error
        }
    }
    
    public func price(area: NPZone, currency: NPCurrency, TimeScale: NPTimeScale, startDate: Date? = nil, endDate: Date? = nil) async throws -> [NPPrice] {
        guard let url = makeURL(timeScale: TimeScale, currency: currency, startDate: startDate, endDate: endDate) else { throw APIServiceError.invalidURL }
        let (data, _): (Data, Int) = try await fetch(url: url)
        let parsed = try await parseJSON(data: data, area: area)
        return parsed
    }
    
    private func makeURL(timeScale: NPTimeScale, currency: NPCurrency = .NOK, startDate: Date? = nil, endDate: Date? = nil) -> URL? {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(timeScale.rawValue)") else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "currency", value: currency.rawValue),
        ]
        
        if let startdate = startDate {
            urlComponents.queryItems?.append(URLQueryItem(name: "startDate", value: startdate.ISO8601Format()))
        }
        
        if let enddate = endDate {
            urlComponents.queryItems?.append(URLQueryItem(name: "endDate", value: enddate.ISO8601Format()))
        }
        
        return urlComponents.url ?? nil
    }
    
    private func fetch(url: URL) async throws -> (Data, Int) {
            let (data, response) = try await session.data(from: url)
            let statusCode = try validateHTTPResponse(response: response)
            return (data, statusCode)
        }
    
    private func validateHTTPResponse(response: URLResponse) throws -> Int {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIServiceError.invalidResponseType
            }
            
            guard 200...299 ~= httpResponse.statusCode ||
                  400...499 ~= httpResponse.statusCode
            else {
                throw APIServiceError.httpStatusCodeFailed(statusCode: httpResponse.statusCode)
            }
            
            return httpResponse.statusCode
        }
}
