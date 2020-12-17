//
//  LetStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LetStatement:Statement
    {
    private let variable:Variable
    
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
