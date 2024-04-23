//
//  CharacterDomainErrorMapper.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import Foundation

class CharacterDomainErrorMapper {
    func map(error: HTTPClientError?) -> CharacterDomainError {
        switch error {
        case .decodingError:
            return .decodingError
        default:
            return .generic
        }
    }
}
