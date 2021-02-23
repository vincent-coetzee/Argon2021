//
//  ValueClass.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Foundation

public class ValueClass:Class
    {
    public override func encode(with coder:NSCoder)
        {
        super.encode(with:coder)
        }
    }

public class SystemPlaceholderValueClass:ValueClass
    {
    }
    
public class TemplateValueClass:ValueClass
    {
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
        
    public override func specialize(with:[Class]) -> Class
        {
        fatalError()
        }
}

public class SystemPlaceholderTemplateValueClass:TemplateValueClass
    {
    }
