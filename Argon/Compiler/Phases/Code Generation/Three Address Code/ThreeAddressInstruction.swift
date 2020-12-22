//
//  ThreeAddressInstruction.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/22.
//

import Foundation

public class ThreeAddressInstruction
    {
    let result:ThreeAddress?
    let lhs:ThreeAddress
    let rhs:ThreeAddress?
    let operation:Token.Symbol
    
    init(_ result:ThreeAddress?,_ lhs:ThreeAddress,_ operation:Token.Symbol,_ rhs:ThreeAddress?)
        {
        self.result = result
        self.lhs = lhs
        self.operation = operation
        self.rhs = rhs
        }
    }
