//
//  BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/10.
//

import Foundation

struct BoxOfficeAPI: APIType {
    var endpointURL: String {
        return "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]?
    var apiKey: String? {
        return Bundle.main.kobisAPIKey
    }
    
    init(boxOfficeDate: String) {
        queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: boxOfficeDate)
        ]
    }
}
