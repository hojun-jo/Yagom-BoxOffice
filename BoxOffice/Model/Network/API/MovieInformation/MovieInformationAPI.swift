//
//  MovieInformationAPI.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/10.
//

import Foundation

struct MovieInformationAPI: APIType {
    var baseURL: String {
        return "http://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
    }
    var headers: [String : String]? {
        return nil
    }
    var queryItems: [URLQueryItem]?
    var apiKey: String? {
        return Bundle.main.kobisAPIKey
    }
    
    init(movieCode: String) {
        queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "movieCd", value: movieCode)
        ]
    }
}
