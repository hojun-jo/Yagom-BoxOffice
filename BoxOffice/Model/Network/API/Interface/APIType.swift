//
//  APIType.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/10.
//

import Foundation

protocol APIType {
    var endpointURL: String { get }
    var headers: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var apiKey: String? { get }
}
