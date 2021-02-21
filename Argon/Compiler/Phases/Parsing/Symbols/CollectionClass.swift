//
//  CollectionClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class CollectionClass:TemplateClass
    {
    public var elementType:Class
    
     init(shortName:String,elementType:Class)
        {
        self.elementType = elementType
        super.init(shortName:shortName)
        }
    
    override init(shortName:String)
        {
        self.elementType = .voidClass
        super.init(shortName:shortName)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    internal override func typeWithIndex(_ type:Type.ArrayIndexType) -> Type
        {
        fatalError("This should have been overridden")
        }
    }


public class SystemPlaceholderCollectionClass:CollectionClass
    {
    }
