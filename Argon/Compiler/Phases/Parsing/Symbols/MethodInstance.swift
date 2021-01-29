//
//  Method.swift
//  spark
//
//  Created by Vincent Coetzee on 28/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class MethodInstance:Symbol
    {
    public override var sizeInBytes:Int
        {
        return(self.codeBuffer.sizeInBytes)
        }
        
    public var parameters:Parameters
        {
        get
            {
            return(_parameters)
            }
        set
            {
            self._parameters = newValue
            for parameter in newValue
                {
                self.block.addSymbol(parameter)
                }
            }
        }
        
    internal var owner:Symbol?
    internal var ownerId:UUID?
    internal var functionName:String?
    internal var returnTypeClass:Class
    internal var _parameters = Parameters()
    internal var block = Block()
    internal var codeBuffer = A3CodeBuffer()
    internal var localVariables:[LocalVariable] = []
    internal var stackLocalStorageSizeInBytes = 0
    
    enum CodingKeys:String,CodingKey
        {
        case ownerId
        case functionName
        case returnClass
        case parameters
        case codeBuffer
        case localVariables
        case stackLocalStorageSizeInBytes
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ownerId = try values.decode(UUID?.self,forKey:.ownerId)
        self.functionName = try values.decode(String?.self,forKey:.functionName)
        self.returnTypeClass = try values.decode(Class.self,forKey:.returnClass)
        self._parameters = try values.decode(Array<Parameter>.self,forKey:.parameters)
        self.codeBuffer = try values.decode(A3CodeBuffer.self,forKey:.codeBuffer)
        self.localVariables = try values.decode(Array<LocalVariable>.self,forKey:.localVariables)
        self.stackLocalStorageSizeInBytes = try values.decode(Int.self,forKey:.stackLocalStorageSizeInBytes)
        try super.init(from: values.superDecoder())
        self.memoryAddress = Compiler.shared.codeSegment.zero
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.ownerId,forKey:.ownerId)
        try container.encode(self.functionName,forKey:.functionName)
        try container.encode(self.returnTypeClass,forKey:.returnClass)
        try container.encode(self._parameters,forKey:.parameters)
        try container.encode(self.codeBuffer,forKey:.codeBuffer)
        try container.encode(self.localVariables,forKey:.localVariables)
        try container.encode(self.stackLocalStorageSizeInBytes,forKey:.stackLocalStorageSizeInBytes)
        try super.encode(to: container.superEncoder())
        }
        
    internal override func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        super.relinkSymbolsUsingIds(symbols:symbols)
        if let anId = self.ownerId, let symbol = symbols[anId]
            {
            self.owner = symbol
            }
        }
        
    internal override var typeClass:Class
        {
        return(MethodInstanceClass(shortName:self.shortName,argumentClasses:self._parameters.map{$0.typeClass},returnTypeClass: self.returnTypeClass))
        }
        
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
    
    public override func symbolAdded(to node:ParseNode)
        {
        self.block.parentScope = node as Scope
        }
        
    internal override func addSymbol(_ symbol: Symbol)
        {
        self.block.addSymbol(symbol)
        }

    internal override func addStatement(_ statement: Statement)
        {
        self.block.addStatement(statement)
        }
    
    internal init(shortName:String,owner:Symbol? = nil)
        {
        self.owner = owner
        self.returnTypeClass = .voidClass
        self.ownerId = owner?.id
        super.init(shortName: shortName)
        self.memoryAddress = Compiler.shared.codeSegment.zero
        }
        
    internal required init()
        {
        self.owner = nil
        self.ownerId = nil
        self.returnTypeClass = .voidClass
        super.init()
        self.memoryAddress = Compiler.shared.codeSegment.zero
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }
        
    internal override func typeCheck() throws
        {
        try self.block.typeCheck()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        compiler.codeSegment.updateAddress(self)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using compiler:Compiler) throws
        {
        self.localVariables = self.block.blockLocalVariables
        var localOffset = -Argon.kWordSizeInBytes
        for local in self.localVariables
            {
            local.stackOffsetFromBasePointer = localOffset
            localOffset -= Argon.kWordSizeInBytes
            }
        self.stackLocalStorageSizeInBytes = self.localVariables.count * Argon.kWordSizeInBytes
        codeBuffer.emitInstruction(opcode:.comment,right:.string("METHOD \(self.shortName)"))
        var parameterOffset = Argon.kWordSizeInBytes
        for parameter in self.parameters
            {
            parameter.stackOffsetFromBasePointer = parameterOffset
            parameterOffset += Argon.kWordSizeInBytes
            }
        self.codeBuffer.emitInstruction(opcode:.enter,right:.integer(Argon.Integer(self.stackLocalStorageSizeInBytes)),comment:"ENTER METHOD, SET UP FRAME")
        for statement in self.block.statements
            {
            try statement.generateIntermediateCode(in:module,codeHolder:.methodInstance(self),into:self.codeBuffer,using:compiler)
            }
        self.codeBuffer.emitInstruction(opcode:.leave,right:.integer(Argon.Integer(self.stackLocalStorageSizeInBytes)),comment:"LEAVE METHOD, TIDY UP FRAME")
        if self.block.lastStatementIsNotReturn
            {
            self.codeBuffer.emitInstruction(opcode:.ret)
            }
        self.codeBuffer.dump()
        }
    }
