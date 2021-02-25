//
//  Token.swift
//  Neon
//
//  Created by Vincent Coetzee on 30/11/2019.
//  Copyright © 2019 macsemantics. All rights reserved.
//

import Foundation

public enum Token:Equatable,CustomStringConvertible,CustomDebugStringConvertible
    {
    public enum Symbol:String,CaseIterable,Equatable
        {
        static func ==(lhs:Symbol,rhs:Token) -> Bool
            {
            return(rhs.isSymbol && rhs.symbol == lhs)
            }
            
        case none = ""
        case doubleBackSlash = "\\\\"
        case leftParenthesis = "("
        case rightParenthesis = ")"
        case leftBrace = "{"
        case rightBrace = "}"
        case leftBracket = "["
        case rightBracket = "]"
        case colon = ":"
        case gluon = "::"
        case stop = "."
        case comma = ","
        case dollar = "$"
        case hash = "#"
        case at = "@"
        case assign = "="
        case rightArrow = "->"
        case doubleQuote = "\""
        case singleQuote = "'"
        case leftBrocket = "<"
        case rightBrocket = ">"
        case halfRange = ".."
        case fullRange = "..."
        case rightBrocketEquals = ">="
        case leftBrocketEquals = "<="
        case not = "!"
        case and = "&&"
        case or = "||"
        case modulus = "%"
        case pow = "**"
        case bitNot = "~"
        case bitAnd = "&"
        case bitOr = "|"
        case bitXor = "^"
        case bitShiftRight = ">>"
        case bitShiftLeft = "<<"
        case mulEquals = "*="
        case divEquals = "/="
        case addEquals = "+="
        case subEquals = "-="
        case bitAndEquals = "&="
        case bitOrEquals = "|="
        case bitNotEquals = "~="
        case bitXorEquals = "^="
        case shiftLeftEquals = "<<="
        case shiftRightEquals = ">>="
        case mul = "*"
        case sub = "-"
        case div = "/"
        case add = "+"
        case equals = "=="
        case notEquals = "!="
        case other
        case cast = "to"
        case backslash = "\\"
        }

    public enum Keyword:String,CaseIterable,Equatable
        {
        case abstract
        case All
        case alias
        case Array
        case `as`
        case BitField
        case BitSet
        case Boolean
        case by
        case Byte
        case Character
        case `class`
        case constant
        case Date
        case DateTime
        case Dictionary
        case `else`
        case entry
        case enumeration
        case exit
        case export
        case Float
        case Float16
        case Float32
        case Float64
        case `for`
        case fork
        case from
        case function
        case handler
        case `if`
        case `import`
        case `in`
        case infix
        case inline
        case instanciate
        case Integer
        case Integer64
        case Integer32
        case Integer16
        case Integer8
        case `is`
        case `let`
        case List
        case local
        case macro
        case made
        case make
        case maker
        case meta
        case method
        case module
        case native
        case next
        case `nil`
        case Object
        case otherwise
        case `open`
        case `operator`
        case Pointer
        case postfix
        case prefix
        case `private`
        case protected
        case `public`
        case Range
        case read
        case readonly
        case readwrite
        case `repeat`
        case `return`
        case resume
        case run
        case sealed
        case select
        case Set
        case signal
        case slot
        case `static`
        case String
        case `super`
        case Symbol
        case system
        case this
        case This
        case Time
        case times
        case to
        case Tuple
        case type
        case UInteger
        case UInteger64
        case UInteger32
        case UInteger16
        case UInteger8
        case unmade
        case unsealed
        case using
        case value
        case virtual
        case Void
        case when
        case `while`
        case word
        case write
        }
        
    public enum TokenType
        {
        case none
        case comment
        case identifier
        case keyword
        case symbol
        case hashString
        case string
        case integer
        case byte
        case `true`
        case `false`
        case float
        case character
        case boolean
        case text
        case nativeType
        case tag
        case `operator`
        case marker
        case error
        case end
        }
        
    case none
    case comment(String,SourceLocation)
    case end(SourceLocation)
    case identifier(String,SourceLocation)
    case keyword(Keyword,SourceLocation)
    case symbol(Symbol,SourceLocation)
    case hashString(String,SourceLocation)
    case string(String,SourceLocation)
    case integer(Argon.Integer,SourceLocation)
    case byte(Argon.UInteger8,SourceLocation)
    case `true`(SourceLocation)
    case `false`(SourceLocation)
    case float(Double,SourceLocation)
    case character(Argon.Character,SourceLocation)
    case boolean(Bool,SourceLocation)
    case text(String,SourceLocation)
    case nativeType(Keyword,SourceLocation)
    case tag(String,SourceLocation)
    case `operator`(String,SourceLocation)
    case marker
    case error(CompilerError)
    
    public init(_ symbol:String,_ location:SourceLocation)
        {
        if let aSymbol = Symbol(rawValue: symbol)
            {
            self = .symbol(aSymbol,location)
            }
        else
            {
            self = .symbol(.other,location)
            }
        }
        
    func isTokenType(_ type:TokenType) -> Bool
        {
        switch(self)
            {
        case .none:
            return(type == .none)
        case .comment(_, _):
            return(type == .comment)
        case .end(_):
            return(type == .end)
        case .identifier(_, _):
            return(type == .identifier)
        case .keyword(_, _):
            return(type == .keyword)
        case .symbol(_, _):
            return(type == .symbol)
        case .hashString(_, _):
            return(type == .hashString)
        case .string(_, _):
            return(type == .string)
        case .integer(_, _):
            return(type == .integer)
        case .byte(_, _):
            return(type == .byte)
        case .true(_):
            return(type == .true)
        case .false(_):
            return(type == .false)
        case .float(_, _):
            return(type == .float)
        case .character(_, _):
            return(type == .character)
        case .boolean(_, _):
            return(type == .boolean)
        case .text(_, _):
            return(type == .text)
        case .nativeType(_, _):
            return(type == .nativeType)
        case .tag(_, _):
            return(type == .tag)
        case .operator(_, _):
            return(type == .operator)
        case .marker:
            return(type == .marker)
        case .error(_):
            return(type == .error)
            }
        }
        
    public var rawTokenType:Int
        {
        switch(self)
            {
        case .none:
            return(0)
        case .comment(_, _):
            return(1)
        case .end(_):
            return(2)
        case .identifier(_, _):
            return(3)
        case .keyword(_, _):
            return(4)
        case .symbol(_, _):
            return(5)
        case .hashString(_, _):
            return(6)
        case .string(_, _):
            return(7)
        case .integer(_, _):
            return(8)
        case .byte(_, _):
            return(9)
        case .true(_):
            return(10)
        case .false(_):
            return(11)
        case .float(_, _):
            return(12)
        case .character(_, _):
            return(13)
        case .boolean(_, _):
            return(14)
        case .text(_, _):
            return(15)
        case .nativeType(_, _):
            return(16)
        case .tag(_, _):
            return(17)
        case .operator(_, _):
            return(18)
        case .marker:
            return(19)
        case .error(_):
            return(20)
            }
        }
        
    public var customOperatorString:String
        {
        switch(self)
            {
            case .operator(let string,_):
                return(string)
            default:
                fatalError("")
            }
        }
        
    public var isSlotKeyword:Bool
        {
        return(self.isKeyword && (self.keyword == .class || self.keyword == .slot || self.keyword == .virtual))
        }
        
    public var debugDescription:String
        {
        return(self.description)
        }
        
    public var description:String
        {
        switch(self)
            {
            case .true:
                return("#true")
            case .false:
                return("#false")
            case .error(let error):
                return(".error(\(error))")
            case .hashString(let string,_):
                return(".symbolString(\(string))")
            case .comment(let string,_):
                return(".comment(\(string))")
            case .end:
                return(".end")
            case .identifier(let string,_):
                return(".identifier(\(string))")
            case .keyword(let keyword,_):
                return(".keyword(\(keyword))")
            case .string(let string,_):
                return(".string(\(string))")
            case .integer(let value,_):
                return(".integer(\(value))")
            case .float(let value,_):
                return(".float(\(value))")
            case .text(let string,_):
                return(".text(\(string))")
            case .symbol(let value,_):
                return(".symbol(\(value.rawValue))")
            case .nativeType(let string,_):
                return(".nativeType(\(string))")
            case .tag(let string,_):
                return(".tag(\(string))")
            case .none:
                return(".none")
            case .operator(let string,_):
                return(".operator(\(string))")
            case .character(let char, _):
                return(".character(\(char))")
            case .boolean(let boolean, _):
                return(".boolean(\(boolean))")
            case .marker:
                return(".marker")
            case .byte(let value,_):
                return(".byte(\(value))")
            }
        }
        
    public var tokenIndex:Int
        {
        switch(self)
            {
            case .text:
                return(0)
            case .comment:
                return(2)
            case .end:
                return(3)
            case .identifier:
                return(4)
            case .keyword:
                return(5)
            case .symbol:
                return(6)
            case .string:
                return(7)
            case .integer:
                return(8)
            case .float:
                return(9)
            case .hashString:
                return(10)
            case .nativeType:
                return(12)
            case .byte:
                return(13)
            case .true:
                return(14)
            case .tag:
                return(15)
            case .false:
                return(18)
            case .none:
                return(20)
            case .operator:
                return(23)
            case .character(_, _):
                return(24)
            case .boolean(_, _):
                return(25)
            case .marker:
                return(26)
            case .error:
                return(-1)
            }
        }
        
    public var tokenType:Token.TokenType
        {
        switch(self)
            {
            case .text:
                return(.text)
            case .comment:
                return(.comment)
            case .end:
                return(.end)
            case .identifier:
                return(.identifier)
            case .keyword:
                return(.keyword)
            case .symbol:
                return(.symbol)
            case .string:
                return(.string)
            case .integer:
                return(.integer)
            case .float:
                return(.float)
            case .hashString:
                return(.hashString)
            case .nativeType:
                return(.nativeType)
            case .byte:
                return(.byte)
            case .true:
                return(.true)
            case .tag:
                return(.tag)
            case .false:
                return(.false)
            case .none:
                return(.none)
            case .operator:
                return(.operator)
            case .character(_, _):
                return(.character)
            case .boolean(_, _):
                return(.boolean)
            case .marker:
                return(.marker)
            case .error:
                return(.error)
            }
        }
        
    public var isBooleanOperator:Bool
        {
        return( self.isAnd || self.isOr )
        }
        
    public var byteValue:Argon.Byte
        {
        switch(self)
            {
            case .byte(let value,_):
                return(value)
            default:
                fatalError("Invalid call on Byte")
            }
        }
        
    public var characterValue:Argon.Character
        {
        switch(self)
            {
            case .character(let value,_):
                return(value)
            default:
                fatalError("Invalid call on Character")
            }
        }
        
    public var stringValue:Argon.String
        {
        switch(self)
            {
            case .string(let value,_):
                return(value)
            default:
                fatalError("Invalid call on String")
            }
        }
        
    public var booleanValue:Argon.Boolean
        {
        switch(self)
            {
            case .true:
                return(.trueValue)
            case .false:
                return(.falseValue)
            default:
                fatalError("Invalid call on Boolean")
            }
        }
        
    public var hashStringValue:Argon.Symbol
        {
        switch(self)
            {
            case .hashString(let value,_):
                return(value)
            default:
                fatalError("Invalid call on HashString")
            }
        }
        
    public var hashString:String
        {
        switch(self)
            {
            case .hashString(let string,_):
                return(string)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var symbolTypeString:String
        {
        switch(self)
            {
            case .symbol(let type,_):
                return(type.rawValue)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var location:SourceLocation
        {
        switch(self)
            {
            case .true(let location):
                return(location)
            case .false( let location):
                return(location)
            case .byte(_,let location):
                return(location)
            case .error(_):
                return(.zero)
            case .hashString(_,let location):
                return(location)
            case .comment(_,let location):
                return(location)
            case .end(let location):
                return(location)
            case .identifier(_,let location):
                return(location)
            case .keyword(_,let location):
                return(location)
            case .character(_,let location):
                return(location)
            case .boolean(_,let location):
                return(location)
            case .string(_,let location):
                return(location)
            case .integer(_,let location):
                return(location)
            case .float(_,let location):
                return(location)
            case .text(_,let location):
                return(location)
            case .symbol(_,let location):
                return(location)
            case .nativeType(_,let location):
                return(location)
            case .tag(_,let location):
                return(location)
            case .none:
                return(.zero)
            case .operator(_, let location):
                return(location)
            case .marker:
                return(SourceLocation(line: 0, lineStart: 0, lineStop: 0, tokenStart: 0, tokenStop: 0))
            }
        }
        
    public var integerValue:Argon.Integer
        {
        switch(self)
            {
            case .integer(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var floatingPointValue:Double
        {
        switch(self)
            {
            case .float(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var operatorName:String
        {
        switch(self)
            {
            case .operator(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
    
    public var identifier:String
        {
        switch(self)
            {
            case .identifier(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }

    public var tag:String
        {
        switch(self)
            {
            case .tag(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
    
    public var keyword:Keyword
        {
        switch(self)
            {
            case .nativeType(let name,_):
                return(name)
            case .keyword(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var keywordString:String
        {
        switch(self)
            {
            case .keyword(let name,_):
                return("\(name)")
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
    
    public var symbol:Symbol
        {
        switch(self)
            {
            case .symbol(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var string:String
        {
        switch(self)
            {
            case .string(let name,_):
                return(name)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
        
    public var integer:Argon.Integer
        {
        switch(self)
            {
            case .integer(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }
    
    public var floatingPoint:Double
        {
        switch(self)
            {
            case .float(let value,_):
                return(value)
            default:
                fatalError("This should not be called on a Token of class \(Swift.type(of: self))")
            }
        }

    public var isNativeType:Bool
        {
        switch(self)
            {
            case .nativeType:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isArray:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .Array)
            default:
                return(false)
            }
        }
        
    public var isMarker:Bool
        {
        switch(self)
            {
            case .marker:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isBitField:Bool
        {
        switch(self)
            {
            case .keyword(let type,_):
                return(type == .BitField)
            default:
                return(false)
            }
        }
        
    public var isType:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .type)
            default:
                return(false)
            }
        }
        
    public var isCastOperator:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .to)
            default:
                return(false)
            }
        }
        
    public var isFork:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .fork)
            default:
                return(false)
            }
        }
        
    public var isFrom:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .from)
            default:
                return(false)
            }
        }
        
    public var isTo:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .to)
            default:
                return(false)
            }
        }
        
    public var isBy:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .by)
            default:
                return(false)
            }
        }
        
    public var isRepeat:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .repeat)
            default:
                return(false)
            }
        }
        
    public var isNameComponent:Bool
        {
        return(self.isIdentifier || self.isNativeType)
        }
        
    public var isSet:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .Set)
            default:
                return(false)
            }
        }
        
    public var isDictionary:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .Dictionary)
            default:
                return(false)
            }
        }
        
    public var isDate:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .Date)
            default:
                return(false)
            }
        }
        
    public var isList:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .List)
            default:
                return(false)
            }
        }
        
    public var isNext:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .next)
            default:
                return(false)
            }
        }
        
    public var isResume:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .resume)
            default:
                return(false)
            }
        }
        
    public var isBitSet:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                return(value == .BitSet)
            default:
                return(false)
            }
        }
        
    public var isIs:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .is)
            default:
                return(false)
            }
        }
        
    public var isNil:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .nil)
            default:
                return(false)
            }
        }
        
    public var isStop:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .stop)
            default:
                return(false)
            }
        }
        
    public var isRightArrow:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightArrow)
            default:
                return(false)
            }
        }
        
    public var isColon:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .colon)
            default:
                return(false)
            }
        }
        
