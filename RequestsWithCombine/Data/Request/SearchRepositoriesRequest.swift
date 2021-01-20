//
//  SearchRepositoriesRequest.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//
//  https://docs.github.com/en/rest/reference/search

import Foundation
import APIKit

struct SearchRepositoriesRequest: GitHubRequestable {
    typealias Response = SearchRepositoriesResponse
    
    let query: String
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/search/repositories"
    }
    
    var decoder: JSONDecoder {
        return GitHubDecoder()
    }
    
    var params: [String: Any]? {
        return [
            "q": query
        ]
    }
}
