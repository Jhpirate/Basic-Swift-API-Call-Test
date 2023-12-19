//
//  CatFacts.swift
//  Basic API Call Tests
//
//  Created by Jared Heeringa on 12/18/23.
//

import SwiftUI

struct CatFacts: View {
    @State private var catFactData: CatFact?
    @State private var catImageData: CatImage?
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    if let catImageData = catImageData,
                       let uiImage = UIImage(data: catImageData.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(Color.secondary, lineWidth: 2))
                    } else {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 250, height: 250)
                            .foregroundStyle(.secondary)
                            .opacity(0.5)
                    }
                        
                    
                    VStack {
                        Text("Random fact of the day!")
                            .bold()
                        Text("\(catFactData?.fact ?? "Place Holder Fact")")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // make the button api call async with hte task included here
                        Task {
                            await fetchCatFact()
                            await getCatImage()
                        }
                    }){
                        Text("Get a Fact")
                            .padding()
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Cat Facts!")
            .overlay(
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                        .scaleEffect(5)
                                }
                            }
                            .padding(),
                            alignment: .center
                        )
            
        }
        .task {
            isLoading = true
            await fetchCatFact()
            await getCatImage()
            isLoading = false
        }
    }
    
    // Function to fetch a cat fact
        func fetchCatFact() async {
            do {
                catFactData = try await GrabARandomCatFact()
            } catch ApiFailures.invalidURL {
                print("Bad URL")
            } catch ApiFailures.badServerReponse {
                print("Bad Server Reponse")
            } catch ApiFailures.invalidJsonData {
                print("Bad JSON data returned")
            } catch {
                print("Unexpected error")
            }
        }
    
    // fetch a cat image
    func getCatImage() async {
        do {
            catImageData = try await GrabARandomCatPicture()
        } catch {
            print("error")
        }
    }
}

#Preview {
    CatFacts()
}
