//
//  FullyQualifiedNameExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class FullyQualifiedName:Class
    {
    let _name:Name
    
    override init(name:Name)
        {
        self._name = name
        super.init(shortName:name.stringName)
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
}
