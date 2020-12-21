//
//  RegisterSet.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation

public class RegisterSet
    {
    static let rr = Register(.rr).reserve()
    static let p0 = Register(.p0).reserve()
    static let p1 = Register(.p1).reserve()
    static let p2 = Register(.p2).reserve()
    static let p3 = Register(.p3).reserve()
    static let p4 = Register(.p4).reserve()
    static let p5 = Register(.p5).reserve()
    static let p6 = Register(.p6).reserve()
    static let p7 = Register(.p7).reserve()
    static let p8 = Register(.p8).reserve()
    static let p9 = Register(.p9).reserve()
    static let p10 = Register(.p10).reserve()
    static let p11 = Register(.p11).reserve()
    static let p12 = Register(.p12).reserve()
    static let p13 = Register(.p13).reserve()
    static let p14 = Register(.p14).reserve()
    static let p15 = Register(.p15).reserve()
    static let pr = Register(.pr).reserve()
    static let cp0 = Register(.cp0)
    static let ci0 = Register(.ci0)
    static let cp1 = Register(.cp1)
    static let ci1 = Register(.ci1)
    static let cp2 = Register(.cp2)
    static let ci2 = Register(.ci2)
    static let cp3 = Register(.cp3)
    static let ci3 = Register(.ci3)
    static let wr = Register(.wr)
    static let bp = Register(.bp)
    static let sp = Register(.sp)
    static let ip = Register(.ip)
    static let ss = Register(.ss)
    static let ds = Register(.ds)
    static let ms = Register(.ms)
    static let xs = Register(.xs)
    static let cs = Register(.cs)
    static let flags = Register(.flags)
    static let r0 = Register(.r0)
    static let r1 = Register(.r1)
    static let r2 = Register(.r2)
    static let r3 = Register(.r3)
    static let r4 = Register(.r4)
    static let r5 = Register(.r5)
    static let r6 = Register(.r6)
    static let r7 = Register(.r7)
    static let r8 = Register(.r8)
    static let r9 = Register(.r9)
    static let r10 = Register(.r10)
    static let r11 = Register(.r11)
    static let r12 = Register(.r12)
    static let r13 = Register(.r13)
    static let r14 = Register(.r14)
    static let r15 = Register(.r15)
    static let r16 = Register(.r16)
    static let r17 = Register(.r17)
    static let r18 = Register(.r18)
    static let r19 = Register(.r19)
    static let r20 = Register(.r20)
    static let r21 = Register(.r21)
    static let r22 = Register(.r22)
    static let r23 = Register(.r23)
    static let r24 = Register(.r24)
    static let r25 = Register(.r25)
    static let r26 = Register(.r26)
    static let r27 = Register(.r27)
    static let r28 = Register(.r28)
    static let r29 = Register(.r29)
    static let r30 = Register(.r30)
    static let r31 = Register(.r31)
    
    private var registers:[RegisterIndex:Register] = [:]
    

    
    init()
        {
        self.registers[.rr] = Self.rr
        self.registers[.p0] = Self.p0
        self.registers[.p1] = Self.p1
        self.registers[.p2] = Self.p2
        self.registers[.p3] = Self.p3
        self.registers[.p4] = Self.p4
        self.registers[.p5] = Self.p5
        self.registers[.p6] = Self.p6
        self.registers[.p7] = Self.p7
        self.registers[.p8] = Self.p8
        self.registers[.p9] = Self.p9
        self.registers[.p10] = Self.p10
        self.registers[.p11] = Self.p11
        self.registers[.p12] = Self.p12
        self.registers[.p13] = Self.p13
        self.registers[.p14] = Self.p14
        self.registers[.p15] = Self.p15
        self.registers[.pr] = Self.pr
        self.registers[.cp0] = Self.cp0
        self.registers[.ci0] = Self.ci0
        self.registers[.cp1] = Self.cp1
        self.registers[.ci1] = Self.ci1
        self.registers[.cp2] = Self.cp2
        self.registers[.ci2] = Self.ci2
        self.registers[.cp3] = Self.cp3
        self.registers[.ci3] = Self.ci3
        }
    }
