//
//  CollectionClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class CollectionClass:Class
    {
    public let elementTypeClass:Class
    
     init(shortName:String,elementTypeClass:Class)
        {
        self.elementTypeClass = elementTypeClass
        super.init(shortName:shortName)
        }
    
    override init(shortName:String)
        {
        self.elementTypeClass = .voidClass
        super.init(shortName:shortName)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        fatalError("This should have been overridden")
        }
    }
