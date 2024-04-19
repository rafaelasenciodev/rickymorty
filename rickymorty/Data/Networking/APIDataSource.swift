//
//  APIDataSource.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

protocol APIDataSource {
    func loadCharacters() async -> Result<[CharacterDTO], HTTPClientError>
}
