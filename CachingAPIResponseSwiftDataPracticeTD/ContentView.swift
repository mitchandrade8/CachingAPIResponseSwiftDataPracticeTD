//
//  ContentView.swift
//  CachingAPIResponseSwiftDataPracticeTD
//
//  Created by Mitch Andrade on 10/22/23.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State private var photos: [Photo] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(photos, id: \.id) { item in
                    VStack(alignment: .leading) {
                        
                        AsyncImage(url: .init(string: item.url)) { image in
                                image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                            
                        Text(item.title)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                    }
                    
                    .padding(.bottom)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10,
                                                style: .continuous))
                    
                   
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Posts")
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .task {
                do {
                    try await fetchPhotos()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct Photo: Codable {
    let albumID: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

extension ContentView {
    
    func fetchPhotos() async throws {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        
        self.photos = photos
    }
    
}
