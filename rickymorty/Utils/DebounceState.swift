//
//  DebounceState.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 7/5/24.
//

import Foundation

final class DebounceState<Value>: ObservableObject {
    @Published var currentValue: Value
    @Published var debouncedValue: Value
    
    init(initialValue: Value, delay: Double = 0.5) {
        self._currentValue = Published(initialValue: initialValue)
        self._debouncedValue = Published(initialValue: initialValue)
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}
