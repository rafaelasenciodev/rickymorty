//
//  GetCharacterListRepositoryImpTests.swift
//  rickymortyTests
//
//  Created by Rafael Asencio Blancat on 23/4/24.
//

import Foundation
@testable import rickymorty

final class HTTPClientMockCharacterListSuccess: HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        let data = CharacterListMock.dataResponse()
        return .success(data)
    }
}

final class HTTPClientMockCharacterListDecodingFails: HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        let json: [String: Any] = [
            "info": [
                "count": 123,
                "pages": 1
            ],
            "results": [
                [
                    "id": "invalid id",
                    "name": 123
                ]
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        return .success(data)
    }
}

final class HTTPClientMockCharacterListInvalidStatusCodeFails: HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        return .failure(.invalidStatusCode(code: 400))
    }
}

final class HTTPClientMockSearchCharacterListSuccess: HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        let json: [String: Any] = [
            "info": [
                "count": 10,
                "pages": 1
            ],
            "results": [
                [
                    "id": 2,
                    "name": "Morty"
                ]
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        return .success(data)
    }
}

final class HTTPClientMockSearchCharacterEmptyList: HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError> {
        let json: [String: Any] = [
            "info": [
                "count": 123,
                "pages": 1
            ],
            "results": []
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        return .success(data)
    }
}
