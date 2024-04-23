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
        "Status: \(character.status)"
    }
    
    var speciesDescription: String {
        "Species: \(character.species)"
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
        ScrollView {
            VStack(alignment: .leading) {
                
                backgroundImage
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
                    .padding(.bottom)
                
                Text(item.name)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(.white)
                
                Text(item.statusDescription)
                Text(item.speciesDescription)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    var backgroundImage: some View {
        AsyncImage(url: item.imageURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .scaledToFill()
    }
}

#Preview {
    CharacterDetailView(item: .init(character: Character(id: 1, name: "Rick", status: "Alive", species: "Human", origin: .init(name: "", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
}
