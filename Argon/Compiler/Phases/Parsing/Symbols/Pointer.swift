//
//  Pointer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class TemplatePointerClass:TemplateClass
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
    
    func specialize(elementType:Class) -> Class
        {
        return(PointerClass(shortName:self.shortName,elementType:elementType))
        }
    }
    
public class PointerClass:TemplateClass
    {
    private var elementType:Class?
    
    public override var isTemplateClass:Bool
        {
        return(true)
        }
        
    public init(shortName:String,elementType:Class)
        {
        super.init(shortName:shortName)
        self.elementType = elementType
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}

public class SystemPlaceholderPointerClass:PointerClass
    {
    }
    
public class SystemPlaceholderTemplatePointerClass:TemplatePointerClass
    {
    public override func specialize(with:[Class]) -> Class
        {
        return(SystemPlaceholderPointerClass(shortName:self.shortName,elementType:with[0]))
        }
        
    public override func specialize(elementType:Class) -> Class
        {
        return(SystemPlaceholderSetClass(shortName:self.shortName,elementType: elementType))
        }
    }
