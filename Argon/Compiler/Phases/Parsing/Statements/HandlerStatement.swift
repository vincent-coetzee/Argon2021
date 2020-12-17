//
//  HandlerStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class HandlerStatement:Statement
    {
    internal let inductionVariable:InductionVariable
    internal let block:Block
        
    init(inductionVariable:InductionVariable,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        super.init()
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
