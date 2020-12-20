//
//  MethodInvocationStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class MethodInvocationStatement:ControlFlowStatement
    {
    }

internal class InvocationStatement:MethodInvocationStatement
    {
    let name:Name
    let arguments:Arguments
    
    init(name:Name,arguments:Arguments)
        {
        self.name = name
        self.arguments = arguments
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
