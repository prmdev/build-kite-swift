//
//  GraphQL.swift
//  Shared
//
//  Created by prmdev on 5/24/20.
//  Copyright © 2020 prmdev. All rights reserved.
//

import Foundation
import Buildkite

protocol GraphQLQuery {
    associatedtype Response: Decodable
    static var query: String { get }
    static var fragments: [Fragment.Type] { get }
    var variables: [String: JSONValue] { get }
}

extension GraphQLQuery {
    static var fragments: [Fragment.Type] { [] }
}
