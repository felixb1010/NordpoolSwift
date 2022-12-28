//
//  File.swift
//  
//
//  Created by Felix Bogen on 28/12/2022.
//

import Foundation

public enum APIServiceError: CustomNSError {
    
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int)
    case invalidData
    
    public static var errorDomain: String { "NordpoolAPI" }
    public var errorCode: Int {
        switch self {
        case .invalidURL: return 1
        case .invalidResponseType: return 2
        case .httpStatusCodeFailed: return 3
        case .invalidData: return 4
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case let .httpStatusCodeFailed(statusCode):
                text = "Error: Status Code \(statusCode)"
        case let .invalidData:
            text = "Invalid Data"
        }
        return [NSLocalizedDescriptionKey: text]
    }
}
