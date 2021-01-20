//
//  GetRepositoryRequest.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/20.
//

import Foundation
import APIKit


struct GetRepositoyRequest: GitHubRequestable {
    typealias Response = Repository
    
    let owner: String
    let repositry: String
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/repos/\(owner)/\(repositry)"
    }
    
    var decoder: JSONDecoder {
        return GitHubDecoder()
    }
    
    var params: [String: Any]? {
        return nil
    }
}

