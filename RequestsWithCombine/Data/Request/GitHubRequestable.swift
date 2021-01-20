//
//  GitHubRequestable.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation
import APIKit

protocol GitHubRequestable: Request {
    var params: [String: Any]? { get }
    var decoder: JSONDecoder { get }
}

extension GitHubRequestable {
    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com") else {
            fatalError()
        }
        return url
    }
    
    var parameters: Any? {
        return params
    }
        
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        debugPrint(urlRequest.url?.absoluteString ?? "")
        return urlRequest
    }
}

extension GitHubRequestable where Response: Decodable {
    
    var dataParser: DataParser {
        return DecodableDataParser<Response>(decoder: decoder)
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let response = object as? Response else {
            throw ResponseError.unexpectedObject(object)
        }
        return response
    }
}
