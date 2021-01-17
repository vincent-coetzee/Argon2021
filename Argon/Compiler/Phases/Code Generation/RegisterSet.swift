//
//  RegisterSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation

public class RegisterSet
    {
    private var registers:[RegisterIndex:Register] = [:]
    
    init()
        {
        self.registers[.rr] = Register.rr
        self.registers[.p0] = Register.p0
        self.registers[.p1] = Register.p1
        self.registers[.p2] = Register.p2
        self.registers[.p3] = Register.p3
        self.registers[.p4] = Register.p4
        self.registers[.p5] = Register.p5
        self.registers[.p6] = Register.p6
        self.registers[.p7] = Register.p7
        self.registers[.p8] = Register.p8
        self.registers[.p9] = Register.p9
        self.registers[.p10] = Register.p10
        self.registers[.p11] = Register.p11
        self.registers[.p12] = Register.p12
        self.registers[.p13] = Register.p13
        self.registers[.p14] = Register.p14
        self.registers[.p15] = Register.p15
        self.registers[.pr] = Register.pr
        self.registers[.cp0] = Register.cp0
        self.registers[.ci0] = Register.ci0
        self.registers[.cp1] = Register.cp1
        self.registers[.ci1] = Register.ci1
        self.registers[.cp2] = Register.cp2
        self.registers[.ci2] = Register.ci2
        self.registers[.cp3] = Register.cp3
        self.registers[.ci3] = Register.ci3
        }
    }
