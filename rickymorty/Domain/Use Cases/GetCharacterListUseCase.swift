//
//  GetCharacterListUseCase.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

protocol GetCharacterListUseCaseProtocol {
    func execute(page: String, name: String?) async -> Result<[Character], CharacterDomainError>
}

final class GetCharacterListUseCase: GetCharacterListUseCaseProtocol {
    
    private let repository: GetCharacterListRepository
    init(repository: GetCharacterListRepository = GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: URLSessionHTTPClient()), domainMapper: CharacterDomainMapper(), errorMapper: CharacterDomainErrorMapper())) {
        self.repository = repository
    }
    
    func execute(page: String, name: String? = nil) async -> Result<[Character], CharacterDomainError> {
        await repository.loadCharacters(page: page, name: name)
    }
    
}