//    public var isType:Bool
//        {
//        switch(self)
//            {
//            case .nativeType(let kind,_):
//                switch(kind)
//                    {
//                    case .Integer64:
//                        fallthrough
//                    case .UInteger64:
//                        fallthrough
//                    case .Integer:
//                        fallthrough
//                    case .UInteger:
//                        fallthrough
//                    case .Integer32:
//                        fallthrough
//                    case .UInteger32:
//                        fallthrough
//                    case .Integer16:
//                        fallthrough
//                    case .UInteger16:
//                        fallthrough
//                    case .Integer8:
//                        fallthrough
//                    case .UInteger8:
//                        fallthrough
//                    case .String:
//                        fallthrough
//                    case .Array:
//                        fallthrough
//                    case .Date:
//                        fallthrough
//                    case .List:
//                        fallthrough
//                    case .Set:
//                        fallthrough
//                    case .BitSet:
//                        fallthrough
//                    case .Dictionary:
//                        fallthrough
//                    case .Boolean:
//                        fallthrough
//                    case .Character:
//                        fallthrough
//                    case .Float:
//                        fallthrough
//                    case .Float16:
//                        return(true)
//                    case .Float32:
//                        fallthrough
//                    case .Float64:
//                        return(true)
//                    default:
//                        break
//                    }
//        default:
//            return(false)
//            }
//        return(false)
//        }
        
    public var isIntegerNumber:Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isFloatingPointNumber:Bool
        {
        switch(self)
            {
            case .float:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isOperator:Bool
        {
        switch(self)
            {
            case .operator:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isByte:Bool
        {
        switch(self)
            {
            case .byte:
                return(true)
            default:
                return(false)
            }
        }

        
    public var isReturn:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .return)
            default:
                return(false)
            }
        }
        
    public var isInteger:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Integer)
            default:
                return(false)
            }
        }
        
    public var isFunction:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .function)
            default:
                return(false)
            }
        }
        
    public var isNative:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .native)
            default:
                return(false)
            }
        }
        
    public var isExport:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .export)
            default:
                return(false)
            }
        }
        
    public var isEntry:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .entry)
            default:
                return(false)
            }
        }
        
    public var isExit:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .exit)
            default:
                return(false)
            }
        }
        
    public var isFalse:Bool
        {
        switch(self)
            {
            case .false:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isBackSlash:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .backslash)
            default:
                return(false)
            }
        }
        
    public var isForwardSlash:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .div)
            default:
                return(false)
            }
        }
        
    public var isValue:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .value)
            default:
                return(false)
            }
        }
        
    public var isSystem:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .system)
            default:
                return(false)
            }
        }
        
    public var isInline:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .inline)
            default:
                return(false)
            }
        }
        
    public var isDirective:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .function || value == .inline || value == .system || value == .native)
            default:
                return(false)
            }
        }

    public var isRead:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .read)
            default:
                return(false)
            }
        }
        
    public var isRun:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .run)
            default:
                return(false)
            }
        }
        
    public var isTimes:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .times)
            default:
                return(false)
            }
        }
        
    public var isTrue:Bool
        {
        switch(self)
            {
            case .true:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isMade:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .made)
            default:
                return(false)
            }
        }
        
    public var isWrite:Bool
         {
         switch(self)
             {
             case .keyword(let value,_):
                 return(value == .write)
             default:
                 return(false)
             }
         }
        
    public var isVirtual:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .virtual)
            default:
                return(false)
            }
        }
        
    public var isAlias:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .alias)
            default:
                return(false)
            }
        }
        
    public var isTuple:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Tuple)
            default:
                return(false)
            }
        }
        
    public var isSlot:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .slot)
            default:
                return(false)
            }
        }
        
    public var isCharacter:Bool
        {
        switch(self)
            {
            case .character:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isClass:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .class)
            default:
                return(false)
            }
        }
    
    public var isFor:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .for)
            default:
                return(false)
            }
        }
        
    public var isIf:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .if)
            default:
                return(false)
            }
        }
        
    public var isUsing:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .using)
            default:
                return(false)
            }
        }
    
    public var isWhen:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .when)
            default:
                return(false)
            }
        }
        
    public var isLowerThis:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .this)
            default:
                return(false)
            }
        }
        
    public var isIn:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .in)
            default:
                return(false)
            }
        }
    
    public var isMeta:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .meta)
            default:
                return(false)
            }
        }
        
    public var isOtherwise:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .otherwise)
            default:
                return(false)
            }
        }
        
    public var isSelect:Bool
        {
         switch(self)
            {
            case .keyword(let value,_):
                return(value == .select)
            default:
                return(false)
            }
        }
        
    public var isSignal:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .signal)
            default:
                return(false)
            }
        }
        
    public var isHandler:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .handler)
            default:
                return(false)
            }
        }
        
    public var isLocal:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .local)
            default:
                return(false)
            }
        }
        
    public var isWhile:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .while)
            default:
                return(false)
            }
        }
        
    public var isAccessModifier:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .export || value == .private || value == .open || value == .public)
            default:
                return(false)
            }
        }

    public var isHashString:Bool
        {
        switch(self)
            {
            case .hashString:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isString:Bool
        {
        switch(self)
            {
            case .string:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isMethod:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .method)
            default:
                return(false)
            }
        }

    public var isThis:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .this)
            default:
                return(false)
            }
        }
        
    public var isSuper:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .super)
            default:
                return(false)
            }
        }
        
    public var isTHIS:Bool
        {
        switch(self)
            {
            case .keyword(let keyword,_):
                return(keyword == .This)
            default:
                return(false)
            }
        }
        
    public var isElse:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .else)
            default:
                return(false)
            }
        }
    
    public var isNot:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .not)
            default:
                return(false)
            }
        }
        
    public var isNumber:Bool
        {
        switch(self)
            {
            case .integer:
                return(true)
            case .float:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isComma:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .comma)
            default:
                return(false)
            }
        }
    
    public var isBitAnd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitAnd)
            default:
                return(false)
            }
        }

    public var isBitOr:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitOr)
            default:
                return(false)
            }
        }
        
    public var isBitXor:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitXor)
            default:
                return(false)
            }
        }
        
    public var isHollowVariableIdentifier:Bool
        {
        switch(self)
            {
            case .identifier(let value,_):
                return(value == "?")
            default:
                return(false)
            }
        }
        
    public var isBitNot:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitNot)
            default:
                return(false)
            }
        }
        
    public var isLeftBracket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBracket)
            default:
                return(false)
            }
        }
    
    public var isRightBracket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBracket)
            default:
                return(false)
            }
        }
    
    public var isLeftBrace:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrace)
            default:
                return(false)
            }
        }
    
    public var isRightBrace:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrace)
            default:
                return(false)
            }
        }
    
    public var isTag:Bool
        {
        switch(self)
            {
            case .tag:
                return(true)
            default:
                return(false)
            }
        }
        
        
    public var isTypeKeyword:Bool
        {
        switch(self)
            {
            case .nativeType(let value,_):
                switch(value)
                    {
                    case .Date:
                        return(true)
                    case .Time:
                        return(true)
                    case .DateTime:
                        return(true)
                    case .Tuple:
                        return(true)
                    case .this:
                        return(true)
                    case .Integer:
                        return(true)
                    case .Integer64:
                        return(true)
                    case .Integer32:
                        return(true)
                    case .Integer16:
                        return(true)
                    case .Integer8:
                        return(true)
                    case .UInteger:
                        return(true)
                    case .UInteger64:
                        return(true)
                    case .UInteger32:
                        return(true)
                    case .UInteger16:
                        return(true)
                    case .UInteger8:
                        return(true)
                    case .Boolean:
                        return(true)
                    case .String:
                        return(true)
                    case .Character:
                        return(true)
                    case .Float:
                        return(true)
                    case .Float16:
                        return(true)
                    case .Float32:
                        return(true)
                    case .Float64:
                        return(true)
                    case .Array:
                        return(true)
                    case .Symbol:
                        return(true)
                    case .List:
                        return(true)
                    case .Set:
                        return(true)
                    case .BitSet:
                        return(true)
                    case .Dictionary:
                        return(true)
                    case .Pointer:
                        return(true)
                    default:
                        break
                    }
            default:
                return(false)
            }
        return(false)
        }
        
    public var isLeftBrocket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrocket)
            default:
                return(false)
            }
        }
    
    public var isRightBrocket:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrocket)
            default:
                return(false)
            }
        }
        
    public var isLogicalOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .and || value == .or)
            default:
                return(false)
            }
        }

    public var isBitOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitAnd || value == .bitOr || value == .bitXor)
            default:
                return(false)
            }
        }
        
    public var isPowerOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .pow)
            default:
                return(false)
            }
        }
        
    public var isAdditionOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .add || value == .sub)
            default:
                return(false)
            }
        }

    public var isMultiplicationOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .mul || value == .div || value == .modulus)
            default:
                return(false)
            }
        }
        
    public var isRelationalOperator:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrocket || value == .rightBrocketEquals || value == .leftBrocket || value == .leftBrocketEquals || value == .equals || value == .notEquals)
            default:
                return(false)
            }
        }
        
    public var isLeftBrocketEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftBrocketEquals)
            default:
                return(false)
            }
        }
    
    public var isRightBrocketEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightBrocketEquals)
            default:
                return(false)
            }
        }
    
    public var isRightBitShift:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitShiftRight)
            default:
                return(false)
            }
        }
        
    public var isLeftBitShift:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitShiftLeft)
            default:
                return(false)
            }
        }
        
    public var isDollar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .dollar)
            default:
                return(false)
            }
        }
        
    public var isFullRange:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .fullRange)
            default:
                return(false)
            }
        }
        
    public var isLeftPar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .leftParenthesis)
            default:
                return(false)
            }
        }
    
    public var isRightPar:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .rightParenthesis)
            default:
                return(false)
            }
        }
    
    public var isHash:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .hash)
            default:
                return(false)
            }
        }
        
    public var isAt:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .at)
            default:
                return(false)
            }
        }
        
        
    public var isEnd:Bool
        {
        switch(self)
            {
            case .end:
                return(true)
            default:
                return(false)
            }
        }

    public var isHalfRange:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .halfRange)
            default:
                return(false)
            }
        }
    
    public var isMulEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .mulEquals)
            default:
                return(false)
            }
        }
    
    public var isSubEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .subEquals)
            default:
                return(false)
            }
        }
    
    public var isDivEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .divEquals)
            default:
                return(false)
            }
        }
    
    public var isAddEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .addEquals)
            default:
                return(false)
            }
        }
        
    public var isBitAndEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitAndEquals)
            default:
                return(false)
            }
        }
    
    public var isBitNotEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitNotEquals)
            default:
                return(false)
            }
        }
    
    public var isPointer:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .Pointer)
            default:
                return(false)
            }
        }
        
    public var isPower:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .pow)
            default:
                return(false)
            }
        }
        
    public var isBitOrEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitOrEquals)
            default:
                return(false)
            }
        }
        
    public var isMul:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .mul)
            default:
                return(false)
            }
        }
    
    public var isSub:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .sub)
            default:
                return(false)
            }
        }
    
    public var isDiv:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .div)
            default:
                return(false)
            }
        }
    
    public var isAdd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .add)
            default:
                return(false)
            }
        }
    
    public var isModulus:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .modulus)
            default:
                return(false)
            }
        }
        
    public var isAnd:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .and)
            default:
                return(false)
            }
        }
        
    public var isOr:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .or)
            default:
                return(false)
            }
        }
        
    public var isModule:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .module)
            default:
                return(false)
            }
        }
        
    public var isPrefix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .prefix)
            default:
                return(false)
            }
        }
    
    public var isPostfix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .postfix)
            default:
                return(false)
            }
        }
    
    public var isInfix:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .infix)
            default:
                return(false)
            }
        }
    
    public var isEnumeration:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .enumeration)
            default:
                return(false)
            }
        }
        
    public var isLet:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .let)
            default:
                return(false)
            }
        }
    
    public var isReadOnly:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .readonly)
            default:
                return(false)
            }
        }
        
    public var isMaker:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .maker)
            default:
                return(false)
            }
        }
        
    public var isReadWrite:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .readwrite)
            default:
                return(false)
            }
        }
        
    public var isImport:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .import)
            default:
                return(false)
            }
        }
    
    public var isOpen:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .open)
            default:
                return(false)
            }
        }
        
    public var isPublic:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .public)
            default:
                return(false)
            }
        }
        
    public var isPrivate:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .private)
            default:
                return(false)
            }
        }
        
    public var isProtected:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .protected)
            default:
                return(false)
            }
        }
        
    public var isAs:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .as)
            default:
                return(false)
            }
        }
        
    public var isConstant:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .constant)
            default:
                return(false)
            }
        }
        
    public var isAssign:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .assign)
            default:
                return(false)
            }
        }
        
    public var isEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .equals)
            default:
                return(false)
            }
        }
        
    public var isNotEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .notEquals)
            default:
                return(false)
            }
        }
    
    public var isBitShiftRight:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitShiftRight)
            default:
                return(false)
            }
        }
        
    public var isBitShiftLeft:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .bitShiftLeft)
            default:
                return(false)
            }
        }
        
    public var isBitShiftRightEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .shiftRightEquals)
            default:
                return(false)
            }
        }
        
    public var isBitShiftLeftEquals:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .shiftLeftEquals)
            default:
                return(false)
            }
        }
        
    public  var isComment:Bool
        {
        switch(self)
            {
            case .comment:
                return(true)
            default:
                return(false)
            }
        }

    public var isKeyword:Bool
        {
        switch(self)
            {
            case .keyword:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isIdentifier:Bool
        {
        switch(self)
            {
            case .identifier:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isSymbol:Bool
        {
        switch(self)
            {
            case .symbol:
                return(true)
            default:
                return(false)
            }
        }
    
    public var isGluon:Bool
        {
        switch(self)
            {
            case .symbol(let value,_):
                return(value == .gluon)
            default:
                return(false)
            }
        }
        
    public var isModuleLevelKeyword:Bool
        {
        switch(self)
            {
            case .keyword(let value,_):
                return(value == .module || value == .let || value == .method || value == .type || value == .class || value == .enumeration || value == .slot)
            default:
                return(false)
            }
        }
    }
