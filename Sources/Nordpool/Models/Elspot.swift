//
//  File.swift
//  
//
//  Created by Felix Bogen on 27/12/2022.
//

import Foundation

public struct NPOptions {
    public let zone: NPZone
    public let currency: NPCurrency
    public let tax: Double
    public let fee: Double
    public let timeScale: NPTimeScale
}

public struct NPPrice: Identifiable, Hashable{
    public let id = UUID()
    public let TimeStamp: String
    public let Area: NPZone
    public let Value: String
    public let Currency: String
    
    public func date() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.TimeStamp) ?? Date()
    }
    
    @available(macOS 13.0, iOS 16, *)
    public func priceNumber(tax: Double = 0.0, fee: Double = 0.0) -> Double{
        var number = self.Value
        number.replace(" ", with: "")
        number.replace(",", with: ".")
        return round(((Double(number)! / 1000) * (1.0 + tax) + fee) * 100) / 100
    }
    
    public static func now(_ opts: NPOptions) async throws -> NPPrice {
        let price = try? await Nordpool.shared.currentPrice(area: opts.zone, currency: opts.currency)
        guard let a = price else {throw APIServiceError.invalidData}
        return a
    }
    
    public static func price(_ opts: NPOptions) async throws -> [NPPrice] {
        let price = try? await Nordpool.shared.price(area: opts.zone, currency: opts.currency, TimeScale: opts.timeScale)
        guard let a = price else {throw APIServiceError.invalidData}
        return a
    }
}

public extension [NPPrice]{
    func current() -> NPPrice?{
        let currentHour = Calendar.current.component(.hour, from: Date())
        return self.first{ item in
            let eventHour = Calendar.current.component(.hour, from: item.date())
            return eventHour == currentHour
        }
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    func max() -> NPPrice? {
            let maxValue = self.max(by: {(strøm1, strøm2)-> Bool in
                return strøm1.priceNumber() < strøm2.priceNumber()
            })
            return maxValue
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    func min() -> NPPrice?{
            let minValue = self.min(by: {(strøm1, strøm2)-> Bool in
                return strøm1.priceNumber() < strøm2.priceNumber()
            })
            return minValue
        }
    
    @available(iOS 16.0, macOS 13.0, *)
    func getChartData() -> [Double]?{
            var doubls: [Double] = []
            for item in self{
                doubls.append(item.priceNumber())
            }
            return doubls
        }
}


public enum NPTimeScale: String{
    case hourly = "/marketdata/page/10"
    case daily = "/marketdata/page/11"
    case weekly = "/marketdata/page/12"
    case monthly = "/marketdata/page/13"
    case yearly = "/marketdata/page/14"
    
    public static let allCases: [NPTimeScale] = [hourly, daily, weekly, monthly, yearly]
}

public struct options: Encodable {
    public let currency: String
    public let endDate: Date
    public let startDate: Date
}

    public func parseJSON(data: Data, area: NPZone) async throws -> [NPPrice] {
        do {
            var objects: [NPPrice] = []
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {throw jsonError.parseError(error: "Invalid json")}
            let currency = json["currency"] as? String ?? "NOK"
            guard let data = json["data"] as? [String: Any] else {throw jsonError.parseError(error: "Inavlid json.data")}
            guard let rows = data["Rows"] as? [[String: Any]] else { throw jsonError.parseError(error: "Inavlid json.data.rows") }

            for row in rows where row["IsExtraRow"] as? Bool == false {
                let timeStamp = row["StartTime"] as? String ?? "No TimeStamp"
                if let value = (row["Columns"] as? [[String: Any]])?.first(where: { $0["Name"] as? String == area.rawValue })?["Value"] as? String {
                    let object = NPPrice(TimeStamp: timeStamp, Area: area, Value: value, Currency: currency)
                    objects.append(object)
                }
            }
            return objects
        } catch {
            throw error
        }
    }

public enum jsonError: Error{
    case parseError(error: String)
}

public enum NPCurrency: String, Codable {
    case EUR
    case SEK
    case NOK
    case DKK
    
    public static let allCases: [NPCurrency] = [EUR, SEK, NOK, DKK]
}

public enum NPZone: String, Codable {
    case SYS
    case SE1
    case SE2
    case SE3
    case SE4
    case FI
    case DK1
    case DK2
    case Oslo
    case Kristiansand = "Kr.sand"
    case Bergen
    case Molde
    case Trondheim = "Tr.heim"
    case Tromso
    case EE
    case LV
    case LT
    case AT
    case BE
    case DE_LU = "DE-LU"
    case FR
    case NL
    
    public static let allCases: [NPZone] = [.SYS, .SE1, .SE2, .SE3, .SE4, .FI, .DK1, .DK2, .Oslo, .Kristiansand, .Bergen, .Molde, .Trondheim, .Tromso, .EE, .LV, .LT, .AT, .BE, .DE_LU, .FR, .NL]
}
