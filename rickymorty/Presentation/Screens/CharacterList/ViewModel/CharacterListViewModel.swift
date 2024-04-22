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
            let result = await useCase.execute(page: "\(currentPage)")
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
}
