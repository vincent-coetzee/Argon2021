//
//  Pointer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/20.
//

import Foundation

public class GenericPointerClass:Class
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
    
    func specialize(elementType:TypeVariable) -> Pointer
        {
        return(Pointer(shortName:self.shortName,elementType:elementType))
        }
    }
    
public class Pointer:TemplateClass
    {
    private var elementType:TypeVariable?
    
    public override var isTemplateClass:Bool
        {
        return(true)
        }
        
    public init(shortName:String,elementType:TypeVariable)
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
