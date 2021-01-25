//
//  SourceReference.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum SourceReference:Record
    {
    public var recordKind:RecordKind
        {
        return(.sourceReference)
        }
    
    public var id:UUID
        {
        return(UUID())
        }
        
    public var className:String
        {
        return("SourceReference")
        }
    
    public  var rawValue:Int
        {
        switch(self)
            {
            case .declaration:
                return(1)
            case .read:
                return(2)
            case .write:
                return(3)
            }
        }
        
    public var location:SourceLocation
        {
        switch(self)
            {
            case .declaration(let location):
                return(location)
            case .read(let location):
                return(location)
            case .write(let location):
                return(location)
            }
        }
        
    public func write(file: ObjectFile) throws
        {
        try file.write(self.rawValue)
        try self.location.write(file:file)
        }
    
    case declaration(SourceLocation)
    case read(SourceLocation)
    case write(SourceLocation)
    
    public init(file:ObjectFile) throws
        {
        let index = try file.readInt()
        let location = try SourceLocation(file:file)
        switch(index)
            {
            case 1:
                self = .declaration(location)
            case 2:
                self = .read(location)
            case 3:
                self = .write(location)
            default:
                fatalError("This should not happen")
            }
        }
    }
