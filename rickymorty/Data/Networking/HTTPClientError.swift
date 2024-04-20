//
//  HTTPClientError.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

enum HTTPClientError: Error {
    case clientError
    case serverError
    case decodingError
    case invalidURL
    case invalidResponse
    case invalidStatusCode(code: Int)
    case generic
}
