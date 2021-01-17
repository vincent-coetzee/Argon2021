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
    
    init(location:SourceLocation = .zero,arguments:Arguments)
        {
        self.arguments = arguments
        super.init(location:location)
        }
    }
