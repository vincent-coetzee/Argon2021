//
//  Expression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/10/24.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public indirect enum Expression:Equatable
    {
    case additionOperation(Expression,Token.Symbol,Expression)
    case bitOperation(Expression,Token.Symbol,Expression)
    case bitSetField(String)
    case booleanOperation(Expression,Token.Symbol,Expression)
    case boolean(Argon.Boolean)
    case byte(UInt8)
    case character(UInt16)
    case `class`(Class)
    case castOperation(Expression,Expression)
    case closure(Closure)
    case closureInvocation(Closure,Arguments)
    case date(Expression,Expression,Expression)
    case dateTime(Expression,Expression)
    case enumeration(Enumeration)
    case enumerationCase(Enumeration,EnumerationCase)
    case error(String)
    case expression(Expression)
    case float(Argon.Float)
    case functionInvocation(Function,Arguments)
    case function(Function)
    case identifier(String)
    case integer(Argon.Integer)
    case literalArray([Expression])
    case logicalOperation(Expression,Token.Symbol,Expression)
    case makerInvocation(String,Arguments)
    case methodInvocation(Method,Arguments)
    case method(Method)
    case module(Module)
    case multiplicationOperation(Expression,Token.Symbol,Expression)
    case `nil`(Symbol)
    case none
    case powerOperation(Expression,Token.Symbol,Expression)
    case relationalOperation(Expression,Token.Symbol,Expression)
    case slot(Expression,Expression)
    case readSubscript(Expression,Expression)
    case readVariable(Variable)
    case shiftOperation(Expression,Token.Symbol,Expression)
    case symbol(String)
    case string(String)
    case this
    case This
    case time(Expression,Expression,Expression)
    case tuple([Expression])
    case unaryOperation(Token.Symbol,Expression)
    case variableInvocation(Variable,Arguments)
    case undefinedValue(String)
        
    var type:Type
        {
        switch(self)
            {
            case .none:
                return(Type.void)
            case .undefinedValue:
                return(Type.void)
            case .bitSetField:
                return(Type.integer)
            case .closure(let closure):
                return(Type.closure(closure))
            case .nil:
                return(Type.void)
            case .this:
                return(Type.void)
            case .This:
                return(Type.void)
            case .boolean:
                return(Type.boolean)
            case .byte:
                return(Type.byte)
            case .date:
                return(Type.date)
            case .time:
                return(Type.time)
            case .dateTime:
                return(Type.dateTime)
            case .character:
                return(Type.character)
            case .symbol:
                return(Type.symbol)
            case .string:
                return(Type.string)
            case .identifier:
                return(Type.identifier)
            case .enumeration(let enumeration):
                return(Type.enumeration(enumeration))
            case .enumerationCase(let e,_):
                return(Type.enumeration(e))
            case .integer:
                return(Type.integer)
            case .float:
                return(Type.float)
            case .closureInvocation(let c,_):
                return(c.type)
            case .functionInvocation(let c,_):
                return(c.type)
            case .methodInvocation(let c,_):
                return(c.type)
            case .variableInvocation:
                fatalError("Need to deduce the return type of the object in the variable")
            case .readVariable(let v):
                return(v.type)
            case .readSubscript(let v,_):
                return(v.type)
            case .slot(let v,let slotName):
                var name:String = ""
                if case let Expression.identifier(aName) = slotName
                    {
                    name = aName
                    }
                return(v.type.slotType(name))
            case .class(let c):
                return(Type.class(c))
            case .literalArray(let c):
                var type:Type = .void
                if let first = c.first
                    {
                    type = first.type
                    }
                return(Type.literalArray(type))
            case .function(let f):
                return(Type.function(f))
            case .method(let m):
                return(Type.method(m))
            case .module(let m):
                return(Type.module(m))
            case .expression(let term):
                return(Type.expression(term))
            case .makerInvocation(let name,let arguments):
                return(Type.composite(baseTypes: arguments.map{$0.type}))
            case .additionOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .shiftOperation(let lhs,let o,let rhs):
                return(Type.shiftOperation(lhs.type,o,rhs.type))
            case .multiplicationOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .bitOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .booleanOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .logicalOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .relationalOperation(let lhs,let o,let rhs):
                return(Type.binaryOperation(lhs.type,o,rhs.type))
            case .unaryOperation(let o,let rhs):
                return(Type.unaryOperation(o,rhs.type))
            case .castOperation(let any,let aClass):
                return(Type.binaryOperation(any.type,Token.Symbol.cast,aClass.type))
            case .powerOperation(let lhs,_ , let rhs):
                return(Type.binaryOperation(lhs.type,Token.Symbol.pow,rhs.type))
            case .tuple(let expressions):
                return(.tuple(expressions.map{$0.type}))
            case .error:
                fatalError("An error occurred that should not have")
            }
        }
    }
