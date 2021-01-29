//
//  ContainerSymbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SymbolContainer:Symbol
    {
    public override var isScope:Bool
        {
        return(true)
        }
        
    internal var symbols:[String:SymbolSet] = [:]
        
    enum CodingKeys:String,CodingKey
        {
        case symbols
        }
        
    public init(shortName:String)
        {
        super.init(shortName:shortName)
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.symbols = try values.decode(Dictionary<String,SymbolSet>.self,forKey: .symbols)
        try super.init(from: try values.superDecoder())
        self.memoryAddress = Compiler.shared.staticSegment.zero
        }
        
    internal override func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        super.relinkSymbolsUsingIds(symbols:symbols)
        for set in self.symbols.values
            {
            for symbol in set.symbols
                {
                symbol.relinkSymbolsUsingIds(symbols:symbols)
                }
            }
        }
        
    internal override func symbolsKeyedById() -> Dictionary<UUID,Symbol>
        {
        var this = Dictionary<UUID,Symbol>()
        for set in self.symbols.values
            {
            for symbol in set.symbols
                {
                let inside = symbol.symbolsKeyedById()
                let closure = {(s1:Symbol,s2:Symbol) in return(s1)}
                this.merge(inside, uniquingKeysWith: closure)
                }
            }
        return(this)
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.symbols,forKey:.symbols)
        try super.encode(to: container.superEncoder())
        }
        
    internal override func addSymbol(_ symbol:Symbol)
        {
        if symbol.isModuleLevelSymbol && !(self is Module)
            {
            self.parentScope?.addSymbol(symbol)
            return
            }
        if let set = self.symbols[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[symbol.shortName] = SymbolSet(symbol)
            }
        symbol.parent = self
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        if shortName == self.shortName
            {
            return(SymbolSet(self))
            }
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
