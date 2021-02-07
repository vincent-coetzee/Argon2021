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
        return("CLOSURE_\(self.index)")
        }
    
    internal var returnTypeClass:Class = .voidClass
    internal var parameters = Parameters()
    internal var block = Block()
    internal var symbols:[String:SymbolSet] = [:]
    internal var marker:Int?
    internal var ir3ABuffer = A3CodeBuffer()
    
    internal override init(shortName:String = "",parent:Symbol? = nil)
        {
        self.marker = Argon.nextIndex()
        super.init(shortName:shortName,parent:parent)
        }
    
    internal override init(name:Name = Name(),parent:Symbol? = nil)
        {
        self.marker = Argon.nextIndex()
        super.init(name:name,parent:parent)
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
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }

    internal override func addSymbol(_ symbol:Symbol)
        {
        self.block.addSymbol(symbol)
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
