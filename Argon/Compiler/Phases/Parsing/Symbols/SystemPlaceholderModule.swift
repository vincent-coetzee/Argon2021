//
//  SystemPlaceholderModule.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class SystemPlaceholderModule:Module
    {
    public override var symbolKind:SymbolKind
        {
        return(.placeholderModule)
        }
        
    public override var isPlaceholder:Bool
        {
        return(true)
        }
    }
