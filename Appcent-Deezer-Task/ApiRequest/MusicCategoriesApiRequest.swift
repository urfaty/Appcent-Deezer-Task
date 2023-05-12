//
//  DeezerApi.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import Foundation

struct MusicCategoriesApiRequest {
    
    static let baseURL = "https://api.deezer.com"
    
    static func fetchMusicCategories(completion: @escaping (Result<[MusicCategory], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/genre") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let musicCategoriesResponse = try decoder.decode(MusicCategoriesResponse.self, from: data)
                completion(.success(musicCategoriesResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
