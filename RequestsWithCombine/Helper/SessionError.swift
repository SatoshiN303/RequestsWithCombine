//
//  SessionError.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation

public enum SessionError: Error {
    case noData(HTTPURLResponse)
    case unacceptableStatusCode(Int, Message?)
}

extension SessionError {
    public struct Message: Decodable {
        public let documentationURL: URL
        public let message: String

        private enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case message
        }
    }
}
