//
//  music.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/26.
//

import Foundation
struct SongResults: Codable {
    let resultCount: Int
    let results: [SongType]
}

struct SongType: Codable {
    let artistName: String
    let collectionName: String
    let trackName: String
    let previewUrl: URL?
    let releaseDate: String
    let artworkUrl100: String
    let trackCensoredName: String
}
