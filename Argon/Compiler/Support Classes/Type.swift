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
        case enumeration(Enumeration)                                           // Array<SomeEnum,Element>
        case bounded(lowerBound:Argon.Integer,upperBound:Argon.Integer)         // Array<10,20,Element>
        case size(Argon.Integer)                                                // Array<20,Element>
        case unbounded                                                          // Array<Element>
        }
        
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
    case date
    case dateTime
    case dictionary(keyType:Type,valueType:Type)
    case enumeration(Enumeration)
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
    case method([Type],Type)
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

    public var typeClass:Class
        {
        switch(self)
            {
            case .boolean:
                return(Class.booleanClass)
            case .byte:
                return(Class.byteClass)
            case .character:
                return(Class.characterClass)
            case .date:
                return(Class.dateClass)
            case .time:
                return(Class.timeClass)
            case .integer:
                return(Class.integerClass)
            case .integer64:
                return(Class.integer64Class)
            case .integer32:
                return(Class.integer32Class)
            case .integer16:
                return(Class.integer16Class)
            case .integer8:
                return(Class.integer8Class)
            case .uinteger:
                return(Class.uIntegerClass)
            case .uinteger64:
                return(Class.uInteger64Class)
            case .uinteger32:
                return(Class.uInteger32Class)
            case .uinteger16:
                return(Class.uInteger16Class)
            case .uinteger8:
                return(Class.uInteger8Class)
            case .enumeration:
                return(Class.enumerationClass)
            case .dateTime:
                return(Class.dateTimeClass)
            case .constant:
                return(Class.integerClass)
            default:
                return(Class(shortName:"Class"))
            }
        }
        
        
        
    public var typeCanBeReduced:Bool
        {
        switch(self)
            {
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
        
    public func isSubtype(of type:Type) -> Bool
        {
        if self == type
            {
            return(true)
            }
        switch(type)
            {
            case .integer:
                return(self == .integer64)
            case .integer64:
                return(self == .integer)
            case .float:
                return(self == .float64)
            case .float64:
                return(self == .float)
            case .uinteger:
                return(self == .uinteger64)
            case .uinteger64:
                return(self == .uinteger)
            case .array(let index,let elementType):
                if case let Type.array(thatIndex,thatElement) = self
                    {
                    return(thatIndex == index && thatElement.isSubtype(of:elementType))
                    }
                return(false)
            case .list(let element):
                if case let Type.list(thatElement) = self
                    {
                    return(element == thatElement)
                    }
                return(false)
            case .set(let element):
                if case let Type.set(thatElement) = self
                    {
                    return(element == thatElement)
                    }
                return(false)
            case .dictionary(let keyElement,let valueElement):
                if case let Type.dictionary(key,value) = self
                    {
                    return(keyElement.isSubtype(of:key) && valueElement.isSubtype(of:value))
                    }
                return(false)
            case .class(let aClass):
                if case let Type.class(thisClass) = self
                    {
                    return(aClass.isSubclass(of:thisClass))
                    }
                return(false)
            case .metaclass(let aClass):
                if case let Type.metaclass(thisClass) = self
                    {
                    return(aClass.isSubclass(of:thisClass))
                    }
                return(false)
            case .all:
                return(true)
            case .closure(let closure):
                if case let Type.closure(thatClosure) = self
                    {
                    return(closure.typeClass == thatClosure.typeClass)
                    }
                return(false)
            case .pointer(let aClass):
                if case let Type.pointer(thisClass) = self
                    {
                    return(aClass.isSubtype(of:thisClass))
                    }
                return(false)
            case .tuple(let types):
                if case let Type.tuple(theseTypes) = self
                    {
                    if types.count != theseTypes.count
                        {
                        return(false)
                        }
                    for index in 0...types.count
                        {
                        let type1 = types[index]
                        let type2 = theseTypes[index]
                        if !type1.isSubtype(of:type2)
                            {
                            return(false)
                            }
                        }
                    return(true)
                    }
                return(false)
            default:
                return(false)
            }
        }
    }

typealias Types = Array<Type>

public class IndexType:Class
    {
    init(_ type:Type.ArrayIndexType)
        {
        super.init(shortName:"")
        self.indexType = type
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
