//
//  SymbolTable.swift
//  spark
//
//  Created by Vincent Coetzee on 22/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal protocol SymbolTable
    {
    func addSymbol(_ symbol:Symbol)
    func lookup(name:Name) -> SymbolSet?
    func lookup(shortName:String) -> SymbolSet?
    }
