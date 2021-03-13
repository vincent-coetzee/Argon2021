//
//  MacroExpander.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/09.
//

import Foundation
    
public class MacroExpander
    {
    private var macros:[String:Macro] = [:]
    
    public func addMacro(_ macro:Macro)
        {
        self.macros[macro.shortName] = macro
        }
    }
