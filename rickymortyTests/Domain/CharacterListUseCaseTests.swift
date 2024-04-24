//
//  CharacterListUseCaseTests.swift
//  rickymortyTests
//
//  Created by Rafael Asencio Blancat on 23/4/24.
//

import XCTest
@testable import rickymorty

final class CharacterListUseCaseTests: XCTestCase {

    var sut: GetCharacterListUseCase!
    
    override func setUp() {
        super.setUp()
        sut = nil
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_loadCharactersSucceeds() async {
        // Given
        sut = GetCharacterListUseCase(repository:
                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                                                      domainMapper: CharacterDomainMapper(),
                                                                      errorMapper: CharacterDomainErrorMapper()))
        // When
        let result = await sut.loadCharacters(page: "1")
        
        // Then
        switch result {
        case .success(let characters):
            XCTAssertEqual(1, characters.first?.id)
        case .failure(let error):
            XCTFail("Expected success, got \(error.localizedDescription)")
        }
    }
    
    
    func test_searchCharacterByNameSucceeds() async {
        // Given
        sut = GetCharacterListUseCase(repository:
                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockSearchCharacterListSuccess()),
                                                                      domainMapper: CharacterDomainMapper(),
                                                                      errorMapper: CharacterDomainErrorMapper()))
        
        // When
        let result = await sut.searchCharacters(withName: "Morty", and: "1")
        
        // Then
        switch result {
        case .success(let characters):
            XCTAssertEqual(2, characters.first?.id)
            XCTAssertEqual("Morty", characters.first?.name)
        case .failure(let error):
            XCTFail("Expected success, got \(error.localizedDescription)")
        }
    }
    
    func test_unexistingCharacterReturnsEmptyList() async {
        // Given
        sut = GetCharacterListUseCase(repository:
                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockSearchCharacterEmptyList()),
                                                                      domainMapper: CharacterDomainMapper(),
                                                                      errorMapper: CharacterDomainErrorMapper()))
        // When
        let result = await sut.searchCharacters(withName: "unexsiting character", and: "1")
        
        // Then
        switch result {
        case .success(let characters):
            XCTAssertTrue(characters.isEmpty)
        case .failure(let error):
            XCTFail("Expected success, got \(error.localizedDescription)")
        }
    }

    
//    func test_getCharacterListFailsWithParsedError() async {
//        do {
//            let response = try await sutFailure?.getCharacterList(pageNumber: "1")
//            XCTFail("Expected failure, got \(String(describing: response)) instead")
//        } catch {
//            if error is APIError {
//                XCTAssertEqual(error.localizedDescription, APIError.parseError.localizedDescription)
//            } else {
//                XCTFail("Expected parsed error, got \(error) instead")
//            }
//        }
//    }
//    
//    func test_seachCharacterFails() async {
//        do {
//            let response = try await sutFailure?.searchCharacter(withName: "Peter", and: nil)
//            XCTFail("Expected failure, got \(String(describing: response)) instead")
//        } catch {
//            //Test succeeds
//        }
//    }
}
