//
//  ResultView.swift
//  SomethingToWatch
//
//  Created by Bartosz Klimek on 02/02/2022.
//

import SwiftUI

struct FilmDetails: Codable {
    let Poster: String
    let Title: String
    let Plot: String
    let Runtime: String
    let imdbRating: String
    let Year: String
    let Director: String
    let Actors: String
    let BoxOffice: String
}

struct ResultView: View {
    @State var initialTitle: String
    @State var filmIndex: Int = 0
    var films: [Films]
    @State private var skippedFilms: [String] = []
    @State private var film: Film = Film(title: "", poster: "", plot: "", runtime: "", rating: "0.0", year: "", director: "", actors: "", boxOffice: "")
    var body: some View {
        ZStack {
            Color(UIColor(named:"posterBackground")!)
                .ignoresSafeArea()
            VStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Spacer()
                        Poster(poster: film.poster)
                        VStack (spacing: 14) {
                            Widget(title: "PLOT", text: film.plot, width: 300, height: 101, scrollHight: 90, textWidth: 270)
                            Widget(title: "DIRECTOR", text: film.director, width: 300, height: 40, scrollHight: 32, textWidth: 270)
                            Widget(title: "ACTORS", text: film.actors, width: 300, height: 40, scrollHight: 32, textWidth: 270)
                            Widget(title: "BOX OFFICE", text: film.boxOffice, width: 300, height: 40, scrollHight: 32, textWidth: 270)
                            
                            
                            HStack(spacing: 13.0) {
                                Widget(title: "IMDB", text: film.rating, width: 90, height: 40, scrollHight: 32, textWidth: 70)
                                Widget(title: "DURATION", text: film.runtime, width: 90, height: 40, scrollHight: 32, textWidth: 70)
                                Widget(title: "YEAR", text: film.year, width: 90, height: 40, scrollHight: 32, textWidth: 70)
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                Button("Next film") {
                    Task {
                        await getFilm()
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .font(.system(size:20))
                .clipShape(Capsule())
                Spacer()
                Spacer()
            }
            .navigationTitle(film.title)
            .task {
                skippedFilms.append(initialTitle)
                await loadFilmData(title: initialTitle)
            }
        }
    }
    
    func returnRandomNumber(count: Int) -> Int {
        return Int.random(in: 0...(count - 1))
    }
    
    func loadFilmData(title: String) async {
        let urlString = "https://omdbapi.com/?t=\(title)&apikey=220ff956"
        
        print(urlString)
        if let url = URL(string: urlString) {
            do {
                let(data, _) = try await URLSession.shared.data(from: url)
                if let decodedFilm = try? JSONDecoder().decode(FilmDetails.self, from: data) {
                    film.poster = decodedFilm.Poster
                    film.title = decodedFilm.Title
                    film.plot = decodedFilm.Plot
                    film.runtime = decodedFilm.Runtime
                    film.rating = decodedFilm.imdbRating
                    film.year = decodedFilm.Year
                    film.director = decodedFilm.Director
                    film.actors = decodedFilm.Actors
                    film.boxOffice = decodedFilm.BoxOffice
                }
            } catch {
                print("Invalid data")
            }
        } else {
            print("Invalid url")
            await getFilm()
        }
    }
    
    func getFilm() async {
        filmIndex = returnRandomNumber(count: films.count)
        if(!skippedFilms.contains(films[filmIndex].title)) {
            skippedFilms.append(films[filmIndex].title)
            if(skippedFilms.count == films.count) {
                skippedFilms = []
            }
            await loadFilmData(title: films[filmIndex].title)
        } else {
            await getFilm()

        }
    }
    
    func prepareTitle(title: String) -> String{
        return title.replacingOccurrences(of: " ", with: "%20")
    }
    
    struct Widget: View {
        var title: String
        var text: String
        var width: CGFloat
        var height: CGFloat
        var scrollHight: CGFloat
        var textWidth: CGFloat
        var body: some View {
            VStack(spacing: 5.0) {
                Text(title)
                    .foregroundColor(Color.gray)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width:width, height: height)
                        .foregroundColor(Color(UIColor(named: "widgetColor")!))
                    
                    ScrollView(showsIndicators: false) {
                        Text(text)
                            .frame(width:textWidth)
//                            .offset(y:5)
                    }
                    .offset(y:5)
                    .frame(height: scrollHight)
                    
                    
                }
            }
        }
    }
    
    struct Poster: View {
        var poster: String
        var body: some View {
            AsyncImage(url: URL(string: poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 440,  alignment: .center)
            } placeholder: {
                ZStack {
                    Rectangle()
                        .frame(width:295, height:440)
                        .foregroundColor( Color(UIColor(named:"posterBackground")!))
                    ProgressView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
    
    struct ResultView_Previews: PreviewProvider {
        
        static var previews: some View {
            ResultView(initialTitle:"Up", films: [])
        }
    }
}
