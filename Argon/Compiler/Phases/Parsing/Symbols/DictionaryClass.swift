//
//  DictionaryClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class TemplateDictionaryClass:TemplateClass
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
        return(DictionaryClass(shortName:self.shortName,elementType:with[0]))
        }
        
        
    func specialize(keyType:Class,valueType:Class) -> Class
        {
        return(DictionaryClass(shortName:self.shortName,elementType:AssociationClass(keyClass: keyType, valueClass: valueType)))
        }
    }
    
public class DictionaryClass:CollectionClass
    {
    override init(shortName:String,elementType:Class)
        {
        super.init(shortName:shortName,elementType:elementType)
        self.elementType = elementType
        }
    
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }

public class SystemPlaceholderDictionaryClass:DictionaryClass
    {
    }
    
public class SystemPlaceholderTemplateDictionaryClass:TemplateDictionaryClass
    {
    public override func specialize(with:[Class]) -> Class
        {
        return(SystemPlaceholderDictionaryClass(shortName:self.shortName,elementType:with[0]))
        }
        
    public override func specialize(keyType:Class,valueType:Class) -> Class
        {
        return(SystemPlaceholderDictionaryClass(shortName:self.shortName,elementType:AssociationClass(keyClass: keyType, valueClass: valueType)))
        }
    }
