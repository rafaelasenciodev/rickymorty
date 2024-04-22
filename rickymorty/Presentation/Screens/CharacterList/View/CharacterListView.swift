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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView()
            }
            
            scrollView
        }
        .navigationTitle("Characters")
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
                let estimatedContentHeight = CGFloat(vm.characters.count * 300)
                let threshold = 0.8 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        await vm.loadCharacters()
                    }
                }
                contentHasScrolled = value < 0
            }
        })
    }
    
    var characterListView: some View {
        ForEach(vm.characters, id: \.id) { ch in
            
            CharacterViewCell(item: CharacterPresentableItem(character: ch))
                .padding(.horizontal, 12)
                .onTapGesture {
                    selectedCharacter = ch
                }
        }
        .sheet(item: $selectedCharacter) { selectedCharacter in
            CharacterDetailView(item: .init(character: selectedCharacter))
        }
    }
}

#Preview {
    ContentView()
}
