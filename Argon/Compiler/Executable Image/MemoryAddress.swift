//
//  MemoryAddress.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public class MemoryAddress:NSObject,NSCoding
    {
    public static let zero = MemoryAddress(segment: MemorySegment(),offset:0)
    
    public var taggedAddress:Word
        {
        let tag = Tag.address.rawValue << Tag.kShift
        let segmentValue = self.segment.segment.bits << 60
        let value = tag | segmentValue | Word(offset)
        return(value)
        }
        
    public var word:Word
        {
        get
            {
            return(segment.word(at:self.offset))
            }
        set
            {
            self.segment.setWord(newValue,at:self.offset)
            }
        }
        

    let segment:MemorySegment
    
    public var offset:Int
    
    public var displayString:String
        {
        return("\(segment.segment):\(offset)")
        }
        
    init(segment:MemorySegment,offset:Int)
        {
        self.segment = segment
        self.offset = offset
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.segment.segment.rawValue,forKey:"segment")
        coder.encode(self.offset,forKey:"offset")
        }
    
    public required init?(coder: NSCoder)
        {
        self.segment = MemoryImage.shared.segmentAtIdentifier(SegmentIdentifier(rawValue: coder.decodeObject(forKey:"segment") as! String)!)
        self.offset = Int(coder.decodeInt64(forKey:"offset"))
        }
    }
