//
//  SearchRepositoriesResponse.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation

struct SearchRepositoriesResponse: Decodable {
    let items: [Repository]
}

