//
//  CharacterDetailView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 22/4/24.
//

import SwiftUI

struct CharacterPresentableItem {
    
    private let character: Character
    init(character: Character) {
        self.character = character
    }
    
    var imageURL: URL? {
        URL(string: character.image)
    }
    
    var name: String {
        character.name
    }
    
    var origin: String {
        character.origin.name
    }
    
    var aliveDescription: String {
        character.status
    }
    
    var statusDescription: String {
        character.status
    }
    
    var speciesDescription: String {
        character.species
    }
    
    var statusColor: Color {
        switch character.status {
        case "Alive": return .green
        case "Dead": return .red
        default: return .gray
        }
    }
}
struct CharacterDetailView: View {
    
    var item: CharacterPresentableItem
    
    var body: some View {
        List {
            
            Section {
                headerTitle
                
                SectionView(keyTitle: "character_detail_info_status",
                            description: item.statusDescription)
                    .padding(.vertical, 8)
                
                SectionView(keyTitle: "character_detail_info_species", description: item.speciesDescription)
                    .padding(.vertical, 8)
                
                SectionView(keyTitle: "character_detail_info_origin", description: item.origin)
                    .padding(.vertical, 8)
            } header: {
                headerView
                .padding()
                .frame(maxWidth: .infinity)
            }
            .listRowSeparator(.hidden)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    var headerTitle: some View {
        Text(LocalizedStringKey("character_detail_info_section"))
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.secondary)
    }
    
    var headerView: some View {
        VStack(alignment: .center) {
            backgroundImage
                .padding(.bottom)
            
            Text(item.name)
                .font(.system(size: 30, weight: .black))
        }
    }
    
    var backgroundImage: some View {
        AsyncImage(url: item.imageURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 300, height: 300)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(lineWidth: 8)
                .fill(item.statusColor)
                .overlay(content: {
                    Text(item.aliveDescription)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(item.statusColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: 20.0)
                })
        )
        .scaledToFill()
    }
}

#Preview {
    CharacterDetailView(item: .init(character: Character(id: 1, name: "Rick", status: "Alive", species: "Human", origin: .init(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
}
