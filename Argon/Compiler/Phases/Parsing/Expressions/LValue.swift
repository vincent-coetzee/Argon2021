//
//  Lvalue.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/11/22.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

//public indirect enum LValue
//    {
//    case none
//    case slot([String])
//    case `subscript`(Expression)
//    case variable(String)
//    case tuple([LValue])
//    case compound([LValue])
//    case keyword(Token.Keyword)
//    
//    public var typeClass:Class
//        {
//        switch(self)
//            {
//            case .none:
//                return(.voidClass)
//            case .slot(let names):
//                fatalError("Should not happen")
//            case .subscript(let expression):
//                return(expression.typeClass)
//            case .variable(let name):
//                fatalError("Should not happen")
//            case .tuple(let values):
//                return(TupleClass(elements: values.map{$0.typeClass}))
//            case .compound(let values):
//                fatalError("Should not happen")
//            default:
//                fatalError("Should not happen")
//            }
//        }
//    }
