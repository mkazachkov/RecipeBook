//
//  SpoonacularClient.swift
//  RecipeBook
//
//  Created by Mikhail on 11/28/20.
//

import Foundation

class SpoonacularClient {
    static let apiKey = "141967da120e4ddb96023b13986ecc5d"
    
    enum Endpoints {
        static let baseUrl = "https://api.spoonacular.com/recipes"
        
        case complexSearch(String)
        
        var urlString: String {
            switch self {
            case .complexSearch(let query):
                return Endpoints.baseUrl + "/complexSearch?apiKey=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&instructionsRequired=true&addRecipeInformation=true&number=100"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(String(data: data, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getImage(url: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    class func complexSearch(query: String, completion: @escaping ([Recipe], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.complexSearch(query).url, responseType: RecipeResults.self) { (resipeResults, error) in
            guard let resipeResults = resipeResults else {
                completion([], error)
                return
            }
            completion(resipeResults.results, nil)
        }
    }
}
