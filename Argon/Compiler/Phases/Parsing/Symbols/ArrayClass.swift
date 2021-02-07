//
//  ArrayClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class ArrayClass:CollectionClass
    {
    public let indexType:Type.ArrayIndexType
    
    init(shortName:String,indexType:Type.ArrayIndexType,elementTypeClass:Class)
        {
        self.indexType = indexType
        super.init(shortName:shortName,elementTypeClass:elementTypeClass)
        }
    
    override init(shortName:String)
        {
        self.indexType = .none
        super.init(shortName:shortName)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    internal func classWithIndex(_ type:Type.ArrayIndexType) -> Class
        {
        return(ArrayClass(shortName:Argon.nextName("ARRAY"),indexType:type,elementTypeClass:self.elementTypeClass))
        }
    }
