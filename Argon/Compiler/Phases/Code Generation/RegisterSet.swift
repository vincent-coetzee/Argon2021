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
        self.registers[.cp0] = Register.cp0
        self.registers[.ci0] = Register.ci0
        self.registers[.cp1] = Register.cp1
        self.registers[.ci1] = Register.ci1
        self.registers[.cp2] = Register.cp2
        self.registers[.ci2] = Register.ci2
        self.registers[.cp3] = Register.cp3
        self.registers[.ci3] = Register.ci3
        self.registers[.wr] = Register.wr
        self.registers[.bp] = Register.bp
        self.registers[.sp] = Register.sp
        self.registers[.ip] = Register.ip
        self.registers[.ss] = Register.ss
        self.registers[.ds] = Register.ds
        self.registers[.ms] = Register.ms
        self.registers[.xs] = Register.xs
        self.registers[.cs] = Register.cs
        self.registers[.flags] = Register.flags
        self.registers[.r0] = Register.r0
        self.registers[.r1] = Register.r1
        self.registers[.r2] = Register.r2
        self.registers[.r3] = Register.r3
        self.registers[.r4] = Register.r4
        self.registers[.r5] = Register.r5
        self.registers[.r6] = Register.r6
        self.registers[.r7] = Register.r7
        self.registers[.r8] = Register.r8
        self.registers[.r9] = Register.r9
        self.registers[.r10] = Register.r10
        self.registers[.r11] = Register.r11
        self.registers[.r12] = Register.r12
        self.registers[.r13] = Register.r13
        self.registers[.r14] = Register.r14
        self.registers[.r15] = Register.r15
        self.registers[.r16] = Register.r16
        self.registers[.r17] = Register.r17
        self.registers[.r18] = Register.r18
        self.registers[.r19] = Register.r19
        self.registers[.r20] = Register.r20
        self.registers[.r21] = Register.r21
        self.registers[.r22] = Register.r22
        self.registers[.r23] = Register.r23
        self.registers[.r24] = Register.r24
        self.registers[.r25] = Register.r25
        self.registers[.r26] = Register.r26
        self.registers[.r27] = Register.r26
        self.registers[.r28] = Register.r28
        self.registers[.r29] = Register.r29
        self.registers[.r30] = Register.r30
        self.registers[.r31] = Register.r31
        }
    }
