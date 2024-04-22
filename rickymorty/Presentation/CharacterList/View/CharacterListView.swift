//
//  CharacterListView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 20/4/24.
//

import SwiftUI

struct CharacterListView: View {
    
    @Bindable var vm: CharacterListViewModel
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(vm.characters) { character in
                        CharacterViewCell(character: character)
                        .padding(.horizontal, 12)
                    }
                }
            }
        }
        .navigationTitle("Characters")
        .onAppear {
            vm.loadCharacters()
        }
    }
}

#Preview {
    ContentView()
}
