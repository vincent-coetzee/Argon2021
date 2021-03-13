//
//  BlockStratement.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/13.
//

import Foundation

public class BlockStatement:Statement
    {
    public var container = SymbolContainer.nothing
    
    private var statements = Statements()
    private var symbols = SymbolDictionary()
    
    init(container:SymbolContainer)
        {
        self.container = container
        super.init()
        }
        
    public override func addStatement(_ statement:Statement)
        {
        self.statements.append(statement)
        }
        
    public func addLocalVariable(_ local:LocalVariable)
        {
        self.symbols.addSymbol(local)
        }
        
    public func addParameter(_ parameter:Parameter)
        {
        self.symbols.addSymbol(parameter)
        }
        
    public override func lookup(shortName:String) -> SymbolSet
        {
        let set = self.symbols.lookup(shortName:shortName)
        if set.isEmpty
            {
            return(self.container.lookup(shortName:shortName))
            }
        return(set)
        }
    }
