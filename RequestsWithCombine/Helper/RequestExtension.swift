//
//  RequestExtension.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation
import APIKit

extension APIKit.Request where Self.Response: Decodable {
    
    var publisher: APIPublisher<Self> {
        return APIPublisher(request: self)
    }
    
}
