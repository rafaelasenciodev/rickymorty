//
//  URLSessionHTTPClient.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        
        guard let url = URL(string: request) else { return .failure(.invalidURL) }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            guard (200...299).contains(response.statusCode) else {
                let error = handleResponseError(with: response.statusCode)
                return .failure(error)
            }
            return .success(data)
        } catch {
            return .failure(.generic)
        }
    }
    
    private func handleResponseError(with statusCode: Int) -> HTTPClientError {
        guard statusCode < 500 else {
            return .clientError
        }
        return .serverError
    }
}
