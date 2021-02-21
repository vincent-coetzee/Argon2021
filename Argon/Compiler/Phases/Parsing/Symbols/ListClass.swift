//
//  ListClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class TemplateListClass:TemplateClass
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
        
    func specialize(elementType:Class) -> Class
        {
        return(ListClass(shortName:self.shortName,elementType:elementType))
        }
    }
    
public class ListClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) ->Class
        {
        return(ListClass(shortName:Argon.nextName("LIST"),elementType:self.elementType))
        }
    }

public class SystemPlaceholderListClass:ListClass
    {
    }
    
public class SystemPlaceholderTemplateListClass:TemplateListClass
    {
    public override func specialize(with:[Class]) -> Class
        {
        return(SystemPlaceholderListClass(shortName:self.shortName,elementType:with[0]))
        }
        
    public override func specialize(elementType:Class) -> Class
        {
        return(SystemPlaceholderListClass(shortName:self.shortName,elementType: elementType))
        }
    }
