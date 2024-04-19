//
//  GetCharacterListUseCase.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

final class GetCharacterListUseCase {
    
    private let repository: GetCharacterListRepository
    init(repository: GetCharacterListRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<[Character], CharacterDomainError> {
        let result = await repository.loadCharacters()
        
        guard let characterList = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(characterList)
    }
    
}
