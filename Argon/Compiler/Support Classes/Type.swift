//
//  ArgonType.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public indirect enum Type:Equatable
    {
    public enum ArrayIndexType:Equatable
        {
        case enumeration(Enumeration)
        case bounded(lowerBound:Argon.Integer,upperBound:Argon.Integer)
        case upperBounded(Argon.Integer)
        case unbounded
        case none
        }
        
    case type(baseType:Type,name:String)
    case all
    case array(indexType:ArrayIndexType,elementType:Type)
    case binaryOperation(Type,Token.Symbol,Type)
    case bitset(keyType:Type,valueType:Type)
    case boolean
    case byte
    case character
    case `class`(Class)
    case constant(Type)
    case closure(Closure)
    case composite(baseTypes:[Type])
    case date
    case dateTime
    case dictionary(keyType:Type,valueType:Type)
    case enumeration(Enumeration)
    case expression(Expression)
    case float
    case float64
    case float32
    case float16
    case fullyQualifiedName(Name)
    case function(Function)
    case identifier
    case integer
    case integer64
    case integer32
    case integer16
    case integer8
    case list(elementType:Type)
    case literalArray(Type)
    case metaclass(Class)
    case method(Method)
    case methodInvocation(String,[Type],Type)
    case module(Module)
    case pointer(elementType:Type)
    case product([Type])
    case shiftOperation(Type,Token.Symbol,Type)
    case set(elementType:Type)
    case slot(Slot)
    case string
    case subRange(Type,Token.Symbol,Argon.Integer,Argon.Integer)
    case symbol
    case time
    case tree(keyType:Type,valueType:Type)
    case typeClass
    case typeParameter(constraintTypes:[Type],name:String)
    case tuple([Type])
    case uinteger
    case uinteger64
    case uinteger32
    case uinteger16
    case uinteger8
    case unaryOperation(Token.Symbol,Type)
    case undefined
    case void

    public var typeCanBeReduced:Bool
        {
        switch(self)
            {
            case .type(let base,_):
                return(base.typeCanBeReduced)
            case .boolean:
                return(true)
            case .byte:
                return(true)
            case .character:
                return(true)
            case .date:
                return(true)
            case .time:
                return(true)
            case .integer:
                return(true)
            case .integer64:
                return(true)
            case .integer32:
                return(true)
            case .integer16:
                return(true)
            case .integer8:
                return(true)
            case .uinteger:
                return(true)
            case .uinteger64:
                return(true)
            case .uinteger32:
                return(true)
            case .uinteger16:
                return(true)
            case .uinteger8:
                return(true)
            case .enumeration:
                return(true)
            case .dateTime:
                return(true)
            case .constant(let value):
                return(value.typeCanBeReduced)
            default:
                return(false)
            }
        }
        
    internal func slotType(_ slotNames:[String]) -> Type
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.slotType(slotNames))
            default:
                fatalError("Attempt to find slotTypes of type that is not a class but is \(self)")
            }
        }
        
    internal func slotType(_ slotName:String) -> Type
        {
        switch(self)
            {
            case .class(let aClass):
                return(aClass.slotType(slotName))
            default:
                fatalError("Attempt to find slotTypes of type that is not a class but is \(self)")
            }
        }
        
    internal var isArrayType:Bool
        {
        switch(self)
            {
            case .array:
                return(true)
            default:
                return(false)
            }
        }
    }

typealias Types = Array<Type>
