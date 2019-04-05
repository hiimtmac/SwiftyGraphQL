//
//  Encodable+Extensions.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-05.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
