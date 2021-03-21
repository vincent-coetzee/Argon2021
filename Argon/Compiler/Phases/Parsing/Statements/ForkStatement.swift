//
//  ForkStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ForkStatement:ControlFlowStatement
    {
    internal let expression:Expression
    
    init(location:SourceLocation = .zero,expression:Expression)
        {
        self.expression = expression
        super.init(location:location)
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
