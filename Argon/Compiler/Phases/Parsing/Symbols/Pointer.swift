//
//  Pointer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class Pointer:Class
    {
    override internal var isGeneric:Bool
        {
        return(true)
        }
        
    public init(shortName:String,elementType:Class)
        {
        super.init(shortName:shortName)
        self.generics.append(GenericClass(elementType))
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }

required public init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
}
}
