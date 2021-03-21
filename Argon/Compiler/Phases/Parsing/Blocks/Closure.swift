//
//  ClosureBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Closure:Symbol
    {
    public var displayString: String
        {
        return("CLOSURE_\(self.id)")
        }
    
    internal var returnTypeClass:Class = .voidClass
    internal var parameters = Parameters()
    internal var block = Block()
    internal var symbols = SymbolDictionary()
    internal var marker:Int?
    internal var ir3ABuffer = A3CodeBuffer()
    
    internal override init(shortName:String = "",container:SymbolContainer = .nothing)
        {
        self.marker = Argon.nextIndex()
        super.init(shortName:shortName,container:container)
        }
    
    internal override init(name:Name = Name(),container:SymbolContainer = .nothing)
        {
        self.marker = Argon.nextIndex()
        super.init(name:name,container:container)
        }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.parameters.allocateAddresses(using:compiler)
        try self.block.allocateAddresses(using:compiler)
        for set in self.symbols.values
            {
            try set.allocateAddresses(using:compiler)
            }
        }
        
    public override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }

    public override func asSymbolContainer() -> SymbolContainer
        {
        return(.closure(self))
        }
        
    public func replaceConstant(_ constant:Constant)
        {
        self.symbols.replaceSymbol(constant)
        }
        
    public override func addLocalVariable(_ local:LocalVariable)
        {
        self.block.addLocalVariable(local)
        }
        
    public func addConstant(_ local:Constant)
        {
        self.block.addConstant(local)
        }
        
    public func addParameter(_ local:Parameter)
        {
        self.block.addParameter(local)
        }
        
    internal override func addStatement(_ statement:Statement?)
        {
        if let line = statement
            {
            self.block.addStatement(line)
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        try self.block.generateIntermediateCode(in:module,codeHolder:CodeHolder.closure(self),into:self.ir3ABuffer,using:using)
        }
    }
