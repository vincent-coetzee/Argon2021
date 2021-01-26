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
    
    init(name:Name)
        {
        self._name = name
        super.init(shortName:name.stringName)
        }
        
        
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
