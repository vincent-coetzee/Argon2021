//
//  MemoryAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation

public typealias Address = UInt64

public typealias Word = UInt64

public struct RelativeAddress:Codable
    {
    var base:Address.Base = .zero
    var offset:Address.Offset = 0
    }
    
extension Address
    {
    public enum Base:Int,Codable
        {
        case zero
        case stack
        case `static`
        case data
        case code
        case managed
        }
        
    public typealias Offset = UInt64
        
    public static let TagMask:UInt64 = 0b11 << Self.TagShift
    public static let TagShift:UInt64 = 62
    
    public static let TagInteger:UInt64 = 0b00
    public static let TagObject:UInt64 = 0b01
    public static let TagFloat:UInt64 = 0b10
    public static let TagBits:UInt64 = 0b11
    
    public static let MaskInteger:UInt64 = 0b00 << TagShift
    public static let MaskObject:UInt64 = 0b01 << TagShift
    public static let MaskFloat:UInt64 = 0b10 << TagShift
    public static let MaskBits:UInt64 = 0b11 << TagShift
    
    public var tag:UInt64
        {
        return((self & Self.TagMask) >> Self.TagShift)
        }
        
    public func asIntegerAddress() -> Address
        {
        return((self & ~Self.MaskInteger) | Self.MaskInteger)
        }
        
    public func asFloarAddress() -> Address
        {
        return((self & ~Self.MaskFloat) | Self.MaskFloat)
        }
        
    public func asObjectAddress() -> Address
        {
        return((self & ~Self.MaskObject) | Self.MaskObject)
        }
        
    public func asBitsAddress() -> Address
        {
        return((self & ~Self.MaskBits) | Self.MaskBits)
        }
        
    public func wordAt() -> Word
        {
        fatalError("This may need to be implemented")
        }
    }
    
