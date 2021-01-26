//
//  IndirectMemoryRegisterOffsetAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class IndirectMemoryRegisterOffsetAddress
    {
    public var displayString:String
        {
        let sign = self.offset < 0 ? " - " : " + "
        let unsignedOffset = abs(self.offset)
        return("\(self.baseRegister.displayString)[\(self.offsetRegister.displayString)\(sign)\(unsignedOffset)]")
        }
        
    let baseRegister:Register
    let offsetRegister:Register
    let offset:Int
    
    init(baseRegister:Register,offsetRegister:Register,offset:Int)
        {
        self.baseRegister = baseRegister
        self.offsetRegister = offsetRegister
        self.offset = offset
        }
    }
