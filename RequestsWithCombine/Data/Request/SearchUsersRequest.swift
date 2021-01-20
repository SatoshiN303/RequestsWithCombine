//
//  SearchUsersRequest.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/20.
//

import Foundation
import APIKit

struct SearchUsersRequest: GitHubRequestable {
    typealias Response = SearchUsersResponse
    
    let query: String
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/search/users"
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



