//
//  ListProvider.swift
//  Animation
//
//  Created by Enes Urkan on 19.12.2021.
//

import Foundation

final class ListProvider {
    static func getAllList() -> [Category] {
        let decoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else { return [] }
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let category = try? decoder.decode([Category].self, from: data) else { return [] }
        return category
    }
}
