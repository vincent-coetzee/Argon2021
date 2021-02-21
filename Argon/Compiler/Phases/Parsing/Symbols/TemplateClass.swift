//
//  TypeVariable.swift
//  spark
//
//  Created by Vincent Coetzee on 22/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class TemplateClass:Class
    {
    public override var isTemplateClass:Bool
        {
        return(true)
        }
        
    public var typeVariables:Array<TypeVariable> = []
    
    internal override init(shortName:String)
        {
        super.init(shortName: shortName)
        }
        
    internal override init(name:Name)
        {
        super.init(shortName: name.first)
        }
    
    internal required init() {
        super.init(shortName: "")
    }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    public func specialize(with:[Class]) -> Class
        {
        fatalError()
        }
}

typealias TemplateClasses = Array<TemplateClass>

public class PlaceholderTemplateClass:TemplateClass
    {
    }
