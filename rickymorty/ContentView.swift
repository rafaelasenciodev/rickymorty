//
//  ContentView.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 19/4/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            CharacterListView(vm: CharacterListViewModel())
        }
    }
}

#Preview {
    ContentView()
}
