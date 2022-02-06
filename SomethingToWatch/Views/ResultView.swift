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
    let Country: String
    let BoxOffice: String
}

struct ResultView: View {
    @State var initialTitle: String
    @State var filmIndex: Int = 0
    var films: [Films]
    @State private var skippedFilms: [String] = []
    @State private var film: Film = Film(title: "", poster: "", plot: "", runtime: "", rating: "", year: "", director: "", country: "", boxOffice: "")
    var body: some View {
        ZStack {
            Color(UIColor(named:"posterBackground")!)
             .ignoresSafeArea()
            VStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Spacer()
                        AsyncImage(url: URL(string: film.poster)) { image in
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
                        VStack (spacing: 16) {
                            VStack(spacing: 5.0) {
                                Text("PLOT")
                                    .foregroundColor(Color.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:300, height: 90)
                                    .foregroundColor(Color(UIColor(named: "widgetColor")!))
                            
                                    ScrollView(showsIndicators: false) {
                                    Text(film.plot)
                                            .frame(width:270)
                                    }
                                    .frame(height: 70)
                                
                                
                            }
                        }
                            
                            
                            
                            VStack(spacing: 5.0) {
                                Text("DIRECTOR")
                                    .foregroundColor(Color.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:300, height: 40)
                                    .foregroundColor(Color(UIColor(named: "widgetColor")!))
                            
                                ScrollView(showsIndicators: false) {
                                    Text(film.director)
                                       .frame(width:270)
                                }
                                .frame(height: 30)
                                .offset(y:5)
                                
                                
                            }
                        }
                            
                            
                            VStack(spacing: 5.0) {
                                Text("COUNTRY")
                                    .foregroundColor(Color.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:300, height: 40)
                                    .foregroundColor(Color(UIColor(named: "widgetColor")!))
                            
                                ScrollView(showsIndicators: false) {
                                    Text(film.country)
                                        .frame(width:270)
                                }
                                .frame(height:30)
                                .offset(y:5)
                                
                                
                                
                            }
                        }
                            
                            
                            
                            VStack(spacing: 5.0) {
                                Text("BOX OFFICE")
                                    .foregroundColor(Color.gray)
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:300, height: 40)
                                    .foregroundColor(Color(UIColor(named: "widgetColor")!))
                            
                                  
                                    Text(film.boxOffice)
                                         
                                
                                
                                
                            }
                        }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            HStack(spacing: 13.0) {
                                
                                VStack(spacing: 5.0) {
                                    Text("IMDB")
                                        .foregroundColor(Color.gray)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width:90, height: 40)
                                        .foregroundColor(Color(UIColor(named: "widgetColor")!))
                                
                                       
                                        Text(film.rating)
                                    
                                   
                                    
                                    
                                }
                            }
                                
                               
                                VStack(spacing: 5.0) {
                                    Text("DURATION")
                                        .foregroundColor(Color.gray)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width:90, height: 40)
                                        .foregroundColor(Color(UIColor(named: "widgetColor")!))
                                
                                       
                                        Text(film.runtime)
                                                
                                        
                                     
                                    
                                    
                                }
                            }
                                
                                
                                
                                
                                
                                VStack(spacing: 5.0) {
                                    Text("YEAR")
                                        .foregroundColor(Color.gray)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width:90, height: 40)
                                        .foregroundColor(Color(UIColor(named: "widgetColor")!))
                                
                                    Text(film.year)
                                            
                                     
                                    
                                    
                                }
                            }
                                
                                
                                
                            }
                            
                            
                          
                            
                            
                            
                            
                    
                            
                            
                            }
                        .padding()
                       
                    }
//                    .offset(x: 20)
                   
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
                    film.country = decodedFilm.Country
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
    
struct ResultView_Previews: PreviewProvider {
  
    static var previews: some View {
        ResultView(initialTitle:"Up", films: [])
    }
  }
}
