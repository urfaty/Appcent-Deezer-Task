//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation

struct AlbumsOfSelectedArtist: Codable {
    let id: Int
    let title: String
    let link: String
    let cover: String
    let cover_small: String
    let cover_medium: String
    let cover_big: String
    let cover_xl: String
    let release_date: String
}

struct AlbumsOfSelectedArtistResponse: Codable {
    let data: [AlbumsOfSelectedArtist]
}

