//
//  DecodableDataParser.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation
import APIKit

struct DecodableDataParser<T: Decodable>: APIKit.DataParser {
    
    let decoder: JSONDecoder
    
    var contentType: String? {
        return "application/json"
    }
    
    func parse(data: Data) throws -> Any {
        return try decoder.decode(T.self, from: data)
    }
    
    
}
