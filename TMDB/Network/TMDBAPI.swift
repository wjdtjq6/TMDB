//
//  TMDBAPI.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/26/24.
//
import UIKit
import Alamofire

struct TrendingMovie: Decodable {
    let results: [TrendingMovieResults]
}
struct TrendingMovieResults: Decodable {
    let overview: String
    let poster_path: String
    let backdrop_path: String
    let title: String
    let release_date: String
    let vote_average: Double
    let genre_ids: [Int]
    let id: Int
}
struct Genre: Decodable {
    let genres: [GenreName]
}
struct GenreName: Decodable {
    let id: Int
    let name: String
}

struct MovieCredit: Decodable {
    let cast: [Cast]
}
struct Cast: Decodable {
    let name: String
    let original_name: String
    let profile_path: String?
    let character: String
}

struct Search: Decodable {
    let page: Int
    var results: [Result]
    let total_pages: Int
    let total_results: Int
}
struct Result: Decodable {
    let poster_path: String?
    let id: Int
    let original_title: String
}
struct SimilarOrRecommend:Decodable {
    let page: Int
    let results: [SimilarOrRecommendResult]
}
struct SimilarOrRecommendResult:Decodable {
    let poster_path: String
}


class TMDBAPI {
    static let shared = TMDBAPI()
    private init() {}
    
    //var trendingMovieList = [TrendingMovieResults]()
    //var genreList = [GenreName]()
    //var movieCreditList = [Cast]()
    //var searchList = Search.init(page: 1, results: [], total_pages: 0, total_results: 0)
    //var searchResultList = [Result]()
    var similarOrrecommendList = [SimilarOrRecommendResult]()
    
    //typealias CompletionHandler = ([SimilarResult]?, String?) -> Void
    func request<T: Decodable>(api: TMDBRequest, model: T.Type, completionHandler: @escaping (T) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                print("성공")
                completionHandler(value)
                print("값 전달도 성공")
            case .failure(let error):
                print(error)
            }
        }
    }
}
