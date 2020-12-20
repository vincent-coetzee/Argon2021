//
//  Alas.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class TypeSymbol:Symbol
    {
    override internal var type:Type
        {
        return(self.baseType)
        }
        
    internal var baseType:Type
    
    internal init(shortName:String,baseType:Type)
        {
        self.baseType = baseType
        super.init(shortName: shortName)
        }
    
    internal init(name:Name,baseType:Type)
        {
        self.baseType = baseType
        super.init(shortName: name.first)
        }
        
    internal required init()
        {
        self.baseType = .class(Module.rootModule.nilClass)
        super.init(shortName:"")
        }
        
    internal override func pushScope()
        {
        super.push()
        }
    
    internal override func popScope()
        {
        super.pop()
        }
    }
