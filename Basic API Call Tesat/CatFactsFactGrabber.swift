//
//  CatFactsFactGrabber.swift
//  Basic API Call Tests
//
//  Created by Jared Heeringa on 12/18/23.
//

import Foundation

func GrabARandomCatFact() async throws -> CatFact {
    // api endpoint setup
    let apiUrl = "https://catfact.ninja/fact"
    
    //convert our sting to URL object
    guard let urlObject = URL(string: apiUrl) else {
        throw ApiFailures.invalidURL
    }
    
    //do the get request here
    let (data, response) = try await URLSession.shared.data(from: urlObject)
    
    //handle the response code
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw ApiFailures.badServerReponse
    }
    
    // return the data
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(CatFact.self, from: data)
    } catch {
        throw ApiFailures.invalidJsonData
    }
}

// Cat facts object
struct CatFact: Codable {
    let fact: String
    let length: Int32
}

// error enum
enum ApiFailures: Error {
    case invalidURL
    case badServerReponse
    case invalidJsonData
    case CatImageFailed
}
