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
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        sut.loadCharacters()
        XCTAssertTrue(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.characters.count, 0)
    }
    
    func test_loadCharactersUpdatesUIWhenLoadingFinish() {
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListSuccess()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        let exp = expectation(description: "wait for completion")
        sut.loadCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.characters.count, 20)
    }
    
    func testLoadCharacters_Failure() {
        sut = .init(useCase: GetCharacterListUseCase(repository:
                                                        GetCharacterListRepositoryImp(dataSource: APICharactersDataSource(client: HTTPClientMockCharacterListDecodingFails()),
                                                                                      domainMapper: CharacterDomainMapper(),
                                                                                      errorMapper: CharacterDomainErrorMapper())))
        
        let exp = expectation(description: "wait for completion")
        sut.loadCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
        XCTAssertTrue(sut.showError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.characters.count, 0) // La lista de personajes debe estar vacía si hay un error
    }
}
