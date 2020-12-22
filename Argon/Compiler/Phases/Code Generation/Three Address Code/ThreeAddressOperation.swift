//
//  ThreeAddressOperation.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public enum ThreeAddressOperation
    {
    case operation(Token.Symbol)
    case paramater
    case invoke
    case call
    case `return`
    case index
    case copyIndex
    case address
    case pointer
    }
