//
//  AlbumDetailApiRequest.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation

struct AlbumDetailApiRequest {
    
    static func fetchAlbumDetails(albumId: Int, completion: @escaping (Result<AlbumDetail, Error>) -> Void) {
        let urlString = "https://api.deezer.com/album/\(albumId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let albumDetail = try decoder.decode(AlbumDetail.self, from: data)
                completion(.success(albumDetail))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
