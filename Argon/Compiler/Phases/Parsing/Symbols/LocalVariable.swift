//
//  LocalVariable.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/06.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LocalVariable:Variable
    {
    override init(name:Name,type:Type)
        {
        super.init(shortName:name.first,type:type)
        }
    
    override init(shortName:Identifier,type:Type)
        {
        super.init(shortName:shortName,type:type)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
