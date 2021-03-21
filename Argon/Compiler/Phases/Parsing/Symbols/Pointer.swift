//
//  Pointer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation


public class PointerClass:Class
    {
    public init(shortName:String,elementType:Class)
        {
        super.init(shortName:shortName)
        self.elementType = elementType
        }
    
    public override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.elementType = .voidClass
        }
        
    required init() {
        fatalError("init() has not been implemented")
    }

    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}
