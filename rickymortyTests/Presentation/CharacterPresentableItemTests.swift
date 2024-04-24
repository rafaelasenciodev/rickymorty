//
//  CharacterPresentableItemTests.swift
//  rickymortyTests
//
//  Created by Rafael Asencio Blancat on 23/4/24.
//

import XCTest
@testable import rickymorty

final class CharacterPresentableItemTests: XCTestCase {
    
    func test_init() {
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", origin: Origin(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        
        let presentableItem = CharacterPresentableItem(character: character)
        
        XCTAssertEqual(presentableItem.name, "Rick Sanchez")
        XCTAssertEqual(presentableItem.origin, "Earth")
        XCTAssertEqual(presentableItem.aliveDescription, "Alive")
        XCTAssertEqual(presentableItem.statusDescription, "Status: Alive")
        XCTAssertEqual(presentableItem.speciesDescription, "Species: Human")
        XCTAssertEqual(presentableItem.statusColor, .green)
    }
    
    func test_imageURLWithValidURL() {
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", origin: Origin(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        let presentableItem = CharacterPresentableItem(character: character)
        
        let imageURL = presentableItem.imageURL
        
        XCTAssertEqual(imageURL, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
    }
    
    func test_imageURLWithInvalidURL() {
        let character = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", origin: Origin(name: "Earth", url: ""), image: "invalid_url")
        let presentableItem = CharacterPresentableItem(character: character)
        
        XCTAssertFalse(UIApplication.shared.canOpenURL(presentableItem.imageURL!))
    }
    
    func test_statusColorWhenDead() {
        let character = Character(id: 1, name: "Rick Sanchez", status: "Dead", species: "Human", origin: Origin(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        let presentableItem = CharacterPresentableItem(character: character)
        
        let statusColor = presentableItem.statusColor
        
        XCTAssertEqual(statusColor, .red)
    }
    
    func test_statusColorOtherStatus() {
        let character = Character(id: 1, name: "Rick Sanchez", status: "Unknown", species: "Human", origin: Origin(name: "Earth", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        let presentableItem = CharacterPresentableItem(character: character)
        
        let statusColor = presentableItem.statusColor
        
        XCTAssertEqual(statusColor, .gray)
    }
}
