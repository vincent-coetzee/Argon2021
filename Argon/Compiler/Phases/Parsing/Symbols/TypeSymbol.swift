//
//  Alas.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class TypeSymbol:Symbol,NSCoding
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
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    public override func encode(with coder:NSCoder)
        {
        coder.encode(self.baseType,forKey: "baseType")
        super.encode(with:coder)
        }
    }
