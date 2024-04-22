//
//  GetCharacterListRepositoryImp.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation


final class GetCharacterListRepositoryImp: GetCharacterListRepository {
    
    private let dataSource: APIDataSource
    private let domainMapper: CharacterDomainMapper
    private let errorMapper: CharacterDomainErrorMapper
    init(dataSource: APIDataSource, 
         domainMapper: CharacterDomainMapper,
         errorMapper: CharacterDomainErrorMapper) {
        self.dataSource = dataSource
        self.domainMapper = domainMapper
        self.errorMapper = errorMapper
    }
    
    func loadCharacters(page: String) async -> Result<[Character], CharacterDomainError> {
        let characterListResult = await dataSource.loadCharacters(page: page)
        
        guard case .success(let characterList) = characterListResult else {
            return .failure(errorMapper.map(error: characterListResult.failureValue as? HTTPClientError))
        }

        let result = domainMapper.map(characterList: characterList)
        return .success(result)
    }
}
