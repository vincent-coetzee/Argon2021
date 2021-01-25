//
//  BinaryFile.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/21.
//

import Foundation

public class ObjectFile:BinaryFile
    {
    private enum ObjectType:Int
        {
        case object = 1
        case objectReference = 2
        case embedded = 3
        }
        
    private struct CacheEntry
        {
        var record:Record
        let offset:Int
        let uuid:UUID
        let kind:RecordKind
        
        init(record:Record,offset:Int)
            {
            self.record = record
            self.offset = offset
            self.uuid = record.id
            self.kind = record.recordKind
            }
            
        init(file:ObjectFile) throws
            {
            self.offset = try file.readInt()
            self.uuid = UUID(uuidString:try file.readString())!
            self.kind = RecordKind(rawValue: try file.readInt())!
            self.record = try EmptyRecord(file:file)
            }
            
        func write(file: ObjectFile) throws
            {
            try file.write(offset)
            try file.write(uuid)
            try file.write(kind)
            }
        }
        
    private var file:UnsafeMutablePointer<FILE>?
    private let path:String
    private var cache:[UUID:CacheEntry] = [:]
    
    public func readInt() throws -> Int
        {
        let size = MemoryLayout<Int>.size
        var integer:Int = 0
        let bytesRead = fread(&integer,size,1,self.file)
        if bytesRead != size
            {
            throw(CompilerError(.readFailedWithLessBytesRead(size,bytesRead,errno),SourceLocation.zero))
            }
        return(integer)
        }
        
    public func readString() throws -> String
        {
        let count = try self.readInt()
        var character:UInt8 = 0
        var bytes:[UInt8] = []
        for _ in 0..<count
            {
            fread(&character,1,1,self.file)
            bytes.append(character)
            }
        return(String(bytes:bytes,encoding: .utf8)!)
        }
        
    public func readArray<S>(of type:S.Type) throws -> Array<S> where S:Record
        {
        let count = try self.readInt()
        var array:Array<S> = []
        for _ in 0..<count
            {
            let kind = try RecordKind(rawValue:self.readInt())!
            let maker = kind.kindMaker()
            let item = try maker(self)
            array.append(item as! S)
            }
        return(array)
        }
        
    public func seek(_ offset:FileOffset)
        {
        switch(offset)
            {
            case .origin(let location):
                fseek(file,location,SEEK_SET)
            case .current(let location):
                fseek(file,location,SEEK_CUR)
            case .end(let location):
                fseek(file,location,SEEK_END)
            }
        }
        
    public func write(character:Character) throws
        {
        var value = character.utf8.first!
        let size = MemoryLayout<String.UTF8View.Element>.size
        fwrite(&value,size,1,self.file)
        }
        
    public func write(_ string: String?) throws
        {
        if let aString = string
            {
            try self.write(aString.count)
            for character in aString.utf8
                {
                try self.write(character)
                }
            }
        else
            {
            try self.write(-1)
            }
        }
        
    public var currentFileOffset:Int
        {
        let location = ftell(self.file)
        return(location)
        }
        
    public func write(_  unit:UInt8) throws
        {
        var pointer = unit
        fwrite(&pointer,1,1,self.file)
        }
        
    public func write(_ double:Double) throws
        {
        var pointer = double
        fwrite(&pointer,MemoryLayout<Double>.size,1,self.file)
        }
        
    public func write(_ string:UUID) throws
        {
        try self.write(string.uuidString)
        }
    
//    public func write(_ reference:ClassReference) throws
//        {
//        try self.write(reference.module.moduleKey)
//        try self.write(reference.theClass.shortName)
//        try self.write(reference.classIndex)
//        }
        
    public func write(_ boolean:Bool) throws
        {
        var pointer = boolean
        fwrite(&pointer,MemoryLayout<Bool>.size,1,self.file)
        }
    
    public func write(_ integer: Int) throws
        {
        var pointer = integer
        fwrite(&pointer,MemoryLayout<Int>.size,1,self.file)
        }
        
    public func write(_ name: Name?) throws
        {
        if name == nil
            {
            try self.write(-1)
            return
            }
        try name!.write(file:self)
        }
        
    public func write(_ number:SemanticVersionNumber) throws
        {
        try self.write(number.major)
        try self.write(number.minor)
        try self.write(number.patch)
        }
        
    public func write<S>(_ something:S) throws where S:Record
        {
        let isObject = type(of:something) is AnyClass
        try self.write(something.recordKind)
        if isObject
            {
            if let cachedEntry = self.cache[something.id]
                {
                try self.write(RecordKind.reference)
                try self.write(something.recordKind)
                try self.write(cachedEntry.uuid)
                }
            else
                {
                try self.write(something.recordKind)
                let offset = self.currentFileOffset
                let cacheEntry = CacheEntry(record:something,offset:offset)
                self.cache[something.id] = cacheEntry
                }
            }
        else
            {
            try self.write(something.recordKind)
            }
        try something.write(file:self)
        }
        
    public func write<K,V>(_ collection:Dictionary<K,V>) throws where V:Record
        {
        try self.write(collection.count)
        for value in collection.values
            {
            try value.write(file: self)
            }
        }
        
    public func write<T>(_ collection:T) throws where T:Collection,T.Element:Record
        {
        try self.write(RecordKind.array)
        try self.write(collection.count)
        for element in collection
            {
            try self.write(element.recordKind)
            try element.write(file: self)
            }
        }
    
    public func write<T>(_ value: T) throws where T : RawRepresentable
        {
        var rawValue = value.rawValue
        let size = MemoryLayout<T>.size
        fwrite(&rawValue,size,1,self.file)
        }
    
    public func write<T>(object:T) throws where T:Record
        {
        if object.isObject
            {
            if self.cache[object.id] != nil
                {
                try self.write(RecordKind.reference)
                try self.write(object.id)
                return
                }
            else
                {
                let offset = self.currentFileOffset
                let entry = CacheEntry(record: object, offset: offset)
                self.cache[object.id] = entry
                }
            }
        try self.write(object.recordKind)
        try object.write(file:self)
        }
        

    
    init(path:String,mode:String) throws
        {
        self.path = path
        }
        
    public func close() throws
        {
        if fclose(file) != 0
            {
            throw(CompilerError(.fileErrorOnCloseFile(self.path,errno),.zero))
            }
        let offset = self.currentFileOffset
        try self.writeObjectTable()
        self.seek(.origin(0))
        try self.write(offset)
        }
        
    private func writeObjectTable() throws
        {
        try self.write(self.cache.count)
        for entry in self.cache.values
            {
            try entry.write(file:self)
            }
        }
        
    public func open() throws
        {
        self.file = fopen(self.path,"w+b")
        if self.file == nil
            {
            throw(CompilerError(.fileErrorOnOpenFile(self.path,errno),.zero))
            }
        }
        
    public func initializeForWriting() throws
        {
        try self.write(0)
        }
        
    public func initializeForReading() throws
        {
        self.seek(.origin(0))
        let offset = try self.readInt()
        self.seek(.origin(offset))
        let entryCount = try self.readInt()
        for _ in 0..<entryCount
            {
            let entry = try CacheEntry(file:self)
            self.cache[entry.uuid] = entry
            }
        }
        
    public func write(data: Data,length: Int) throws
        {
        var writtenLength = 0
        data.withUnsafeBytes
            {
            (pointer:UnsafePointer<UInt8>) in
            let rawPointer = UnsafeRawPointer(pointer)
            writtenLength = fwrite(rawPointer,1,length,self.file)
            }
        if writtenLength != length
            {
            let error = errno
            throw(CompilerError(.writeFailedWithLessBytesWritten(length,writtenLength,error),SourceLocation.zero))
            }
        }
    
    public func read(data: inout Data,length: Int) throws
        {
        var readLength = 0
        data.withUnsafeMutableBytes
            {
            (pointer:UnsafeMutablePointer<UInt8>) in
            let rawPointer = UnsafeMutableRawPointer(pointer)
            readLength = fread(rawPointer,1,length,self.file)
            }
        if readLength != length
            {
            let error = errno
            throw(CompilerError(.readFailedWithLessBytesWritten(length,readLength,error),SourceLocation.zero))
            }
        }
        
    public func readObject() throws -> AnyObject
        {
        let kind = RecordKind(rawValue:try self.readInt())!
        let maker = kind.kindMaker()
        return(try maker(self) as AnyObject)
        }
    }
