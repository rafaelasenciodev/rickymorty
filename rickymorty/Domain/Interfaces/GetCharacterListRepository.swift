//
//  GetCharacterListRepository.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

protocol GetCharacterListRepository {
    func loadCharacters() async -> Result<[Character], CharacterDomainError>
}
