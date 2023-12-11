//
//  DaumImageAPI.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/10.
//

import Foundation

struct DaumImageAPI: APIType {
    var baseURL: String {
        return "https://dapi.kakao.com/v2/search/image"
    }
    
    var headers: [String : String]?
    var queryItems: [URLQueryItem]?
    var apiKey: String? {
        return Bundle.main.kakaoAPIKey
    }
    
    init?(movieName: String) {
        guard let apiKey else { return nil }
        
        queryItems = [
            URLQueryItem(name: "query", value: "\(movieName)+영화+포스터")
        ]
        headers = [
            "Authorization" : apiKey
        ]
    }
}
