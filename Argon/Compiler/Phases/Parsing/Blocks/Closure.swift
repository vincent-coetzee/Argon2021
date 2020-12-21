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
    internal var returnType:Type = .void
    internal var parameters = Parameters()
    internal var block = Block()
    internal var symbols:[String:SymbolSet] = [:]
    
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }

        
    internal override func addSymbol(_ symbol:Symbol)
        {
        self.block.addSymbol(symbol)
        }
        
    internal override func addStatement(_ statement:Statement)
        {
        self.block.addStatement(statement)
        }
    }
