//
//  SymbolSet.swift
//  spark
//
//  Created by Vincent Coetzee on 31/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SymbolSet:Equatable
    {
    public static func ==(lhs:SymbolSet,rhs:SymbolSet) -> Bool
        {
        return(lhs.symbols == rhs.symbols)
        }
        
    public var isEmpty:Bool
        {
        return(self.symbols.isEmpty)
        }
        
    internal var symbols:[Symbol] = []
        
    internal var first:Symbol?
        {
        return(self.symbols.first)
        }
        
    internal var method:Method?
        {
        for symbol in self.symbols
            {
            if symbol is Method
                {
                return(symbol as? Method)
                }
            }
        return(nil)
        }
        
    internal var module:Module?
        {
        for symbol in self.symbols
            {
            if symbol is Module
                {
                return(symbol as? Module)
                }
            }
        return(nil)
        }
        
    internal var `class`:Class?
        {
        for symbol in self.symbols
            {
            if symbol is Class
                {
                return(symbol as? Class)
                }
            }
        return(nil)
        }

    internal var variable:Variable?
        {
        for symbol in self.symbols
            {
            if symbol is Variable
                {
                return(symbol as? Variable)
                }
            }
        return(nil)
        }
        
    internal init(_ symbol:Symbol)
        {
        self.symbols.append(symbol)
        }
        
    internal init(_ someSymbols:[Symbol])
        {
        self.symbols = someSymbols
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
        
    public func lookup(name:Name) -> SymbolSet?
        {
        if name.isEmpty
            {
            return(self)
            }
        return(self.module?.lookup(name:name))
        }
        
    public func replaceSymbol(_ symbol:Symbol)
        {
        if self.isEmpty
            {
            self.symbols.append(symbol)
            return
            }
        self.symbols.removeAll(where:{Swift.type(of:$0) == Swift.type(of:symbol) && symbol.shortName == $0.shortName})
        self.symbols.append(symbol)
        }
        
    public func withoutSymbol(_ symbol:Symbol) -> SymbolSet
        {
        let newSet = SymbolSet(self.symbols)
        newSet.symbols.removeAll(where: {Swift.type(of:$0) == Swift.type(of:symbol) && $0.shortName == symbol.shortName})
        return(newSet)
        }
    }
