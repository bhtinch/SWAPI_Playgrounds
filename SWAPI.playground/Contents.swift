import Foundation

struct Person: Codable {
    let name: String
    let films: [URL]
}

struct Film: Codable {
    let title, release_date, opening_crawl: String
    let episode_id: Int
}

class SwapiService {
    
    static let baseURL = URL(string: "https://swapi.dev/api")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
        }.resume()
    }
    
}   //  End of Class

func fetchFilm(urls: [URL]) {
    for url in urls {
        SwapiService.fetchFilm(url: url) { (film) in
            if let film = film {
                print(film.title)
                print("Episode: \(film.episode_id)")
                print(film.release_date)
                print("----------------")
            }
        }
    }
}

func fetchSwapiPerson(id: Int) {
    
    SwapiService.fetchPerson(id: id) { (person) in
        if let person = person {
            print(person.name)
            print("====================")
            fetchFilm(urls: person.films)
        }
    }
}

fetchSwapiPerson(id: 1)
