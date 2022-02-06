//
//  ContentView.swift
//  SomethingToWatch
//
//  Created by MAC on 26/01/2022.
//

import SwiftUI

struct Genre: Identifiable {
    let id: Int
    let name: String
}
struct ContentView: View {
    let genres = [
        Genre(id: 0,name: "action"),
        Genre(id: 1,name: "comedy"),
        Genre(id: 2, name: "sci-fi"),
        Genre(id: 3, name: "western"),
        Genre(id: 4, name: "thriller"),
        Genre(id: 5, name: "horror"),
        Genre(id: 6, name: "fantasy"),
        Genre(id: 7, name: "criminal"),
        Genre(id: 8, name: "avant-garde"),
        Genre(id: 9, name: "animated")
    ]
    
    var body: some View {
        NavigationView {
            List(genres) { genre in
                NavigationLink(destination: YearsView(genre: genre.name)) {
                        Text(genre.name)
                            .font(.system(size:20))
                            .frame(height: 60)
                    }
                    }
            .navigationTitle("Choose your genre")
            
            
        }
      
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

