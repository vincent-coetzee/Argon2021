//
//  Cobalt.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/25.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation
//import ArgonFFI

public struct Argon
    {
    internal static let kWordSizeInBytes:Int = 8
    
    internal static let rootModule = Module.rootModule
    
    private static var nextIndexNumber = 0
    
    public static func nextName(_ prefix:String) -> String
        {
        return("\(prefix)_\(Argon.nextIndex())")
        }
        
    public static func nextIndex() -> Int
        {
        let index = self.nextIndexNumber
        self.nextIndexNumber += 1
        return(index)
        }
    
    public typealias Integer = Int64
    public typealias UInteger = UInt64
    public typealias Integer32 = Int32
    public typealias UInteger32 = UInt32
    public typealias Integer16 = Int16
    public typealias UInteger16 = UInt16
    public typealias Integer8 = Int8
    public typealias UInteger8 = UInt8
    public typealias Integer64 = Int64
    public typealias UInteger64 = UInt64
    public typealias Float = Float64
    public typealias Float64 = Swift.Double
    public typealias Float32 = Swift.Float
    public typealias Float16 = Swift.Float
    public typealias Character = UInt16
    public typealias Address = UInt64
    public typealias Symbol = Swift.String
    public typealias String = Swift.String
    public typealias Byte = UInt8
    
    public class Date:Equatable
        {
        public let day:Int
        public let monthIndex:Int
        public let year:Int
        
        public var month:String
            {
            switch(self.monthIndex)
                {
                case 1:
                    return("January")
                case 2:
                    return("February")
                case 3:
                    return("March")
                case 4:
                    return("April")
                case 5:
                    return("May")
                case 6:
                    return("June")
                case 7:
                    return("July")
                case 8:
                    return("August")
                case 9:
                    return("September")
                case 10:
                    return("October")
                case 11:
                    return("November")
                case 12:
                    return("December")
                default:
                    fatalError("Invalid month index")
                }
            }
            
        init(day:Int,monthIndex:Int,year:Int)
            {
            self.day = day
            self.monthIndex = monthIndex
            self.year = year
            }
            
        public static func ==(lhs:Date,rhs:Date) -> Bool
            {
            return(lhs.day == rhs.day && lhs.monthIndex == rhs.monthIndex && lhs.year == rhs.year)
            }
        }
        
    public class Time:Equatable
        {
        public static func ==(lhs:Time,rhs:Time) -> Bool
            {
            fatalError("This function \(#function) should not have been called")
            }
        }
        
    public class DateTime:Equatable
        {
        public static func ==(lhs:DateTime,rhs:DateTime) -> Bool
            {
            fatalError("This function \(#function) should not have been called")
            }
        }
    
    public enum Boolean:Argon.Integer8,Codable
        {
        case trueValue = 1
        case falseValue = 0
        }
        
    public class Tuple:Equatable
        {
        public static func ==(lhs:Tuple,rhs:Tuple) -> Bool
            {
            fatalError("This function \(#function) should not have been called")
            }
            
        internal var elements = Array<Expression>()
        
        internal var typeClass:Class
            {
            return(TupleClass(elements:elements.map{$0.typeClass}))
            }
            
        internal enum Element
            {
            case string(Argon.String?,Argon.String)
            case integer(Argon.String?,Argon.Integer)
            case float(Argon.String?,Argon.Float)
            case boolean(Argon.String?,Argon.Boolean)
            case character(Argon.String?,Argon.Character)
            }
        }

//    static func address(of:inout Any) -> Word
//        {
//        return(unsafeBitCast(of,to:Word.self))
//        }
//        
//    static func push(word:Word)
//        {
//        PushWord(CWord(word))
//        }
//        
//    static func call(address:Word)
//        {
//        CallAddress(address)
//        }
//        
//    static func junk(word:Word)
//        {
//        print(word)
//        }
//        
//    static func explode()
//        {
//        let value:CWord = 2001
//        self.push(word:value)
//        let function = VoidFunctionAddress()
//        self.call(address:function)
//        }
    }

extension Argon.Integer
    {
    public var displayString:String
        {
        return("\(self)")
        }
    }

extension Argon.Float
    {
        
    public var displayString:String
        {
        return("\(self)")
        }
    }
