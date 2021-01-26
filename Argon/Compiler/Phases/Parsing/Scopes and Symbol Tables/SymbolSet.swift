//
//  SymbolSet.swift
//  spark
//
//  Created by Vincent Coetzee on 31/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class SymbolSet:Equatable
    {
    static func ==(lhs:SymbolSet,rhs:SymbolSet) -> Bool
        {
        return(lhs.symbols == rhs.symbols)
        }
        
    internal var symbols:[Symbol] = []
        
    internal var first:Symbol
        {
        return(self.symbols.first!)
        }

    internal init(_ symbol:Symbol)
        {
        self.symbols.append(symbol)
        }
        
    internal init()
        {
        }
        
    internal func append(_ symbol:Symbol)
        {
        self.symbols.append(symbol)
        }
        
    internal func typeCheck() throws
        {
        }
        
    internal func allocateAddresses(using compiler:Compiler) throws
        {
        for symbol in self.symbols
            {
            try symbol.allocateAddresses(using:compiler)
            }
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using compiler:Compiler) throws
        {
        for symbol in self.symbols
            {
            try symbol.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:compiler)
            }
        }
    }
