//
//  ThreeAddressConstant.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public enum ThreeAddressConstant:ThreeAddress
    {
    public var displayString:String
        {
        return("CONSTANT")
        }
        
    public func write(file: ObjectFile) throws
        {
        fatalError("This should not have been called")
        }
    }
