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
}

struct ResultView: View {
    @State var filmIndex: Int = 0
    var films: [Films]
    @State private var posterString: String = ""
    @State private var titleString: String = ""
    var body: some View {
        ZStack {
            Color(UIColor(named:"posterBackground")!)
             .ignoresSafeArea()
            ScrollView {
                AsyncImage(url: URL(string: posterString)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 340,  alignment: .center)
                } placeholder: {
                    ZStack {
                        Color(UIColor(named:"posterBackground")!)
                        ProgressView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                Text("Tap poster to see details")
                    .font(.system(size:20))
                    .foregroundColor(Color.gray)

                
                Button("Next film") {
                    Task {
                    await getFilm()
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .foregroundColor(Color(UIColor(named:"nextButton")!))
                .font(.system(size:20))
                .clipShape(Capsule())
                Spacer()
            }
            .navigationTitle(titleString)
            .task {
                await getFilm()
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
                    posterString = decodedFilm.Poster
                    titleString = decodedFilm.Title
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
        await loadFilmData(title: films[filmIndex].title)
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
