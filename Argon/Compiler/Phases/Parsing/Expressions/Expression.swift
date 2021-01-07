//
//  Expression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/10/24.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Expression:Equatable
    {
    public var typeClass:Class
        {
        return(Class.voidClass)
        }
        
    public static func ==(lhs:Expression,rhs:Expression) -> Bool
        {
        return(false)
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        fatalError("Not Implemnted")
        }
    }
    
public class VoidExpression:Expression
    {
    }
    
public class NullExpression:Expression
    {
    }
    
public class BinaryExpression:Expression
    {
    public static func ==(lhs:BinaryExpression,rhs:BinaryExpression) -> Bool
        {
        return(lhs.lhs == rhs.lhs && lhs.operation == rhs.operation && lhs.rhs == rhs.rhs)
        }
        
    public override var typeClass:Class
        {
        return(CrossProduct(shortName:"\(self.operation)",operation:operation,operands:[lhs.typeClass,rhs.typeClass]))
        }
        
    let lhs:Expression
    let rhs:Expression
    let operation:Token.Symbol
    
    init(lhs:Expression,operation:Token.Symbol,rhs:Expression)
        {
        self.lhs = lhs
        self.operation = operation
        self.rhs = rhs
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        try self.lhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let lhsResult = buffer.lastResult
        try self.rhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let rhsResult = buffer.lastResult
        let temp = ThreeAddressTemporary.newTemporary()
        var code:ThreeAddressInstruction.InstructionCode
        switch(self.operation)
            {
            case .add:
                code = .add
            case .mul:
                code = .mul
            case .div:
                code = .div
            case .modulus:
                code = .mod
            case .sub:
                code = .sub
            case .not:
                code = .not
            case .and:
                code = .and
            case .or:
                code = .or
            case .pow:
                code = .pow
            case .bitNot:
                code = .bitNot
            case .bitAnd:
                code = .bitAnd
            case .bitOr:
                code = .bitOr
            case .bitXor:
                code = .bitXor
            case .bitShiftRight:
                code = .bitShiftRight
            case .bitShiftLeft:
                code = .bitShiftLeft
            case .mulEquals:
                code = .mulEquals
            case .divEquals:
                code = .divEquals
            case .addEquals:
                code = .addEquals
            case .subEquals:
                code = .subEquals
            case .bitAndEquals:
                code = .bitAndEquals
            case .bitOrEquals:
                code = .bitOrEquals
            case .bitNotEquals:
                code = .bitNotEquals
            case .bitXorEquals:
                code = .bitXorEquals
            case .shiftLeftEquals:
                code = .shiftLeftEquals
            case .shiftRightEquals:
                code = .shiftRightEquals
            case .equals:
                code = .equals
            case .notEquals:
                code = .notEquals
            default:
                code = .not
            }
        buffer.emitInstruction(ThreeAddressInstruction(result: temp, left: lhsResult, opcode: code, right: rhsResult))
        }
    }
    
public class UnaryExpression:Expression
    {
    let lhs:Expression
    let operation:Token.Symbol
    
    init(lhs:Expression,operation:Token.Symbol)
        {
        self.lhs = lhs
        self.operation = operation
        super.init()
        }
    }

public class CastExpression:Expression
    {
    let rhs:Expression
    let lhs:Expression
    
    init(lhs:Expression,rhs:Expression)
        {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
        }
    }
    
public class AdditionExpression:BinaryExpression
    {
    public override var typeClass:Class
        {
        return(Class.voidClass)
        }
    }

public class PowerExpression:BinaryExpression
    {
    }
    
public class MultiplicationExpression:BinaryExpression
    {
    }

public class BooleanExpression:BinaryExpression
    {
    }
    
public class LogicalExpression:BinaryExpression
    {
    }
    
public class RelationalExpression:BinaryExpression
    {
    }
    
public class ShiftExpression:BinaryExpression
    {
    }
    
public class BitExpression:BinaryExpression
    {
    }

public class ScalarExpression:Expression
    {
    }

public class EnumerationExpression:ScalarExpression
    {
    public override var typeClass:Class
        {
        return(EnumerationClass(shortName: self.name, baseClass: baseClass))
        }
        
    let name:String
    let baseClass:Class
    
    init(enumeration:Enumeration)
        {
        self.name = enumeration.shortName
        self.baseClass = enumeration.baseClass
        super.init()
        }
    }
    
