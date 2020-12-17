//
//  ReturnStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ReturnStatement:ControlFlowStatement
    {
    internal var value:Expression?
    
    init(value:Expression,location:SourceLocation)
        {
        self.value = value
        super.init()
        self.location = location
        }
        
    required init()
        {
        super.init()
        }
    }
