//
//  SymbolDictionary.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/12.
//

import Foundation

public typealias SymbolDictionary = Dictionary<String,SymbolSet>

extension SymbolDictionary
    {
    public var symbols:Symbols
        {
        return(self.values.reduce(into:[]){$0.append(contentsOf:$1.symbols)})
        }
        
    public mutating func addSymbol(_ symbol:Symbol)
        {
        if let set = self[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self[symbol.shortName] = SymbolSet(symbol)
            }
        }
        
    public func lookup(shortName:String) -> SymbolSet?
        {
        return(self[shortName])
        }
        
    public func lookup(name:Name) -> SymbolSet?
        {
        if let set = self[name.first]
            {
            return(set.lookup(name:name.withoutFirst()))
            }
        return(nil)
        }
    }

public typealias SimpleSymbolDictionary = Dictionary<String,Symbol>
