//
//  TMDBAPI.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/26/24.
//
struct Similar:Decodable {
    let page: Int
    let results: [SimilarResult]
}
struct SimilarResult:Decodable {
    let poster_path: String
}

import UIKit
import Alamofire

class TMDBAPI {
    static let shared = TMDBAPI()
    private init() {}
    static var id = 0
    typealias CompletionHandler = ([SimilarResult]?, String?) -> Void
    func callRequest(parameter: String, completion: @escaping CompletionHandler) {
        let url = "https://api.themoviedb.org/3/movie/\(TMDBAPI.id)"
        let headers: HTTPHeaders = [
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NjI1ZGY1ZmMwZjBkMTAxZjI1Y2MzY2NkNjUzMWQ5NSIsIm5iZiI6MTcxOTIyMDg3Ni45NjUwMTksInN1YiI6IjY2NjA2ODFiYzdjMTZiNjhhZjU3NTNiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CE3TpPMcseKddPWbAAiWRv7s_rlWOZDTxsClf-UWOUc",
            "accept":"application/json"
        ]
        //언어왜 안바뀌지
        AF.request(url+parameter+"?language=ko-KR",headers: headers).responseDecodable(of: Similar.self) { response in
            print("status: \(response.response?.statusCode ?? 0)")
            switch response.result {
                
            case .success(let value):
                print(value)
                completion(value.results, "잠시 후 다시 시도해주세요")
            case .failure(let error):
                print(error)
                completion([], "실패")
            }
        }
    }
}
