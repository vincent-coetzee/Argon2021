//
//  OtherwiseClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class OtherwiseClause:Clause
    {
    private let block:Block
    
    init(block:Block)
        {
        self.block = block
        super.init()
        }
    }
