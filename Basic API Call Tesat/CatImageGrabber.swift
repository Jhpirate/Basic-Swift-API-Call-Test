//
//  CatImageGrabber.swift
//  Basic API Call Tests
//
//  Created by Jared Heeringa on 12/18/23.
//

import Foundation

// api endpoint = https://source.unsplash.com/random/300x300/?cat

func GrabARandomCatPicture() async throws -> CatImage {
    let url = "https://source.unsplash.com/random/300x300/?cat"
    
    guard let urlObject = URL(string: url) else {
        throw ApiFailures.invalidURL
    }

    
    do {
        let (data, _) = try await URLSession.shared.data(from: urlObject)
        return CatImage(image: data)
    } catch {
        throw ApiFailures.CatImageFailed
    }
    
    // not needed becuase its not JSON
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(CatImage.self, from: data)
//    } catch {
//        throw ApiFailures.invalidJsonData
//    }
}

struct CatImage: Codable {
    let image: Data
}
