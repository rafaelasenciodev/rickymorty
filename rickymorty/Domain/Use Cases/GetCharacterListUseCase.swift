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
    
    func execute(page: String) async -> Result<[Character], CharacterDomainError> {
        let result = await repository.loadCharacters(page: page)
        
        guard let characterList = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(characterList)
    }
    
}
