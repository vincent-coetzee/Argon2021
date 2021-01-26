//
//  Register.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation
    
public enum RegisterLocation:Codable
    {
    public init(from decoder: Decoder) throws
        {
        try self.init(from: decoder)
        }
    
    public func encode(to encoder: Encoder) throws
        {
        
        }
    
    case absoluteAddress(Address)
    case relativeAddress(RelativeAddress)
    }
    
public class Register:Codable
    {
    public var displayString: String
        {
        return("\(self.index)")
        }
        
    static let rr = Register(.rr).reserve()
    static let cp0 = Register(.cp0).reserve()
    static let ci0 = Register(.ci0).reserve()
    static let cp1 = Register(.cp1).reserve()
    static let ci1 = Register(.ci1).reserve()
    static let cp2 = Register(.cp2).reserve()
    static let ci2 = Register(.ci2).reserve()
    static let cp3 = Register(.cp3).reserve()
    static let ci3 = Register(.ci3).reserve()
    static let wr = Register(.wr).reserve()
    static let bp = Register(.bp).reserve()
    static let sp = Register(.sp).reserve()
    static let ip = Register(.ip).reserve()
    static let ss = Register(.ss).reserve()
    static let ds = Register(.ds).reserve()
    static let ms = Register(.ms).reserve()
    static let xs = Register(.xs).reserve()
    static let cs = Register(.cs).reserve()
    static let flags = Register(.flags).reserve()
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


