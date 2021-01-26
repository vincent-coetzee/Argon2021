//
//  LiteralSymbolExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralSymbolExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.symbolClass)
        }
        
    let symbol:Argon.Symbol
    
    init(symbol:Argon.Symbol)
        {
        self.symbol = symbol
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        fatalError("Logic should have been added here")
        }
    }
