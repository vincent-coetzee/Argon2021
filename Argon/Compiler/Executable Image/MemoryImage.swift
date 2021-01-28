//
//  MemoryImage.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MemoryImage
    {
    public static let shared = MemoryImage()
    
    let stackSegment = StackSegment(sizeInBytes: 1024*1024*10)
    let dataSegment = DataSegment(sizeInBytes: 1024*1024*10)
    let staticSegment = StaticSegment(sizeInBytes: 1024*1024*10)
    let codeSegment = CodeSegment(sizeInBytes: 1024*1024*10)
    let managedSegment = ManagedSegment(sizeInBytes: 1024*1024*10)
    
    public func setWord(_ word:Word,at address:MemoryAddress)
        {
        self.segmentAtIdentifier(address.segment.segment).setWord(word,at:address.offset)
        }
        
    public func segmentAtIdentifier(_ identifier:SegmentIdentifier) -> MemorySegment
        {
        if identifier == .stack
            {
            return(self.stackSegment)
            }
        else if identifier == .data
            {
            return(self.dataSegment)
            }
        else if identifier == .static
            {
            return(self.staticSegment)
            }
        else if identifier == .managed
            {
            return(self.managedSegment)
            }
        else if identifier == .code
            {
            return(self.codeSegment)
            }
        fatalError("Invalid segment")
        }
    }
