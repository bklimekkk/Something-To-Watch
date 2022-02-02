//
//  ResultView.swift
//  SomethingToWatch
//
//  Created by Bartosz Klimek on 02/02/2022.
//

import SwiftUI

struct FilmDetails: Codable {
    let Poster: String
}

struct ResultView: View {
    @State var filmIndex: Int = 0
    @State var films: [Films]
    @State private var posterString: String = ""
    var body: some View {
    
            VStack {
                AsyncImage(url: URL(string: posterString)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 400, alignment: .center)
                } placeholder: {
                    ProgressView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
            
            .navigationTitle(films[filmIndex].title)
//        List(films) { film in
//            HStack {
//                Text(film.title)
//                Spacer()
//                Text(String(film.year))
//            }
//        }
//        .task{
//            for film in films {
//                print("\(film.title), \(film.year)")
//            }
//        }
            }
            .task {
                filmIndex = returnRandomNumber(capacity: films.capacity)
                await loadFilmData()
            }
            .offset(y:-80)
    }

func returnRandomNumber(capacity: Int) -> Int {
    return Int.random(in: 1...capacity - 1)
}
 
    func loadFilmData() async {
        let urlString = "https://omdbapi.com/?t=\(prepareTitle(title: films[filmIndex].title))&apikey=220ff956"
        
        print("fuck: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            
            return
        }
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            if let decodedFilm = try? JSONDecoder().decode(FilmDetails.self, from: data) {
                posterString = decodedFilm.Poster
            }
        } catch {
            print("Invalid data")
        }
    }


    func prepareTitle(title: String) -> String{
        return title.replacingOccurrences(of: " ", with: "%20")
    }
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(films: [])
    }
  }
}
