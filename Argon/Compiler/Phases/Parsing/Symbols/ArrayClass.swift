//
//  ArrayClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class GenericArrayClass:TemplateClass
    {
    private var typeNames:[String] = []
    
    init(shortName:String,typeNames:String...)
        {
        self.typeNames = typeNames
        super.init(shortName:shortName)
        }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public override func specialize(with:[Class]) -> Class
        {
        return(ArrayClass(shortName:self.shortName,indexType: (with[0] as! IndexType).indexType,elementType:with[1]))
        }
        
    func specialize(indexType:Type.ArrayIndexType,elementType:Class) -> ArrayClass
        {
        return(ArrayClass(shortName:self.shortName,indexType:indexType,elementType:elementType))
        }
    }
    
public class ArrayClass:CollectionClass
    {
    public let indexType:Type.ArrayIndexType
    
    init(shortName:String,indexType:Type.ArrayIndexType,elementType:Class)
        {
        self.indexType = indexType
        super.init(shortName:shortName,elementType:elementType)
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
    }
