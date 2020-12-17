//
//  Alas.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class Alias:Symbol
    {
    internal var baseType:Type
    
    internal init(shortName:String,baseType:Type)
        {
        self.baseType = baseType
        super.init(shortName: shortName)
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
        
    internal override func populate(from parser:Parser)
        {
        }
    }
