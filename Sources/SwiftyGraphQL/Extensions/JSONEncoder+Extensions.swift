//
//  JSONEncoder+Extensions.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-05.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

//extension JSONEncoder {
//    private struct EncodableWrapper: Encodable {
//        let wrapped: Encodable
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try self.wrapped.encode(to: &container)
//        }
//    }
//
//    func encodeDD<Key: Encodable>(_ dictionary: [Key: Encodable]) throws -> Data {
//        let wrappedDict = dictionary.mapValues(EncodableWrapper.init(wrapped:))
//        return try self.encode(wrappedDict)
//    }
//}
