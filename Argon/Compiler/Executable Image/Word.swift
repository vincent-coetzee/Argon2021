//
//  Word.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/28.
//

import Foundation

public typealias Word = UInt64

extension Word
    {
    public static let kSizeInBytes = MemoryLayout<Word>.size
    
    init(integer:Argon.Integer)
        {
        let tag = (Argon.Integer(0b111) << 62)
        let value = integer & tag
        self = Word(bitPattern: value)
        }
        
    init(float:Argon.Float)
        {
        let tag = (Word(0b111) << 62)
        var value = float.bitPattern & tag
        value |= Tag.float.rawValue << 62
        self = value
        }
        
    public init(pointer:MemoryAddress)
        {
        let bits = pointer.segment.segment.bits
        var word = Tag.pointer.rawValue << 62
        word |= bits << 60
        word |= Word(pointer.offset)
        self = word
        }
        
    init(address:MemoryAddress)
        {
        let bits = address.segment.segment.bits
        var word = Tag.address.rawValue << 62
        word |= bits << 60
        word |= Word(address.offset)
        self = word
        }
        
    init(bits:Word)
        {
        var word = Tag.bits.rawValue << 62
        word |= bits
        self = word
        }
        
    init(boolean:Argon.Boolean)
        {
        var word = Tag.bits.rawValue << 62
        word |= boolean == .trueValue ? 1 : 0
        self = word
        }
        
    init(byte:Argon.Byte)
        {
        var word = Tag.bits.rawValue << 62
        word |= Word(byte)
        self = word
        }
        
    init(character:Argon.Character)
        {
        var word = Tag.bits.rawValue << 62
        word |= Word(character)
        self = word
        }
    }
