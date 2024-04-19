//
//  CharacterDomainMapper.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

class CharacterDomainMapper {
    func map(characterList: [CharacterDTO]) -> [Character] {
        
        return characterList.map {
            Character(id: $0.id,
                      name: $0.name ?? "",
                      status: $0.status ?? "",
                      species: $0.species ?? "",
                      origin: $0.origin ?? "",
                      image: $0.image ?? "")
        }
    }
}
