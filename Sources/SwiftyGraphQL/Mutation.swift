//
//  Mutation.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public struct GQLMutation: GQLOperation {
    public static let operationType = "mutation"
    public let operationName: String?
    public let variables: [String: GQLVariable]
    public let content: GraphQL
    
    public init(@GraphQLBuilder builder: () -> GraphQL) {
        self.operationName = nil
        self.variables = [:]
        self.content = builder()
    }
    
    public init(_ operationName: String, @GraphQLBuilder builder: () -> GraphQL) {
        self.operationName = operationName
        self.variables = [:]
        self.content = builder()
    }
    
    init(operationName: String?, variables: [String: GQLVariable], content: GraphQL) {
        self.operationName = operationName
        self.variables = variables
        self.content = content
    }
    
    public func copy(withVariables: [String: GQLVariable]) -> GQLMutation {
        return .init(operationName: operationName, variables: withVariables, content: content)
    }
}
