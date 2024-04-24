//
//  GetCharacterListUseCase.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

final class GetCharacterListUseCase {
    
    private let repository: GetCharacterListRepository
    init(repository: GetCharacterListRepository = GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: URLSessionHTTPClient()), domainMapper: CharacterDomainMapper(), errorMapper: CharacterDomainErrorMapper())) {
        self.repository = repository
    }
    
    func loadCharacters(page: String) async -> Result<[Character], CharacterDomainError> {
        await repository.loadCharacters(page: page, name: nil)
    }
    
    func searchCharacters(withName name: String, and page: String) async -> Result<[Character], CharacterDomainError> {
        await repository.loadCharacters(page: page, name: name)
    }
    
}
