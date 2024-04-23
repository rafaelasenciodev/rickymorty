//
//  CharacterRepositoryTest.swift
//  rickymortyTests
//
//  Created by Rafael Asencio Blancat on 23/4/24.
//

import XCTest
@testable import rickymorty

final class CharacterRepositoryTest: XCTestCase {

    var sut: GetCharacterListRepository!
    
    override func setUp() {
        super.setUp()
        sut = nil
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_loadCharactersSucceeds() async {
        sut = GetCharacterListRepositoryImp(dataSource:
                                                APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                            domainMapper: CharacterDomainMapper(),
                                            errorMapper: CharacterDomainErrorMapper())
        
        let result = await sut.loadCharacters(page: "1", name: "")
        switch result {
        case .success(let characters):
            let receivedCharacter = characters.first?.name
            let expectedCharacter = "Rick Sanchez"
            XCTAssertEqual(receivedCharacter, expectedCharacter)
        case .failure(let error):
            XCTFail("Failed test: \(error.localizedDescription)")
        }
    }
    
    func test_loadCharactersFailsWithDecodingError() async {
        sut = GetCharacterListRepositoryImp(dataSource:
                                                APICharactersDataSource(client: HTTPClientMockCharacterListDecodingFails()),
                                            domainMapper: CharacterDomainMapper(),
                                            errorMapper: CharacterDomainErrorMapper())
        
        let result = await sut.loadCharacters(page: "1", name: "")
        switch result {
        case .success:
            XCTFail("Expected failure, got \(result) instead")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, CharacterDomainError.decodingError.localizedDescription)
        }
    }
    
    func test_loadCharactersFailsWithInvalidURL() async {
        sut = GetCharacterListRepositoryImp(dataSource:
                                                APICharactersDataSource(client: HTTPClientMockCharacterListInvalidURLFails()),
                                            domainMapper: CharacterDomainMapper(),
                                            errorMapper: CharacterDomainErrorMapper())
        
        let result = await sut.loadCharacters(page: "1", name: "")
        switch result {
        case .success:
            XCTFail("Expected failure, got \(result) instead")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, CharacterDomainError.generic.localizedDescription)
        }
    }
}
