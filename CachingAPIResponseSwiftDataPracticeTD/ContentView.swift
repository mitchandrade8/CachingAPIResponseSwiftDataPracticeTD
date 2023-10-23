//
//  ContentView.swift
//  CachingAPIResponseSwiftDataPracticeTD
//
//  Created by Mitch Andrade on 10/22/23.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { _ in
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            
                        Text("[Title here]")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                    }
                    
                    .padding(.bottom)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10,
                                                style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    
                   
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Posts")
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

#Preview {
    ContentView()
}
