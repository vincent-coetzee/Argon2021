//
//  TitledSymbolList.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/07.
//

import Foundation

public class TitledSymbolList
    {
    public var childCount:Int
        {
        return(self.symbols.count)
        }
        
    public var title:String
    public var symbols:Array<Symbol>
    
    init(title:String,symbols:Array<Symbol>)
        {
        self.title = title
        self.symbols = symbols
        }
        
    public subscript(_ index:Int) -> Symbol
        {
        return(self.symbols[index])
        }
    }
