//
//  Segment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public enum MemoryWord
    {
    case integer(Argon.Integer)
    case float(Argon.Float)
    case pointer(MemoryAddress)
    case boolean(Argon.Boolean)
    case byte(Argon.Byte)
    case character(Argon.Character)
    }
    
public enum SegmentIdentifier
    {
    case none
    case `static`
    case data
    case managed
    case code
    }
    
public struct MemoryAddress
    {
    let segment:SegmentIdentifier
    let offset:Int
    
    init(segment:SegmentIdentifier,offset:Int)
        {
        self.segment = segment
        self.offset = offset
        }
    }
    
public class MemorySegment
    {
    class func segment() -> SegmentIdentifier
        {
        return(.none)
        }
        
    var words:[MemoryWord] = []
    
    public func append(_ integer:Argon.Integer) -> MemoryAddress
        {
        let offset = self.words.count * 8
        self.words.append(.integer(integer))
        return(MemoryAddress(segment:Self.segment(),offset:offset))
        }
        
    public func append(_ float:Argon.Float) -> MemoryAddress
        {
        let offset = self.words.count * 8
        self.words.append(.float(float))
        return(MemoryAddress(segment:Self.segment(),offset:offset))
        }
        
    public func append(_ pointer:MemoryAddress) -> MemoryAddress
        {
        let offset = self.words.count * 8
        self.words.append(.pointer(pointer))
        return(MemoryAddress(segment:Self.segment(),offset:offset))
        }
        
    public func append(_ boolean:Argon.Boolean) -> MemoryAddress
        {
        let offset = self.words.count * 8
        self.words.append(.boolean(boolean))
        return(MemoryAddress(segment:Self.segment(),offset:offset))
        }
    }
    
public class CodeSegment:MemorySegment
    {
    override class func segment() -> SegmentIdentifier
        {
        return(.code)
        }
    }
