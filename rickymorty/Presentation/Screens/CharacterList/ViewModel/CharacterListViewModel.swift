//
//  CharacterListViewModel.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 20/4/24.
//

import SwiftUI

@Observable final class CharacterListViewModel: ObservableObject {
    
    var characters: [Character] = []
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String?
    private var currentPage: Int = 1
    var workItem: DispatchWorkItem?
    
    private let useCase: GetCharacterListUseCase
    init(useCase: GetCharacterListUseCase = GetCharacterListUseCase()) {
        self.useCase = useCase
    }
    
    @MainActor
    func loadCharacters() {
        guard !isLoading else { return }
        self.isLoading = true
        self.showError = false
       
        Task {
            let result = await useCase.loadCharacters(page: "\(currentPage)")
            switch result {
            case .success(let characters):
                self.isLoading = false
                self.characters += characters
                self.currentPage += 1
            case .failure(let error):
                self.isLoading = false
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func searchCharacter(by name: String, isFirstLoad: Bool) async {
        if name.isEmpty {
            resetSearch()
            return
        }
        guard !isLoading, canFetchMoreCharacters else { return }
        isLoading = true
        if isFirstLoad {
            currentPage = 1
            characters = []
        }
        await fetchSearchCharacter(by: name)
    }
    
    
    private func fetchSearchCharacter(by name: String) async {
        let result = await useCase.searchCharacters(withName: name, and: "\(currentPage)")
        
        switch result {
        case .success(let characters):
            self.isLoading = false
            self.characters += characters
            self.currentPage += 1
            self.canFetchMoreCharacters = true
        case .failure:
            await self.handleError()
        }
    }

    private var canFetchMoreCharacters: Bool = true

    @MainActor
    private func resetSearch() {
        canFetchMoreCharacters = true
        characters = []
        currentPage = 1
        loadCharacters()
    }
    
    private func handleError() async {
        if characters.isEmpty {
            await MainActor.run {
                isLoading = false
            }
        } else {
            await MainActor.run {
                isLoading = false
                canFetchMoreCharacters = false
            }
        }
    }
}
