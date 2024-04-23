//
//  APIDataSource.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

protocol APIDataSource {
    func loadCharacters(page: String, name: String?) async -> Result<[CharacterDTO], HTTPClientError>
}

protocol HTTPClient {
    func makeRequest(request: String) async -> Result<Data, HTTPClientError>
}

final class APICharactersDataSource: APIDataSource {
    
    private let client: HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadCharacters(page: String, name: String? = nil) async -> Result<[CharacterDTO], HTTPClientError> {
        var endpoint = "https://rickandmortyapi.com/api/character" //+ "/?page=\(page)"
        if let name = name {
            endpoint.append("?name=\(name)")
            endpoint.append("&page=\(page)")
        } else {
            endpoint.append("?page=\(page)")
        }
        
        
        let response = await client.makeRequest(request: endpoint)
        guard case .success(let data) = response else { 
            return .failure(handleError(error: response.failureValue as? HTTPClientError))
        }
        
        guard let response = try? JSONDecoder().decode(CharacterResponseDTO.self, from: data) else {
            return .failure(.decodingError)
        }
        
        return  .success(response.results)
    }
    
    private func handleError(error: HTTPClientError?) -> HTTPClientError {
        return error ?? .generic
    }
}
