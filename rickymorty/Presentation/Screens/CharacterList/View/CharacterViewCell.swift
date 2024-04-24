//
//  CharacterViewCell.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 22/4/24.
//

import SwiftUI

struct CharacterViewCell: View {
    
    let item: CharacterPresentableItem
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack {
            if let url = item.imageURL {
                AsyncImageView(url: url)
                    .scaledToFill()
                    .frame(height: 300)
                    .overlay(content: {
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0),
                                                                   Color.black.opacity(0.3),
                                                                   Color.black]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                    })
                    .overlay {
                        descriptionInfo
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .frame(height: 300)
                    .onAppear {
                        withAnimation {
                            opacity = 1
                        }
                    }
                    
            }
        }
        .opacity(opacity)
    }
    
    var descriptionInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title2).bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .overlay(alignment: .topTrailing, content: {
                statusIndicator
            })
            .padding()
        }
    }
    
    var statusIndicator: some View {
        Circle()
            .fill(item.statusColor)
            .frame(width: 15, height: 15)
    }
}

#Preview {
    CharacterViewCell(item: .init(character: .init(id: 1, name: "Rick", status: "Alive", species: "", origin: .init(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
}
