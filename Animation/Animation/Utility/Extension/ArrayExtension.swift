//
//  ArrayExtension.swift
//  Animation
//
//  Created by Enes Urkan on 18.12.2021.
//

extension Collection {
    /**
     Get at index object
     
     - Parameters:
        - safeIndex: Index of object
     - Returns:
        - Element at index or nil
     */
    
    subscript (safeIndex index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

