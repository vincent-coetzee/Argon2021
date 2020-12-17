//
//  ResumeStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ResumeStatement:ControlFlowStatement
    {
    private let signal:Expression
    
    init(signal:Expression,location:SourceLocation = .zero)
        {
        self.signal = signal
        super.init()
        self.location = location
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
