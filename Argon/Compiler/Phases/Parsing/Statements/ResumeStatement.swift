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
    
    init(location:SourceLocation = .zero,signal:Expression)
        {
        self.signal = signal
        super.init(location:location)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.signal.allocateAddresses(using:compiler)
        }
//    
//    required init()
//        {
//        fatalError("init() has not been implemented")
//        }
    }
