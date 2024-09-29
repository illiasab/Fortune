import Foundation
import SwiftUI

struct Meme: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
}

struct MemeResponse: Codable {
    let success: Bool
    let data: MemeData
}

struct MemeData: Codable {
    let memes: [Meme]
}


class MemeService {
    static let shared = MemeService()
    
   
    func fetchRandomMeme(completion: @escaping (Result<Meme, Error>) -> Void) {
        let url = URL(string: "https://api.imgflip.com/get_memes")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MemeResponse.self, from: data)
                    
                    if let randomMeme = response.data.memes.randomElement() {
                        completion(.success(randomMeme)) 
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No meme found"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
