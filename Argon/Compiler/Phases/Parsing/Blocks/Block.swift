//
//  Block.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Block:Statement,SlotContainer
    {
    static func ==(lhs:Block,rhs:Block) -> Bool
        {
        return(lhs.statements == rhs.statements && lhs.symbols == rhs.symbols)
        }
        
    internal var statements:[Statement] = []
    internal var symbols:[String:SymbolSet] = [:]
    internal var marker:Int?

    init(parentScope:Scope)
        {
        self.marker = Argon.nextIndex()
        super.init()
        self.parentScope = parentScope
        }
    
    init(inductionVariable:InductionVariable)
        {
        self.marker = Argon.nextIndex()
        super.init()
        self.addSymbol(inductionVariable)
        }
        
    override init()
        {
        super.init()
        }
        
    internal var lastStatement:Statement
        {
        return(self.statements.last!)
        }
        
    internal func addSlot(_ slot:Slot)
        {
        self.addSymbol(slot)
        }

    internal override func addSymbol(_ symbol:Symbol)
        {
        if let set = self.symbols[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[symbol.shortName] = SymbolSet(symbol)
            }
        }
        
    internal override func addStatement(_ statement:Statement?)
        {
        if let aLine = statement
            {
            self.statements.append(aLine)
            }
        }

    internal func setStatements(_ statements:[Statement])
        {
        self.statements = statements
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName:shortName))
        }
        
    public override func typeCheck() throws
        {
        for statement in self.statements
            {
            try statement.typeCheck()
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        for statement in self.statements
            {
            try statement.generateIntermediateCode(in: module,codeHolder:CodeHolder.block(self), into: buffer, using: using)
            }
        }
    }
