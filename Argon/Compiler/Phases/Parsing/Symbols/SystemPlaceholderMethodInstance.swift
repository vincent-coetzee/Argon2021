//
//  SystemPlaceholderMethodInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class SystemPlaceholderMethodInstance:MethodInstance
    {
    public override var symbolKind:SymbolKind
        {
        return(.placeholderMethodInstance)
        }
        
    public override var isPlaceholder:Bool
        {
        return(true)
        }
    }
