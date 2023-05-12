//
//  LocalDatabaseForLikedSongs.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation

class LocalDatabase {
    
    static let shared = LocalDatabase()
    private let likedSongsKey = "likedSongs"
    
    private init() {}
    
    func saveLikedSong(_ song: Track) {
        var likedSongs = getLikedSongs()
        likedSongs.append(song)
        if let data = try? JSONEncoder().encode(likedSongs) {
            UserDefaults.standard.set(data, forKey: likedSongsKey)
        }
    }
    
    func removeLikedSong(_ song: Track) {
        var likedSongs = getLikedSongs()
        likedSongs.removeAll { $0.id == song.id }
        if let data = try? JSONEncoder().encode(likedSongs) {
            UserDefaults.standard.set(data, forKey: likedSongsKey)
        }
    }
    
    func isSongLiked(_ song: Track) -> Bool {
        let likedSongs = getLikedSongs()
        return likedSongs.contains { $0.id == song.id }
    }
    
    func getLikedSongs() -> [Track] {
        if let data = UserDefaults.standard.data(forKey: likedSongsKey),
           let likedSongs = try? JSONDecoder().decode([Track].self, from: data) {
            return likedSongs
        }
        return []
    }
}
