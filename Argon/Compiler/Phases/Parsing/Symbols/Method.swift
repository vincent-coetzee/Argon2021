//
//  Method.swift
//  spark
//
//  Created by Vincent Coetzee on 28/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Method:Symbol
    {
    internal var owner:Symbol?
    internal var functionName:String?
    internal var returnType:Type
    internal var parameters:[Parameter] = []
    internal var block = Block()
    
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
    
    internal override func addSymbol(_ symbol: Symbol)
        {
        self.block.addSymbol(symbol)
        }

    internal override func addStatement(_ statement: Statement)
        {
        self.block.addStatement(statement)
        }
    
    internal init(shortName:String,owner:Symbol? = nil)
        {
        self.owner = owner
        self.returnType = .class(Module.rootModule.voidClass)
        super.init(shortName: shortName)
        }
        
    internal required init()
        {
        self.owner = RootModule.rootModule.nilInstance
        self.returnType = .class(Module.rootModule.voidClass)
        super.init()
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }
    }

public class HollowMethod:Method
    {
    var parms:[ParameterName]
    
    init(_ name:String,_ parameters:[ParameterName])
        {
        self.parms = parameters
        super.init(shortName:name)
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
