//
//  ContentView.swift
//  Basic API Call Tesat
//
//  Created by Jared Heeringa on 12/17/23.
//

// learning from:
// https://www.youtube.com/watch?v=ERr0GXqILgc
// SAMPLE API Call: https://jsonplaceholder.typicode.com/users/1
import SwiftUI

// 1. build dummy UI
// 2. created model for data
// 3. Write networking code
// 4. connect it all

struct ContentView: View {
    // whatdoes the ? mean? nullable???
    // ? means optional so we can have default values
    @State private var userData: User?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Section {
                        Circle()
                            .frame(width: 200)
                            .foregroundStyle(.secondary)
                        
                        Text("Name Here")
                            .fontWeight(.bold)
                            .font(.title)
                    }
                    
                    Section {
                        HStack {
                            Text("ID:")
                            Text("\(userData?.id ?? 0)") // Assuming id is an Int
                        }
                        
                        VStack {
                            HStack {
                               Text("Location:")
                                    .underline()
                                    .bold()
                                Spacer()
                            }
                            
                            HStack {
                                Text("Country:")
                                Text("USA")
                                Spacer()
                            }
                        
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                // .rask runs before a view is rendered
                .task {
                    do {
                        userData = try await getUserDataAsync()
                    } catch NetworkErrorIssue.invalidUrl {
                        print("Invalid URL")
                    } catch NetworkErrorIssue.badResponseCode {
                        print("Bad server reponse")
                    } catch NetworkErrorIssue.invalidData {
                        print("Bad data reponse")
                    } catch {
                        print("unxpected error")
                    }
                }
            }
            .navigationTitle("Random User Data")
        }
    }
    
    // ---------------------
    // in a view model usually or something
    // async function that throws an error if it fails and return a User object
    // throws allows us to throw errors
    func getUserDataAsync() async throws -> User {
        let apiEndpoint = "https://jsonplaceholder.typicode.com/users/1"
        
        // create a URL object from our URL string
        // TODO: Figure out what guard/let means in swift. This is new to me
        guard let urlObject = URL(string: apiEndpoint) else {
            throw NetworkErrorIssue.invalidUrl
        }
        
        // GET Request
        let (data, response) = try await URLSession.shared.data(from: urlObject)
        
        guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
            //otherwise handle the otehr errors here and check for other network codes/reponses
            throw NetworkErrorIssue.badResponseCode
        }
        
        // Print the raw data for debugging
        //print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
        
        // decode the json object we get back
        do {
            print()
            let decoder = JSONDecoder()
            //swift uses camel case only so if we get snake case we convert to what we declared in our object
            //decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // return the actual data
            return try decoder.decode(User.self, from: data)
        } catch {
            throw NetworkErrorIssue.invalidData
        }
    }
}

#Preview {
    ContentView()
}


// creating the model for the user data
// codable matches exact jason values to propery names
struct User: Codable {
    let id: Int32
    let name: String
    let username: String
}


enum NetworkErrorIssue: Error {
    case invalidUrl
    case badResponseCode
    case invalidData
}
