//
//  Track.swift
//  Animation
//
//  Created by Enes Urkan on 15.12.2021.
//

struct Track: Codable {
    let id               : String
    let title            : String
    let leatherTitle     : String
    let season           : Int?
    let episode          : Int?
    let parent           : Parent?
    let backgroundContent: BackgroundContent?
}
