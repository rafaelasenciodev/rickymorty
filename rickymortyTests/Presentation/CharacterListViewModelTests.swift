//
//  CharacterListViewModelTests.swift
//  rickymortyTests
//
//  Created by Rafael Asencio Blancat on 23/4/24.
//

import XCTest
@testable import rickymorty

class CharacterListViewModelTests: XCTestCase {
    
    
    var sut: CharacterListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = nil
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_loadCharactersShowLoader() async {
        // Given
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        // When
        sut.loadCharacters()
        
        // Then
        XCTAssertTrue(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadCharactersUpdatesUIWhenLoadingFinish() {
        // Given
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        // When
        let exp = expectation(description: "wait for completion")
        
        sut.loadCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.characters.count, 20)
    }
    
    func testLoadCharacters_Failure() {
        // Given
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListDecodingFails()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        
        let exp = expectation(description: "wait for completion")
        
        // When
        sut.loadCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
        
        // Then
        XCTAssertTrue(sut.showError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.characters.count, 0)
    }
}
