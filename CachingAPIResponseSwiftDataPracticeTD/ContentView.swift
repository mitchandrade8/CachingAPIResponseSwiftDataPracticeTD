//
//  ContentView.swift
//  CachingAPIResponseSwiftDataPracticeTD
//
//  Created by Mitch Andrade on 10/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Photo.id) private var photos: [Photo]
    
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
//        .modelContainer(for: [Photo].self)
}

@Model
class Photo: Codable {
    
    @Attribute(.unique)
    var id: Int?
    
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.id = try container.decode(Int?.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        //
    }
}

extension ContentView {
    
    func fetchPhotos() async throws {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        
        photos.forEach { modelContext.insert($0) }
        
    }
    
}
