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
    override internal var typeClass:Class
        {
        return(self.baseType)
        }
        
    internal var baseType:Class
    
    internal init(shortName:String,class:Class)
        {
        self.baseType = `class`
        super.init(shortName: shortName)
        }
    
    internal init(name:Name,class:Class)
        {
        self.baseType = `class`
        super.init(shortName: name.first)
        }
        
    internal required init()
        {
        self.baseType = Class.voidClass
        super.init(shortName:"")
        }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
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
