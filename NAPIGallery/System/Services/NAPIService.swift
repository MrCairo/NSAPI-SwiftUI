//
//  NAPIService.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import UIKit
import Combine
import OSLog

enum NAPIServiceError: Error {
    case statusCode
    case decoding
    case invalidImage
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> NAPIServiceError {
        return (error as? NAPIServiceError) ?? .other(error)
    }
}

public class NAPIService {
    static let baseURL = URL(string: "https://api.nasa.gov/")!
    
    enum Error: LocalizedError, Identifiable {
        var id: String { localizedDescription }
        
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage."
            case .addressUnreachable(let url): return "\(url.absoluteString)"
            }
        }
    }
    
    public static var appVersion: String {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        } else {
            return "---"
        }
    }
    
    
    ///
    /// Performs a query to the NASA API site.
    ///
    /// - parameter endpoint: A String representing the endpoint excluding
    ///             the host. As an example: ```planetary/apod```
    /// - parameter queryParms: An array of URLQueryItem objects. Each item
    ///                         is then added to the GET query.
    ///
    /// - returns: A ```URLRequest``` object or nil if unable to initialize the request.
    ///
    class func getURLRequestFor(endpoint: String,
                                queryParms parms:[URLQueryItem],
                                failURLRequest: URLRequest = URLRequest(url: URL(fileURLWithPath: "."))) -> URLRequest {
        //
        // Sorta clean the parms by removing an existing "api_key" value and
        // then adding in the one with the correct value.
        var cleaned = parms.filter({ (item) -> Bool in return item.name != "api_key" })
        cleaned.append(URLQueryItem(name: "api_key", value: NAPIKey.shared.value))

        guard let url = baseURL
                .appendingPathComponent(endpoint)
                .withQueries(cleaned) else { return failURLRequest }
        
        #if DEBUG
        print("NAPIService GET: \(url)")
        #endif
        
        return URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(30))
    }
    
    static func standardDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }

}

extension URL {
    func withQueries(_ queries: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries //queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}

public class NAPILogger {
    static private let shared = NAPILogger()
    static private let log = Logger()

    class func info(_ message: String) {
        NAPILogger.log.info("\(message)")
    }
}
