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
    internal var functionName:String?
    internal var returnTypeClass:Class
    internal var _parameters = Parameters()
    internal var block = Block()
    internal var ir3ABuffer = ThreeAddressInstructionBuffer()
    internal var localVariables:[LocalVariable] = []
    internal var stackLocalStorageSizeInBytes = 0
    
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
        super.init(shortName: shortName)
        }
        
    internal required init()
        {
        self.owner = RootModule.rootModule.nilInstance
        self.returnTypeClass = .voidClass
        super.init()
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }
        
    internal override func typeCheck() throws
        {
        try self.block.typeCheck()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using compiler:Compiler) throws
        {
        self.localVariables = self.block.blockLocalVariables
        var localOffset = -Argon.kWordSizeInBytes
        for local in self.localVariables
            {
            local.stackOffsetFromBasePointer = localOffset
            localOffset -= Argon.kWordSizeInBytes
            }
        self.stackLocalStorageSizeInBytes = self.localVariables.count * Argon.kWordSizeInBytes
        ir3ABuffer.emitInstruction(opcode:.comment,right:"METHOD \(self.shortName)")
        var parameterOffset = Argon.kWordSizeInBytes
        for parameter in self.parameters
            {
            parameter.stackOffsetFromBasePointer = parameterOffset
            parameterOffset += Argon.kWordSizeInBytes
            }
        
        self.ir3ABuffer.emitInstruction(opcode:.push,right:Register.bp,comment:"SAVE POINTER TO PREVIOUS FRAME")
        self.ir3ABuffer.emitInstruction(left:Register.sp,opcode:.mov,right:Register.bp,comment:"MAKE THIS FRAME AVAILABLE")
        self.ir3ABuffer.emitInstruction(result:Register.sp,left:Register.sp,opcode:.sub,right:self.stackLocalStorageSizeInBytes,comment:"ADJUST SP DOWN FOR LOCAL STORAGE")
        for statement in self.block.statements
            {
            try statement.generateIntermediateCode(in:module,codeHolder:.methodInstance(self),into:self.ir3ABuffer,using:compiler)
            }
        self.ir3ABuffer.emitInstruction(result:Register.sp,left:Register.sp,opcode:.add,right:self.stackLocalStorageSizeInBytes,comment:"RELEASE LOCAL STORAGE")
        self.ir3ABuffer.emitInstruction(opcode:.pop,right:Register.bp,comment:"RESTORE BASE POINTER")
        if self.block.lastStatementIsNotReturn
            {
            self.ir3ABuffer.emitInstruction(opcode:.ret)
            }
        self.ir3ABuffer.dump()
        }
    }

public class HollowMethod:MethodInstance
    {
    var parms:[ParameterName]
    
    init(_ name:String,_ parameters:[ParameterName])
        {
        self.parms = parameters
        super.init(shortName:name)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
