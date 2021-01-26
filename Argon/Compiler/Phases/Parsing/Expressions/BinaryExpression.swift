//
//  BinaryExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class BinaryExpression:Expression
    {
    public static func ==(lhs:BinaryExpression,rhs:BinaryExpression) -> Bool
        {
        return(lhs.lhs == rhs.lhs && lhs.operation == rhs.operation && lhs.rhs == rhs.rhs)
        }
        
//    public override var typeClass:Class
//        {
//        return(CrossProduct(shortName:"\(self.operation)",operation:operation,operands:[lhs.typeClass,rhs.typeClass]))
//        }
        
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
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.lhs.allocateAddresses(using:compiler)
        try self.rhs.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        try self.lhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let lhsResult = buffer.lastResult
        try self.rhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let rhsResult = buffer.lastResult
        let temp = A3Temporary.newTemporary()
        var code:A3Instruction.InstructionCode
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
            case .rightBrocket:
                code = .greaterthan
            case .rightBrocketEquals:
                code = .greaterthanequal
                case .leftBrocket:
                code = .lessthan
            case .leftBrocketEquals:
                code = .lessthanequal
            default:
                fatalError("This should not happen")
            }
        buffer.emitInstruction(A3Instruction(result: .temporary(temp), left: lhsResult, opcode: code, right: rhsResult))
        }
    }
