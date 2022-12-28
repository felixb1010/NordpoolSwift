//
//  NordpoolExec.swift
//  
//
//  Created by Felix Bogen on 27/12/2022.
//

import Foundation
import Nordpool

@main
struct NordpoolExec {
    //private static let api = XCAStocksAPI()
    static func main() async {
        do{
            let np = Nordpool()
            
            let objects = try await np.price(area: .Oslo, currency: .NOK, TimeScale: .hourly)
            let today = try await np.currentPrice(area: .Oslo, currency: .NOK)
            for object in objects {
                print("Value: \(object.Value), Area: \(object.Area), Date: \(object.date().formatted(.dateTime.hour().minute().day().month().year()))")
            }
            
            print(today)
        } catch jsonError.parseError(let err) {
            print(err)
        } catch {
            print(error)
        }
        
    }
}
