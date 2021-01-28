//
//  SegmentIdentifier.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public enum SegmentIdentifier:String
    {
    case none = "NONE"
    case `static` = "KS"
    case data = "DS"
    case managed = "MS"
    case code = "CS"
    case stack = "SS"
    
    var bits:Word
        {
        switch(self)
            {
            case .none:
                return(0)
            case .static:
                return(1)
            case .data:
                return(2)
            case .managed:
                return(3)
            case .code:
                return(4)
            case .stack:
                return(5)
            }
        }
        
    init?(bits:Word)
        {
        if bits == 0
            {
            self = .none
            }
        else if bits == 1
            {
            self = .static
            }
        else if bits == 2
            {
            self = .data
            }
        else if bits == 3
            {
            self = .managed
            }
        else if bits == 4
            {
            self = .code
            }
        else if bits == 5
            {
            self = .stack
            }
        else
            {
            return(nil)
            }
        }
    }
    
