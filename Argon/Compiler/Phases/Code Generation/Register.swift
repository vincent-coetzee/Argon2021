//
//  Register.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation
    
public enum RegisterLocation
    {
    case absoluteAddress(Address)
    case relativeAddress(RelativeAddress)
    }
    
public class Register
    {
    public var index:RegisterIndex = .none
    public var isReserved = false
    public var isFloatingPoint = false
    public var locations:[RegisterLocation] = []
    
    init(index:RegisterIndex)
        {
        self.index = index
        }
        
    init(_ index:RegisterIndex)
        {
        self.index = index
        }
        
    public func reserve() -> Register
        {
        self.isReserved = true
        return(self)
        }
        
    public func makeFloatingPoint() -> Register
        {
        self.isFloatingPoint = true
        return(self)
        }
    }


