//
//  TokenEnrichment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/11.
//

import Foundation

public enum TokenEnrichment
    {
    case none
    case `class`(Int)
    case variable(Int)
    case enumeration(Int)
    case value(Int)
    case alias(Int)
    }
