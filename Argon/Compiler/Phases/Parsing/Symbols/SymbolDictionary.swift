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
        
    public func lookup(shortName:String) -> SymbolSet
        {
        if let set = self[shortName]
            {
            return(set)
            }
        return(SymbolSet())
        }
    }

public typealias SimpleSymbolDictionary = Dictionary<String,Symbol>
