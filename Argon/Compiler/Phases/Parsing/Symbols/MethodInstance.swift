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
        for statement in self.block.statements
            {
            try statement.generateIntermediateCode(in:module,codeHolder:.methodInstance(self),into:self.ir3ABuffer,using:compiler)
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
