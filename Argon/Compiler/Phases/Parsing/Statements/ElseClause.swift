//
//  ElseClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class ElseClause:Clause
    {
    private let block:Block
    
    init(location:SourceLocation = .zero,block:Block)
        {
        self.block = block
        super.init(location:location)
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public typealias ElseClauses = Array<ElseClause>
