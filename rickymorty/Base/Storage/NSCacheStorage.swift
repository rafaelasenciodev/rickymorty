//
//  NSCacheStorage.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 24/4/24.
//

import Foundation

protocol StorageProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    func save(_ value: Value, forKey key: Key)
    func retrieve(forKey key: Key) -> Value?
    func removeValue(forKey key: Key)
    
    subscript(key: Key) -> Value? { get set }
}

final class NSCacheStorage<Key: Hashable, Value>: StorageProtocol {
    
    private let wrapped = NSCache<WrapperValue, Entry>()
    
    func save(_ value: Value, forKey key: Key) {
        let newEntry = Entry(value: value)
        let key = WrapperValue(key)
        wrapped.setObject(newEntry, forKey: key)
    }
    
    func retrieve(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrapperValue(key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrapperValue(key))
    }
    
    subscript(key: Key) -> Value? {
        get {
            wrapped.object(forKey:WrapperValue(key))?.value
        }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            save(value, forKey: key)
        }
    }
}

private extension NSCacheStorage {
    
    final class WrapperValue: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrapperValue else { return false }
            
            return value.key == key
        }
    }
}

private extension NSCacheStorage {
    
    final class Entry: NSObject {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}

