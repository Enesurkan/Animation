//
//  Category.swift
//  Animation
//
//  Created by Enes Urkan on 14.12.2021.
//

struct Category: Codable {
    let id     : String
    let title  : String
    let tracks : [Track]?
}
