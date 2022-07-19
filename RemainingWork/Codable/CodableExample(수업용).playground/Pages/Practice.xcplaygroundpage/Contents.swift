//: [Previous](@previous)
import Foundation

let decoder = JSONDecoder()

/*
 1번 문제
 - 다음 JSON 내용을 Fruit 타입으로 변환
 */
print("\n---------- [ 1번 문제 (Fruits) ] ----------\n")
let jsonFruits = """
[
{
  "name": "Orange",
  "cost": 100,
  "description": "A juicy orange"
},
{
  "name": "Apple",
  "cost": 200
},
{
  "name": "Watermelon",
  "cost": 300
},
]
""".data(using: .utf8)!


struct Fruit: Decodable {
    let name: String
    let cost: Int
    let description: String?
}

if let fruits = try? decoder.decode([Fruit].self, from: jsonFruits) {
    fruits.forEach({
        print("---------------------------------------")
        print("name:", $0.name)
        print("cost:", $0.cost)
        print("description:", $0.description ?? "nil")
    })
}



/*
 2번 문제
 - 다음 JSON 내용을 Report 타입으로 변환
 */
print("\n---------- [ 2번 문제 (Report) ] ----------\n")
let jsonReport = """
{
  "name": "Final Results for iOS",
  "report_id": "905",
  "read_count": "10",
  "report_date": "2019-02-14",
}
""".data(using: .utf8)!

struct Report: Decodable {
    
    let name: String
    let report: String
    let readCount: String
    let reportDate: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case report = "report_id"
        case readCount = "read_count"
        case reportDate = "report_date"
    }
    
}

do {
    let report = try decoder.decode(Report.self, from: jsonReport)
    print(report)
}catch {
    print(error.localizedDescription)
}
 

/*
 3번 문제
 - Nested Codable 내용을 참고하여 다음 JSON 내용을 파싱
 */

print("\n---------- [ 3번 문제 (Movie) ] ----------\n")
let jsonMovie = """
[
  {
    "name": "Edward",
    "favorite_movies": [
      { "title": "Gran Torino", "release_year": 2008 },
      { "title": "3 Idiots", "release_year": 2009 },
      { "title": "Big Fish", "release_year": 2003 },
    ]
  }
]
""".data(using: .utf8)!

struct Person: Decodable {
    
    struct Movie: Decodable {
    let title: String
    let releaseYear: Int
        
        private enum CodingKeys: String, CodingKey {
            case title
            case releaseYear = "release_year"
        }
        
  }
    
    let name: String
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case movies = "favorite_movies"
    }
    
}

if let persons = try? decoder.decode([Person].self, from: jsonMovie) {
    persons.forEach({
        print("name:", $0.name)
        $0.movies.forEach({ print("title", $0.title, "| releseYear:", $0.releaseYear)})
    })
}



/*
 4번 문제
 - 다음 URL의 Repository 정보 중에서 다음 속성만을 골라서 데이터 모델로 만들고 출력
 - https://api.github.com/search/repositories?q=user:giftbott
 - 위 URL의 user 부분을 자신의 아이디로 변경
 */

/*
 let fullName: String
 let description: String?
 let starCount: Int
 let forkCount: Int
 let url: String
 full_name, description, stargazers_count, forks_count, html_url
 */

struct Repositories: Decodable {
  
    let items: [Repositorie]
    
}

struct Repositorie: Decodable {
    
    let fullName: String
    let description: String?
    let starCount: Int
    let forkCount: Int
    let url: String
    let ownerUrl: String
    
    
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description = "description"
        case starCount = "stargazers_count"
        case forkCount = "forks_count"
        case url = "html_url"
        case additionalInfo = "owner"
        
    }
    
    private enum AdditionalInfoKey: String, CodingKey {
        case url = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try values.decode(String.self, forKey: .fullName)
        description = try values.decode(String?.self, forKey: .description)
        starCount = try values.decode(Int.self, forKey: .starCount)
        forkCount = try values.decode(Int.self, forKey: .forkCount)
        url = try values.decode(String.self, forKey: .url)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKey.self, forKey: .additionalInfo)
        ownerUrl = try additionalInfo.decode(String.self, forKey: .url)
    
    }
}


func fetchGitHubRepositories() {
  let urlString = "https://api.github.com/search/repositories?q=user:JoongChangYang"
  let url = URL(string: urlString)!

    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        if let error = error {
            print(error)
        }else {
            guard let data = data else { return print("No Data") }
            do {
                let repositories = try decoder.decode(Repositories.self, from: data)
                repositories.items.forEach({
                    print("--------------------------\($0.fullName)---------------------------------")
                    print("description:", $0.description ?? "nil")
                    print("fullName:", $0.starCount)
                    print("forkCount:", $0.forkCount)
                    print("url:", $0.url)
                    print("ownerUrl:", $0.ownerUrl)
                })
            }catch { print(error.localizedDescription) }
            
        }
    }
    task.resume()
}
print("\n---------- [ 4번 문제 (GitHub) ] ----------\n")
fetchGitHubRepositories()



//: [Table of Contents](Contents) | [Previous](@previous) | [Next](@next)
