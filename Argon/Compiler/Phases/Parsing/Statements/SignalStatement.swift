//
//  SignalStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class SignalStatement:ControlFlowStatement
    {
    private let signal:Expression
    
    required init(signal:Expression,location:SourceLocation = .zero)
        {
        self.signal = signal
        super.init()
        self.location = location
        }
    
    required init()
        {
        self.signal = Expression.none
        super.init()
        }
    }
