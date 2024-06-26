//
//  CharacterDTO.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String?
    let status: String?
    let species: String?
    let origin: OriginDTO?
    let image: String?
}
