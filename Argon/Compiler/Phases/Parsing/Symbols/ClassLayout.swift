//
//  ClassLayout.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public class ClassDescriptor
    {
    private static let kBytesPerSlot = 8
    private static let kClassOffset = 0
    
    private var offsets:Array<Int?>
    private let n:Int
    private var nextOffset = 16
    private let instanceSize:Int
    
    init(n:Int,instanceSize:Int)
        {
        self.instanceSize = instanceSize
        self.n = n
        self.offsets = Array<Int?>.init(repeating: nil, count: self.n)
        }
        
    func offsetForField(named:String) -> Int?
        {
        let index = self.hash(of:named,n:self.n)
        let offset = self.offsets[index]
        return(offset)
        }
        
    func insertField(named:String) throws -> Int
        {
        var index = self.hash(of:named,n:self.n)
        var offset = self.offsets[index]
        if offset != nil
            {
            while self.offsets[index] != nil
                {
                index += 1
                }
            }
        offset = self.nextOffset
        self.offsets[index] = offset
        self.nextOffset += Self.kBytesPerSlot
        return(offset!)
        }
        
    func hash(of:String,n:Int) -> Int
        {
        return(of.hashValue % n)
        }
    }
    
    
