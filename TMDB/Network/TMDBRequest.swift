//
//  TMDBRequest.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/29/24.
//

import Foundation
import Alamofire

enum TMDBRequest {
    case trendingMovie
    case trendingMovieGenre
    case trendigCredit(id: Int)
    case search(query: String, page: Int, size: Int)
    case detail(id: Int)
    var BaseUrl: String {
        return "https://api.themoviedb.org/3/"
    }
    var endPoint: String {
        switch self {
        case .trendingMovie:
            return BaseUrl + "/trending/movie/day"
        case .trendingMovieGenre:
            return BaseUrl + "genre/movie/list"
        case .trendigCredit(let id):
            return BaseUrl + "/movie/\(id)/credits"
        case .search:
            return BaseUrl + "/search/movie"
        case .detail(let id):
            return BaseUrl + "movie/\(id)/recommendations"
        }
    }
    var header: HTTPHeaders {
        return [
            "Authorization" : "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NjI1ZGY1ZmMwZjBkMTAxZjI1Y2MzY2NkNjUzMWQ5NSIsInN1YiI6IjY2NjA2ODFiYzdjMTZiNjhhZjU3NTNiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Heb6kxmB0LJQlXNCCMLH-fBnWnjDM-UPHxwFm2YsE7k"
        ]
    }
    var method: HTTPMethod {
        return .get
    }
    var parameter: Parameters {
        switch self {
        case .trendingMovie, .trendingMovieGenre, .trendigCredit, .detail:
            return ["language": "ko-KR"]
        case .search(let query, let page, let size):
            return [
                "query": query,
                "page": page,
                "size": size
            ]
        }
    }
}
