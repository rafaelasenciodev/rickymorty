//
//  CharacterListView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 20/4/24.
//

import SwiftUI

struct CharacterListView: View {
    
    @Bindable var vm: CharacterListViewModel
    @State var contentHasScrolled = false
    @State var selectedCharacter: Character?
//    @State private var searchText: String = ""
    @StateObject private var filterText = DebounceState(initialValue: "")
    
    private var charactersResult: [Character] {
        vm.characters
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView()
            }
            
            scrollView
        }
        .navigationTitle(LocalizedStringKey("characters_nav_title"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $filterText.currentValue)
        .onChange(of: filterText.debouncedValue, { oldValue, newValue in
            newSearchCharacter(by: newValue)
        })
        .sheet(item: $selectedCharacter) { selectedCharacter in
            CharacterDetailView(item: .init(character: selectedCharacter))
        }
        .alert("\(vm.errorMessage ?? "")", isPresented: $vm.showError, actions: {
            Button(role: .cancel) {
                
            } label: {
                Text(LocalizedStringKey("common_continue"))
            }
        })
        .task {
            loadCharacters()
        }
    }
    
    var scrollView: some View {
        ScrollView {
            scrollDetectionView
            characterListView
        }.coordinateSpace(.named("scroll"))
    }
    
    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                let estimatedContentHeight = CGFloat(charactersResult.count * 300)
                let threshold = 0.8 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        if filterText.debouncedValue.isEmpty {
                            await vm.loadCharacters()
                        } else {
                            await self.vm.searchCharacter(by: filterText.debouncedValue, isFirstLoad: false)
                        }
                    }
                }
                contentHasScrolled = value < 0
            }
        })
    }
    
    var characterListView: some View {
        ForEach(Array(charactersResult.enumerated()), id: \.offset) { index, character in
            
            CharacterViewCell(item: CharacterPresentableItem(character: character))
                .padding(.horizontal, 12)
                .onTapGesture {
                    selectedCharacter = character
                }
            if vm.isLoading {
                ProgressView()
                    .tint(.orange)
            }
        }
    }
    
    private func newSearchCharacter(by name: String) {
        Task {
            await vm.searchCharacter(by: name, isFirstLoad:true)
        }
    }
    
    private func loadCharacters() {
        Task {
            await vm.loadCharacters()
        }
    }
}

#Preview {
    ContentView()
}