public class EnumerationCaseExpression:ScalarExpression
    {
    public override var typeClass:Class
        {
        return(EnumerationCaseClass(shortName: self.name,enumeration: enumeration.typeClass as! EnumerationClass))
        }
        
    let name:String
    let enumerationCase:EnumerationCase
    let enumeration:Enumeration
    
    init(name:String,enumeration:Enumeration,case:EnumerationCase)
        {
        self.name = name
        self.enumerationCase = `case`
        self.enumeration = enumeration
        super.init()
        }
    }
    
public class PsuedoVariableExpression:ScalarExpression
    {
    public var displayString:String
        {
        return("")
        }
    }
    
public class ThisExpression:PsuedoVariableExpression,ThreeAddress
    {
    public override var displayString:String
        {
        return("this")
        }
    }
    
public class THISExpression:PsuedoVariableExpression,ThreeAddress
    {
    public override var displayString:String
        {
        return("This")
        }
    }
    
public class SuperExpression:PsuedoVariableExpression,ThreeAddress
    {
    public override var displayString:String
        {
        return("super")
        }
    }
    
public class LiteralExpression:Expression
    {
    }
    
public class UndefinedExpression:Expression
    {
    }
    
public class LiteralClassExpression:Expression
    {
    let _class:Class
    
    init(class:Class)
        {
        self._class = `class`
        super.init()
        }
    }
    
public class LiteralByteExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.byteClass)
        }
        
    let byte:UInt8
    
    init(byte:UInt8)
        {
        self.byte = byte
        super.init()
        }
    }
    
public class LiteralBooleanExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.booleanClass)
        }
        
    let boolean:Bool
    
    init(boolean:Bool)
        {
        self.boolean = boolean
        super.init()
        }
    }
    
public class LiteralStringExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.stringClass)
        }
        
    let string:String
    
    init(string:String)
        {
        self.string = string
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:self.string,opcode:.copy)
        }
    }
    
public class LiteralSymbolExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.symbolClass)
        }
        
    let symbol:Argon.Symbol
    
    init(symbol:Argon.Symbol)
        {
        self.symbol = symbol
        super.init()
        }
    }
    
public class LiteralIntegerExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.integerClass)
        }
        
    let integer:Argon.Integer
    
    init(integer:Argon.Integer)
        {
        self.integer = integer
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:self.integer,opcode:.copy)
        }
    }
    
public class LiteralCharacterExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.characterClass)
        }
        
    let character:Argon.Character
    
    init(character:Argon.Character)
        {
        self.character = character
        super.init()
        }
    }
    
public class LiteralFloatExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.floatClass)
        }
        
    let float:Argon.Float
    
    init(float:Argon.Float)
        {
        self.float = float
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:self.float,opcode:.copy)
        }
    }
    
public class LiteralArrayExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.arrayClass)
        }
        
    let array:[Expression]
    
    init(array:[Expression])
        {
        self.array = array
        super.init()
        }
    }
    
public class FunctionExpression:ScalarExpression
    {
    public override var typeClass:Class
        {
        return(Class.functionClass)
        }
        
    let name:String
    let function:Function?
    
    init(name:String,function:Function?)
        {
        self.name = name
        self.function = function
        super.init()
        }
    }
    
public class AccessExpression:Expression
    {
    }
    
public class IdentifierExpression:Expression
    {
    let identifier:String
    
    init(identifier:String)
        {
        self.identifier = identifier
        super.init()
        }
    }
    
public class InvocationExpression:Expression
    {
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        fatalError("Not implemeneted")
        }
    }
    
public class MethodInvocationExpression:InvocationExpression
    {
    let method:Method?
    let methodName:String
    
    init(methodName:String,method:Method?)
        {
        self.methodName = methodName
        self.method = method
        super.init()
        }
    }
    
public class FunctionInvocationExpression:InvocationExpression
    {
    let function:Function
    let arguments:Arguments
    
    init(function:Function,arguments:Arguments)
        {
        self.function = function
        self.arguments = arguments
        super.init()
        }
    }
    
public class ClosureInvocationExpression:InvocationExpression
    {
    let closure:Expression
    let arguments:Arguments
    
    init(closure:Expression,arguments:Arguments)
        {
        self.closure = closure
        self.arguments = arguments
        super.init()
        }
    }
    
