//
//  NetworkManager.swift
//  BoxOffice
//
//  Created by EtialMoon, Minsup on 2023/07/25.
//

import Foundation

enum NetworkManager {
    static func fetchData<T: APIType>(api: T) async throws -> Data {
        let request = try createRequest(api: api)
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.requestFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    static private func createRequest<T: APIType>(api: T) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: api.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = api.queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        api.headers?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
