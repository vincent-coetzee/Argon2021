//
//  SourceReference.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum SourceReference
    {
    public func encode(with coder: NSCoder)
        {
        switch(self)
            {
            case .declaration:
                coder.encode(1,forKey:"kind")
            case .read:
                coder.encode(2,forKey:"kind")
            case .write:
                coder.encode(3,forKey:"kind")
            }
        coder.encode(self.location.line,forKey:"line")
        coder.encode(self.location.lineStart,forKey:"lineStart")
        coder.encode(self.location.lineStop,forKey:"lineStop")
        coder.encode(self.location.tokenStart,forKey:"tokenStart")
        coder.encode(self.location.tokenStop,forKey:"tokenStop")
        }
    
    public init?(coder: NSCoder)
        {
        let aLine =  Int(coder.decodeInt64(forKey:"line"))
        let aLineStart = Int(coder.decodeInt64(forKey:"lineStart"))
        let aLineStop = Int(coder.decodeInt64(forKey:"lineStop"))
        let aTokenStart = Int(coder.decodeInt64(forKey:"tokenStart"))
        let aTokenStop = Int(coder.decodeInt64(forKey:"tokenStop"))
        let aLocation = SourceLocation(line: aLine, lineStart: aLineStart, lineStop: aLineStop, tokenStart: aTokenStart, tokenStop: aTokenStop)
        switch(coder.decodeInt64(forKey:"kind"))
            {
            case 1:
                self = .declaration(aLocation)
            case 2:
                self = .read(aLocation)
            case 3:
                self = .write(aLocation)
            default:
                fatalError("This can not happen")
            }
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
    
    public init(storageKind:StorageKind)
        {
        fatalError()
        }
        
    case declaration(SourceLocation)
    case read(SourceLocation)
    case write(SourceLocation)
    }
