//
//  AliasStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class AliasStatement:Statement
    {
    private let alias:Alias
    
    init(alias:Alias)
        {
        self.alias = alias
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }