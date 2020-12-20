//
//  Pointer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class Pointer:ValueClass
    {
    override internal var isGeneric:Bool
        {
        return(true)
        }
        
    public init(shortName:String,elementType:Type)
        {
        super.init(shortName:shortName)
        self.generics.append(GenericType(elementType))
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
