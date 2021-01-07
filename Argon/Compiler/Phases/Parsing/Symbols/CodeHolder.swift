//
//  CodeHolder.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/07.
//

import Foundation

public enum CodeHolder
    {
    case none
    case block(Block)
    case closure(Closure)
    case methodInstance(MethodInstance)
    }
