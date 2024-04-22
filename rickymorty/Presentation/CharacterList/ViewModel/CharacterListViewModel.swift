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
    var errorMessage: String?
    
    private let useCase: GetCharacterListUseCase
    init(useCase: GetCharacterListUseCase = GetCharacterListUseCase()) {
        self.useCase = useCase
    }
    
    @MainActor
    func loadCharacters() {
        self.isLoading = false
        Task {
            let result = await useCase.execute()
            switch result {
            case .success(let characters):
                self.isLoading = false
                self.characters = characters
            case .failure(let error):
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
