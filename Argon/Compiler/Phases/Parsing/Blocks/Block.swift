//
//  Block.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class Block:Statement,SlotContainer
    {
    static func ==(lhs:Block,rhs:Block) -> Bool
        {
        return(lhs.statements == rhs.statements && lhs.symbols == rhs.symbols)
        }
        
    internal var statements:[Statement] = []
    internal var symbols:[String:SymbolSet] = [:]
    
    init(parentScope:Scope)
        {
        super.init()
        self.parentScope = parentScope
        }
    
    required init()
        {
        super.init()
        }
    
    init(inductionVariable:InductionVariable)
        {
        super.init()
        self.addSymbol(inductionVariable)
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
        
    internal override func addStatement(_ statement:Statement)
        {
        self.statements.append(statement)
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
    }
