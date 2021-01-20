//
//  Repository.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
}
