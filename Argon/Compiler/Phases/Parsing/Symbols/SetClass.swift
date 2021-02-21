//
//  SetClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class TemplateSetClass:TemplateClass
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
        return(SetClass(shortName:self.shortName,elementType:with[0]))
        }
        
    func specialize(elementType:Class) -> Class
        {
        return(SetClass(shortName:self.shortName,elementType:elementType))
        }
    }
    
public class SetClass:CollectionClass
    {
    internal  func typeWithIndex(_ type:Type.ArrayIndexType) -> Class
        {
        return(SetClass(shortName:Argon.nextName("SET"),elementType:self.elementType))
        }
    }

public class SystemPlaceholderSetClass:SetClass
    {
    }
    
public class SystemPlaceholderTemplateSetClass:TemplateSetClass
    {
    public override func specialize(with:[Class]) -> Class
        {
        return(SystemPlaceholderSetClass(shortName:self.shortName,elementType:with[0]))
        }
        
    public override func specialize(elementType:Class) -> Class
        {
        return(SystemPlaceholderSetClass(shortName:self.shortName,elementType: elementType))
        }
    }