public class ClassMakerInvocationExpression:InvocationExpression
    {
    let theClass:Class
    let arguments:Arguments
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        for argument in self.arguments
            {
            try argument.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
            let result = buffer.lastResult
            buffer.emitInstruction(left:result,opcode:.parameter)
            }
        let name = theClass.shortName
        buffer.emitInstruction(left:name,opcode:.parameter)
        let result = ThreeAddressTemporary.newTemporary()
        buffer.emitInstruction(result:result,left:"class_maker",opcode: .call)
        }
    }
    
public class TypeMakerInvocationExpression:InvocationExpression
    {
    let theClass:Class
    let arguments:Arguments
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        for argument in self.arguments
            {
            try argument.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
            let result = buffer.lastResult
            buffer.emitInstruction(left:result,opcode:.parameter)
            }
        let name = theClass.shortName
        buffer.emitInstruction(left:name,opcode:.parameter)
        let result = ThreeAddressTemporary.newTemporary()
        buffer.emitInstruction(result:result,left:"type_maker",opcode: .call)
        }
    }
    
public class MakerInvocationExpression:InvocationExpression
    {
    let theClass:Class
    let arguments:Arguments
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
    }
    
public class MethodExpression:Expression
    {
    let method:Method
    
    init(method:Method)
        {
        self.method = method
        super.init()
        }
    }
    
public class ModuleExpression:Expression
    {
    let module:Module
    
    init(module:Module)
        {
        self.module = module
        super.init()
        }
    }
    
public class ClassExpression:Expression
    {
    let theClass:Class
    
    init(class:Class)
        {
        self.theClass = `class`
        super.init()
        }
    }
    
public class ClosureExpression:Expression
    {
    let closure:Closure
    
    init(closure:Closure)
        {
        self.closure = closure
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        try self.closure.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
        }
    }
    
public class AccessVariableExpression:AccessExpression
    {
    let variable:Variable
    
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        let temp = ThreeAddressTemporary.newTemporary()
        buffer.emitInstruction(result:temp,left:variable,opcode:.copy)
        }
    }
    
public class ForwardAccessVariableExpression:AccessExpression
    {
    let variable:Variable
    
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        let temp = ThreeAddressTemporary.newTemporary()
        buffer.emitInstruction(result:temp,left:variable,opcode:.copy)
        }
    }
    
public class AccessSlotExpression:AccessExpression
    {
    let target:Expression
    let slot:Expression
    
    init(target:Expression,slot:Expression)
        {
        self.target = target
        self.slot = slot
        super.init()
        }
    }
    
public class InferredAccessSlotExpression:AccessExpression
    {
    let slot:String
    
    init(slot:String)
        {
        self.slot = slot
        super.init()
        }
    }
    
public class AccessSubscriptExpression:AccessExpression
    {
    let target:Expression
    let `subscript`:Expression
    
    init(target:Expression,`subscript`:Expression)
        {
        self.target = target
        self.`subscript` = `subscript`
        super.init()
        }
    }
    
    
public class BooleanScalarExpression:ScalarExpression
    {
    let booleanValue:Bool
    
    init(boolean:Bool)
        {
        self.booleanValue = boolean
        super.init()
        }
    }

public class TupleExpression:ScalarExpression
    {
    let elements:[Expression]
    
    init(elements:[Expression])
        {
        self.elements = elements
        super.init()
        }
    }
    
public class DateExpression:ScalarExpression
    {
    let day:Expression
    let month:Expression
    let year:Expression
    
    init(day:Expression,month:Expression,year:Expression)
        {
        self.day = day
        self.month = month
        self.year = year
        super.init()
        }
    }

public class TimeExpression:ScalarExpression
    {
    let hour:Expression
    let minute:Expression
    let second:Expression
    let millisecond:Expression?
    
    init(hour:Expression,minute:Expression,second:Expression,millisecond:Expression? = nil)
        {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
        super.init()
        }
    }

public class DateTimeExpression:ScalarExpression
    {
    let date:Expression
    let time:Expression
    
    init(date:Expression,time:Expression)
        {
        self.date = date
        self.time = time
        super.init()
        }
    }

public class FullyQualifiedName:Class
    {
    let _name:Name
    
    init(name:Name)
        {
        self._name = name
        super.init(shortName:name.stringName)
        }
    }
