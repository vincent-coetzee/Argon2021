//
//  StatementBlock.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal protocol StatementBlock
    {
    var parentScope:Scope? { get set }
    func addStatement(_ statement:Statement)
    func addSymbol(_ symbol:Symbol)
    func lookup(shortName:String) -> SymbolSet?
    }
