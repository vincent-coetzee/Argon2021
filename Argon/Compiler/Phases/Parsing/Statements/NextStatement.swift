//
//  NextStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class NextStatement:ControlFlowStatement
    {
    private let arguments:Arguments
    
    init(arguments:Arguments)
        {
        self.arguments = arguments
        super.init()
        }
    }
