//
//  CharacterResponseDTO.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

struct CharacterResponseDTO: Decodable {
    
    let info: CharacterInfoDTO
    let results: [CharacterDTO]
    
    struct CharacterInfoDTO: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
