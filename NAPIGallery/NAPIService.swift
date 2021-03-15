//
//  NAPIService.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import Foundation
import Combine

struct NAPIServiceResult {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

struct NAPIService2 {

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

    enum EndPoint {
        static let base = URL(string: "https://api.nasa.gov/")!
        static let apiKey = "uRzLWNLN9bEasIUbGkorbGaeJMCLiWAIAVPvV5Bz"

        case post
        case get

        var apodURL: URL {
            switch self {
            case .get:
                return EndPoint.base.appendingPathComponent("planetary/apod")
            case .post: // Post is not allowed
                return EndPoint.base
            }
        }

        static func requestAPOD(with url: URL, and model:APODDataModel) -> URLRequest {
            guard let encoded = try? JSONEncoder().encode(model) else {
                fatalError("Invalid")
            }

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded

            return request
        }
    }

    private let decoder = JSONDecoder() // Step 1
    
    func post(with apod: APODDataModel) -> AnyPublisher<APODDataModel, Error> { // Step 2
        URLSession.shared.dataTaskPublisher(for: EndPoint.requestAPOD(with: EndPoint.post.apodURL, and: apod)) // Step 3
            .map { $0.data } // Step 4
            .decode(type: APODDataModel.self, decoder: decoder) // Step 5
            .mapError { error in // Step 6
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.post.apodURL)
                default: return Error.invalidResponse
                }
            }
            .print() // Step 7
            .map { return $0 } // Step 8
            .eraseToAnyPublisher() // Step 9
    }
}

public class NAPIService: ObservableObject {
    fileprivate let apiKey = "uRzLWNLN9bEasIUbGkorbGaeJMCLiWAIAVPvV5Bz"
    fileprivate let baseURL = URL(string: "https://api.nasa.gov/")!
    
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
    func getURLRequestFor(endpoint: String,
                          queryParms parms:[URLQueryItem]) -> URLRequest? {
        //
        // Sorta clean the parms by removing an existing "api_key" value and
        // then adding in the one with the correct value.
        var cleaned = parms.filter({ (item) -> Bool in return item.name != "api_key" })
        cleaned.append(URLQueryItem(name: "api_key", value: apiKey))

        guard let url = baseURL
                .appendingPathComponent(endpoint)
                .withQueries(cleaned) else { return nil }
        
        return URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(30))
    }
}


class APODService: NAPIService {
    @Published private(set) var apodData: APODDataModel = APODDataModel()
    public private(set) var serviceResult: NAPIServiceResult?

    public func fetchAPOD() {
        if let request = self.getURLRequestFor(endpoint: "planetary/apod", queryParms: []) {
            URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: APODDataModel.self, decoder: JSONDecoder())
                .replaceError(with: APODDataModel())
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .assign(to: &$apodData)
        }
    }
    
    override public init() {
        super.init()
        fetchAPOD()
    }
}

extension URL {
    func withQueries(_ queries: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries //queries.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}

