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
    @State private var searchText: String = ""
    
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
        .navigationTitle("Characters")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .onChange(of: searchText, { oldValue, newValue in
            searchCharacter(by: newValue)
        })
        .sheet(item: $selectedCharacter) { selectedCharacter in
            CharacterDetailView(item: .init(character: selectedCharacter))
        }
        .alert("\(vm.errorMessage ?? "")", isPresented: $vm.showError, actions: {
            Button(role: .cancel) {
                
            } label: {
                Text("Continue")
            }
        })
        .onAppear {
            vm.loadCharacters()
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
                        if searchText.isEmpty {
                            vm.loadCharacters()
                        } else {
                            await self.vm.searchCharacter(by: searchText, isFirstLoad: false)
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
    
    @MainActor
    private func searchCharacter(by name: String) {
        vm.workItem?.cancel()
        let task = DispatchWorkItem { [weak vm] in
            guard let viewModel = vm else { return }
            Task {
                await viewModel.searchCharacter(by: name, isFirstLoad: true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        vm.workItem = task
    }
}

#Preview {
    ContentView()
}
