//
//  SearchUsersResponse.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/20.
//

import Foundation

struct SearchUsersResponse: Decodable {
    let items: [User]
}
