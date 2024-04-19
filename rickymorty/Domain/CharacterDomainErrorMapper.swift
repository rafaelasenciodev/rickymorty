//
//  CharacterDomainErrorMapper.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

class CharacterDomainErrorMapper {
    func map(error: HTTPClientError?) -> CharacterDomainError {
        return .generic
    }
}
