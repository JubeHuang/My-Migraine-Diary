//
//  Article Controller.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/5.
//

import UIKit

class ArticleController {
    static let shared = ArticleController()
    
    let baseUrl = URL(string: "https://newsapi.org/v2/everything?")
    
    func fetchArticle(language: String, completion: @escaping (Result<[Item], NetworkError>) -> Void) {
        guard let baseUrl else { return }
        var urlComponent = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = [
            URLQueryItem(name: "apiKey", value: "9f2bfbe25add44e3b4f77fd3306e8d13"),
            URLQueryItem(name: "q", value: "migraine"),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "pageSize", value: "2")
        ]
        
        if let url = urlComponent?.url {
            URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        let articleResponese = try decoder.decode(ArticleResponese.self, from: data)
                        completion(.success(articleResponese.articles))
                    }catch{
                        completion(.failure(.jsonDecodeFailed))
                    }
                } else {
                    completion(.failure(.responseFaild))
                }
            }.resume()
        } else {
            completion(.failure(.invalidUrl))
        }
    }
    
    func fetchImage(url: URL?, completion: @escaping (UIImage?) -> Void){
        if let url {

            URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                if let data, let image = UIImage(data: data) {
                    completion(image)
                }else {
                    completion(UIImage(named: "article_imageEmpty"))
                }
            }.resume()
        } else {
            print(NetworkError.invalidUrl)
        }
    }
}
