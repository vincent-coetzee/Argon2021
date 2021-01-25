//
//  IndirectMemoryRegisterOffsetAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class IndirectMemoryRegisterOffsetAddress:ThreeAddress
    {
    public func write(file: ObjectFile) throws
        {
        try file.write(character:"O")
        try self.baseRegister.write(file:file)
        try self.offsetRegister.write(file:file)
        try self.offset.write(file:file)
        }
        
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
