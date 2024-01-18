//
//  JustURL.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/10.
//

import Foundation

struct JustURL: APIType {
    let endpointURL: String
    var headers: [String : String]? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    var apiKey: String? { return nil }
    
    init(url: String) {
        endpointURL = url
    }
}
