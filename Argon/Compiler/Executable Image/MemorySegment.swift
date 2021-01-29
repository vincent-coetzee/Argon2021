//
//  Segment.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MemorySegment:Codable
    {
    public var zero:MemoryAddress
        {
        return(MemoryAddress(segment:self,offset:0))
        }
        
    public var segment:SegmentIdentifier
        {
        return(.none)
        }
        
    var currentAddress:MemoryAddress
        {
        return(MemoryAddress(segment:self,offset:self.currentOffset))
        }
        
    public var memory:UnsafeMutableRawBufferPointer
    private var sizeInBytes:Int
    private var currentOffset = 0
    
    enum CodingKeys:String,CodingKey
        {
        case currentOffset
        case sizeInBytes
        case bytes
        case kind
        }
        
    init()
        {
        self.memory = UnsafeMutableRawBufferPointer.allocate(byteCount: 0, alignment: 0)
        self.sizeInBytes = 0
        }
        
    init(sizeInBytes:Int)
        {
        self.sizeInBytes = sizeInBytes
        self.memory = UnsafeMutableRawBufferPointer.allocate(byteCount: sizeInBytes, alignment: MemoryLayout<Word>.alignment)
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.decode(Data.self,forKey:.bytes)
        self.sizeInBytes = try values.decode(Int.self,forKey:.sizeInBytes)
        self.currentOffset = try values.decode(Int.self,forKey:.currentOffset)
        self.memory = UnsafeMutableRawBufferPointer.allocate(byteCount: self.sizeInBytes, alignment: MemoryLayout<Word>.alignment)
        self.memory.copyBytes(from:data)
        }
        
    public func updateAddress(_ symbol:Symbol)
        {
        symbol.memoryAddress.offset = self.currentOffset
        self.currentOffset += symbol.sizeInBytes
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = Data(bytesNoCopy: self.memory.baseAddress!, count: self.currentOffset, deallocator: .free)
        try container.encode(self.sizeInBytes,forKey:.sizeInBytes)
        try container.encode(self.currentOffset,forKey:.currentOffset)
        try container.encode(data,forKey:.bytes)
        }
        
    @inlinable
    public func setWord(_ word:Word,at offset:Int)
        {
        self.memory.storeBytes(of: word, toByteOffset: offset, as: Word.self)
        }
        
    @inlinable
    public func word(at:Int) -> Word
        {
        return(self.memory.load(fromByteOffset: at, as: Word.self))
        }
        
    public func append(string:Argon.String) -> MemoryAddress
        {
        let startAddress = self.currentOffset
        self.append(word: ObjectHeader(tag:Tag.header,count:10,kind:.kString).word)
        self.append(pointer:Class.stringClass.memoryAddress)
        self.append(word: Word(string.utf16.count))
        var bufferPointerPointer = self.append(word: 0)
        let count = string.utf16.count
        let size = (( count / 3 ) + 2 ) * 8
        let bufferPointer = self.allocateBuffer(ofSizeInBytes: size)
        var word:Word = 0
        var index = 0
        var offset = 0
        for unit in string.utf16
            {
            word |= Word(unit) << (48 - (index * 16))
            if index == 3
                {
                bufferPointer.setDataWord(word,at:offset)
                offset += 1
                word = 0
                index = 0
                }
            else
                {
                index += 1
                }
            }
        bufferPointerPointer.word = Word(pointer:bufferPointer.address)
        return(MemoryAddress(segment:self,offset:startAddress))
        }
        
    public func allocateBuffer(ofSizeInBytes:Int) -> BufferPointer
        {
        // Word for header, Word for class, Word for count, Word for size
        let totalSize = ofSizeInBytes + Word.kSizeInBytes + Word.kSizeInBytes + Word.kSizeInBytes + Word.kSizeInBytes
        let offset = self.currentOffset
        let wordCount = ofSizeInBytes / 8 + 4
        self.memory.storeBytes(of: ObjectHeader(tag: .header,count: wordCount,flipCount: 0,kind: .kBuffer).word, toByteOffset: offset, as: Word.self)
        self.memory.storeBytes(of: Class.bufferClass.memoryAddress,toByteOffset: offset)
        self.memory.storeBytes(of: 0,toByteOffset: offset)
        self.memory.storeBytes(of: ofSizeInBytes,toByteOffset: offset)
        self.currentOffset += totalSize
        return(BufferPointer(segment:self,offset:offset))
        }
        
    @discardableResult
    public func append(word:Word) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: word, toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
        
    @discardableResult
    public func append(integer:Argon.Integer) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(integer:integer), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
        
    @discardableResult
    public func append(float:Argon.Float) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(float:float), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }

    @discardableResult
    public func append(pointer:MemoryAddress) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(pointer:pointer), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
        
    @discardableResult
    public func append(_ boolean:Argon.Boolean) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(boolean:boolean), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
    
    @discardableResult
    public func append(_ byte:Argon.Byte) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(byte:byte), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
        
    @discardableResult
    public func append(_ character:Argon.Character) -> MemoryAddress
        {
        let offset = self.currentOffset
        self.currentOffset += MemoryLayout<Word>.size
        self.memory.storeBytes(of: Word(character:character), toByteOffset: offset, as: Word.self)
        return(MemoryAddress(segment:self,offset:offset))
        }
    }
    
extension UnsafeMutableRawBufferPointer
    {
    @inlinable
    func storeBytes(of pointer:MemoryAddress,toByteOffset:Int)
        {
        self.storeBytes(of:Word(pointer:pointer),toByteOffset:toByteOffset,as:Word.self)
        }
        
    @inlinable
    func storeBytes(of integer:Int,toByteOffset:Int)
        {
        self.storeBytes(of:integer,toByteOffset:toByteOffset,as:Int.self)
        }
    }

public class BufferPointer
    {
    public var address:MemoryAddress
        {
        return(MemoryAddress(segment: self.segment, offset: self.offset))
        }
        
    private let segment:MemorySegment
    private let offset:Int
    
    init(segment:MemorySegment,offset:Int)
        {
        self.segment = segment
        self.offset = offset
        }
        
    public func setDataWord(_ word:Word,at delta:Int)
        {
        let adjustment = self.offset + delta
        self.segment.setWord(word,at:adjustment)
        }
    }
