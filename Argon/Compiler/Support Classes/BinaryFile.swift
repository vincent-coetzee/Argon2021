//
//  BinaryFile.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/25.
//

import Foundation

public protocol BinaryFile
    {
    func close() throws
    func open() throws
    func seek(_ offset:FileOffset)
    func tell() -> Int
    func initializeForReading() throws
    func read(data:inout Data,length:Int) throws
    func readInt() throws -> Int
    func readString() throws -> String
    func readArray<T>(of type:T.Type) throws -> Array<T> where T:Record
    func initializeForWriting() throws
    func write(character:Character) throws
    func write(_ name:Name?) throws
    func write(_ string:String?) throws
    func write(_ string:UUID) throws
    func write(_ boolean:Bool) throws
    func write(_ double:Double) throws
    func write(_ integer:Int) throws
    func write<T>(_ value:T) throws where T:RawRepresentable
    func write(_ unit:UInt8) throws
    func write(_ versionKey:SemanticVersionNumber) throws
    func write<T>(_ collection:T) throws where T:Collection,T.Element:Record
    func write<K,V>(_ collection:Dictionary<K,V>) throws where V:Record
    func write<S>(_ something:S) throws where S:Record
    func write(data:Data,length:Int) throws
    }

public enum FileOffset
    {
    case origin(Int)
    case current(Int)
    case end(Int)
    }
