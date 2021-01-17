//
//  TokenStream.swift
//  Neon
//
//  Created by Vincent Coetzee on 30/11/2019.
//  Copyright © 2019 macsemantics. All rights reserved.
//

import Foundation


public class TokenStream:Equatable
    {
    public static func == (lhs: TokenStream, rhs: TokenStream) -> Bool
        {
        return(lhs.source == rhs.source)
        }
    
    private struct StreamPosition
        {
        public let current:Unicode.Scalar
        public let line:Int
        public let offset:Int
        public let index:String.Index
        public let length:Int
        public let start:Int
        
        public init(current:Unicode.Scalar,line:Int,offset:Int,index:String.Index,length:Int,start:Int)
            {
            self.current = current
            self.line = line
            self.offset = offset
            self.index = index
            self.length = length
            self.start = start
            }
        }
        
    private var source:String = ""
    private var line:Int = 0
    private var lineAtTokenStart = 0
    private var currentChar:Unicode.Scalar = " "
    private var offset:String.Index = "".startIndex
    private var currentString:String  = ""
    private var keywords:[String] = []
    private var nativeTypes:[String] = []
    private var startIndex:Int = 0
    private let alphanumerics = NSCharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
    private let symbolString = NSCharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
    private let letters = NSCharacterSet.letters.union(CharacterSet(charactersIn: "_"))
    private let digits = NSCharacterSet.decimalDigits
    private let whitespace = NSCharacterSet.whitespaces
    private let newline = NSCharacterSet.newlines
    private let symbols = CharacterSet(charactersIn: "=<>-+*/%!&|^\\/~:.,$()[]:.{},@")
    private let hexDigits = CharacterSet(charactersIn: "ABCDEF0123456789_")
    private let binaryDigits = CharacterSet(charactersIn: "01_")
    private let operatorSymbols = CharacterSet(charactersIn: "=<-+*/%!&|^\\~@$")
    private var tokenStart:Int = 0
    private var tokenStop:Int = 0
    private var lineStart:Int = 0
    private var lineStop:Int = 0
    private var characterOffset = 0
    public var parseComments:Bool = false
    private var tokenStack:[Token] = []
    private var lineLength:Int = 0
    private var tokenLine:Int = 0
    private var positionStack = Stack<StreamPosition>()
    
    public var lineNumber:Int
        {
        get
            {
            return(self.line)
            }
        set
            {
            self.line = newValue
            }
        }
        
    private var atEnd:Bool
        {
        return(offset == source.endIndex)
        }
    
    private var atEndOfLine:Bool
        {
        return(newline.contains(self.currentChar))
        }
    
    init()
        {
        source = ""
        self.initState()
        self.initKeywords()
        }
    
    init(source:String)
        {
        self.source = source
        self.initState()
        self.initKeywords()
        }
    
    public func reset(source string:String)
        {
        source = string
        self.initState()
        self.initKeywords()
        }

    public func copy() -> TokenStream
        {
        let newStream = TokenStream(source: self.source)
        newStream.tokenStart = self.tokenStart
        newStream.tokenStop = self.tokenStop
        newStream.lineStart = self.lineStart
        newStream.lineStop = self.lineStop
        newStream.characterOffset = self.characterOffset
        newStream.parseComments = self.parseComments
        newStream.tokenStack = self.tokenStack
        newStream.lineLength = self.lineLength
        newStream.source = self.source
        newStream.line = self.line
        newStream.currentChar = self.currentChar
        newStream.offset = self.offset
        newStream.currentString = self.currentString
        newStream.startIndex = self.startIndex
        return(newStream)
        }
    
    public func tokens(withComments:Bool) -> [Token]
        {
        self.parseComments = withComments
        var tokens:[Token] = []
        var token:Token
        repeat
            {
            token = self.nextToken()
            tokens.append(token)
            }
        while !token.isEnd
        return(tokens)
        }
        
    private func initState()
        {
        tokenStart = 0
        tokenStop = 0
        lineStart = 0
        lineLength = 0
        startIndex = 0
        characterOffset = 0
        line = 1
        self.currentChar = Unicode.Scalar(" ")
        offset = source.startIndex
        }
    
    @discardableResult
    @inline(__always)
    private func nextChar() -> Unicode.Scalar
        {
        guard !self.atEnd else
            {
            self.currentChar = Unicode.Scalar(0)
            return(" ")
            }
        self.currentChar = source.unicodeScalars[offset]
        if self.currentChar == "\n"
            {
            self.line += 1
            lineStart = self.characterOffset
            lineLength = 0
            }
        offset = source.index(after:offset)
        characterOffset += 1
        lineLength += 1
        return(self.currentChar)
        }
    
    @inline(__always)
    public func pushPosition()
        {
        let position = StreamPosition(current: self.currentChar, line: self.line, offset: self.characterOffset, index: self.offset, length: self.lineLength, start: self.lineStart)
        self.positionStack.push(position)
        }
        
    @inline(__always)
    public func popPosition()
        {
        let position = self.positionStack.pop()
        self.currentChar = position.current
        self.line = position.line
        self.characterOffset = position.offset
        self.offset = position.index
        self.lineLength = position.length
        self.lineStart = position.start
        }
        
    @discardableResult
    @inline(__always)
    private func peekChar(at count:Int) -> Unicode.Scalar
        {
        var index = offset
        for _ in 0..<count
            {
            index = source.index(after: index)
            }
        return(source.unicodeScalars[index])
        }
        
    public func rewindChar()
        {
        offset = source.index(before: offset)
        if source.unicodeScalars[offset] == "\n"
            {
            self.line -= 1
            }
        offset = source.index(before: offset)
        if source.unicodeScalars[offset] == "\n"
            {
            self.line -= 1
            }
        self.currentChar = source.unicodeScalars[offset]
        if source.unicodeScalars[offset] == "\n"
            {
            self.line += 1
            }
        characterOffset -= 2
        }
    
    private func eatSpace()
        {
        while (whitespace.contains(self.currentChar) || newline.contains(self.currentChar)) && !atEnd
            {
            if whitespace.contains(self.currentChar)
                {
                self.eatWhitespace()
                }
            if newline.contains(self.currentChar)
                {
                self.eatNewline()
                }
            }
        }
    
    @inline(__always)
    private func scanToEndOfLine()
        {
        while !newline.contains(self.currentChar) && !atEnd
            {
            self.nextChar()
            }
        }
    
    @inline(__always)
    private func scanToEndOfComment()
        {
        while self.currentChar != "*" && !atEnd
            {
            self.nextChar()
            }
        self.nextChar()
        if self.currentChar == "/"
            {
            self.nextChar()
            return
            }
        else
            {
            self.scanToEndOfComment()
            }
        }
    
    public func pushBack(_ token:Token)
        {
        tokenStack.append(token)
        }
    
    @discardableResult
    public func scanTextUntilRightBrace() -> String
        {
        let scalar:UnicodeScalar = "}"
        var text:String = ""
        while self.currentChar != scalar && !self.atEnd
            {
            text.append(String(self.currentChar))
            self.nextChar()
            }
        if !atEnd
            {
            self.nextChar()
            }
        return(text)
        }
        
    @discardableResult
    public func scanTextUntilCommaOrLeftParenthesis() -> String
        {
        let scalar1:UnicodeScalar = ","
        let scalar2:UnicodeScalar = ")"
        var text:String = ""
        while self.currentChar != scalar1 && self.currentChar != scalar2 && !self.atEnd
            {
            text.append(String(self.currentChar))
            self.nextChar()
            }
        if !atEnd
            {
            self.nextChar()
            }
        return(text)
        }
        
    public func nextToken() -> Token
        {
        self.tokenLine = line
        if !tokenStack.isEmpty
            {
            return(tokenStack.removeFirst())
            }
        tokenStart = characterOffset
        eatSpace()
        if self.currentChar == "/" && !atEnd
            {
            nextChar()
            if self.currentChar == "/" && !atEnd
                {
                self.startIndex = source.distance(from: source.startIndex, to: offset)
                scanToEndOfLine()
                if self.parseComments
                    {
                    let endIndex = source.distance(from: source.startIndex, to: offset)
                    return(Token.comment(source.substring(with: startIndex..<endIndex),self.sourceLocation()))
                    }
                return(self.nextToken())
                }
            else if self.currentChar == "*" && !atEnd
                {
                startIndex = source.distance(from: source.startIndex, to: offset)
                scanToEndOfComment()
                if parseComments
                    {
                    let endIndex = source.distance(from: source.startIndex, to: offset)
                    return(Token.comment(source.substring(with: startIndex..<endIndex),self.sourceLocation()))
                    }
                return(self.nextToken())
                }
            else
                {
                 if self.currentChar == "="
                    {
                    nextChar()
                    return(Token("/=",self.sourceLocation()))
                    }
                return(Token("/",self.sourceLocation()))
                }
            }
        currentString = ""
        startIndex = characterOffset
        if letters.contains(self.currentChar) || self.currentChar == "$" || self.currentChar == "?"
            {
            return(self.nextIdentifier())
            }
        else if digits.contains(self.currentChar)
            {
            return(self.nextNumber())
            }
        else if self.currentChar == "\""
            {
            return(self.nextString())
            }
        else if symbols.contains(self.currentChar)
            {
            return(self.nextSymbol())
            }
        else if atEnd
            {
            return(Token.end(self.sourceLocation()))
            }
        else if self.currentChar == "#"
            {
            var string:String = ""
            while !whitespace.contains(self.currentChar) && !symbols.contains(self.currentChar) && !self.newline.contains(self.currentChar)
                {
                string += String(self.currentChar)
                nextChar()
                }
            if string == "#true"
                {
                return(.true(self.sourceLocation()))
                }
            else if string == "#false"
                {
                return(.false(self.sourceLocation()))
                }
            else
                {
                return(.hashString(string,self.sourceLocation()))
                }
            }
        return(.error(CompilerError(.invalidCharacter(Character(self.currentChar)),self.sourceLocation())))
        }
    
    private func nextString() -> Token
        {
        var string = ""
        nextChar()
        while self.currentChar != "\"" && !atEnd
            {
            string += String(self.currentChar)
            nextChar()
            }
        nextChar()
        return(Token.string(string,self.sourceLocation()))
        }
    
    @inline(__always)
    private func eatNewline()
        {
        while newline.contains(self.currentChar) && !atEnd
            {
            self.nextChar()
            }
        }
    
    @inline(__always)
    private func eatWhitespace()
        {
        while whitespace.contains(self.currentChar) && !self.atEnd
            {
            self.nextChar()
            }
        }
    
    public func markPosition() -> String.Index
        {
        return(self.offset)
        }
        
    public func setPosition(_ position:String.Index)
        {
        self.offset = position
        self.nextChar()
        }
    
    public func nextPositiveInteger() throws -> Token
        {
        var number:Argon.Integer = 0
        while digits.contains(self.currentChar) && !atEnd
            {
            if digits.contains(self.currentChar)
                {
                number *= 10
                number += Argon.Integer(String(self.currentChar))!
                self.nextChar()
                }
            }
        return(.integer(number,self.sourceLocation()))
        }
    
    private func nextNumber() -> Token
        {
        var number:Int = 0
        if self.currentChar == "0"
            {
            self.nextChar()
            if self.currentChar == "x"
                {
                return(self.nextHexNumber())
                }
            else if self.currentChar == "b"
                {
                return(self.nextBinaryNumber())
                }
            else
                {
                self.rewindChar()
                }
            }
        while (digits.contains(self.currentChar) || self.currentChar == "_") && !atEnd
            {
            if self.currentChar == "_"
                {
                self.nextChar()
                }
            if digits.contains(self.currentChar)
                {
                number *= 10
                number += Int(String(self.currentChar))!
                self.nextChar()
                }
            }
        if self.currentChar == "."
            {
            self.nextChar()
            var isFloat = false
            var factor = Double(0.0)
            var divisor = 10
            while (digits.contains(self.currentChar) || self.currentChar == "_") && !atEnd
                {
                isFloat = true
                if self.currentChar == "_"
                    {
                    self.nextChar()
                    }
                if digits.contains(self.currentChar)
                    {
                    factor += Double(String(self.currentChar))! / Double(divisor)
                    divisor *= 10
                    self.nextChar()
                    }
                }
            if isFloat
                {
                return(.float(Double(Double(number)+factor),self.sourceLocation()))
                }
            }
        return(.integer(Argon.Integer(number),self.sourceLocation()))
        }
    
    private func nextHexNumber() -> Token
        {
        nextChar()
        var hexValue = 0
        while hexDigits.contains(self.currentChar)
            {
            hexValue *= 16
            let uppercased = String(self.currentChar).uppercased()
            switch(uppercased)
                {
                case "A":
                    hexValue += 10
                case "B":
                    hexValue += 11
                case "C":
                    hexValue += 12
                case "D":
                    hexValue += 13
                case "E":
                    hexValue += 14
                case "F":
                    hexValue += 15
                default:
                    hexValue += Int(String(self.currentChar))!
                }
            nextChar()
            }
        return(.integer(Argon.Integer(hexValue),self.sourceLocation()))
        }
    
    private func nextBinaryNumber() -> Token
        {
        nextChar()
        var binaryValue:UInt64 = 0
        while binaryDigits.contains(self.currentChar)
            {
            binaryValue *= 2
            if self.currentChar == "1"
                {
                binaryValue += 1
                }
            nextChar()
            }
        return(.integer(Argon.Integer(binaryValue),self.sourceLocation()))
        }
    
    private func nextIdentifier() -> Token
        {
        repeat
            {
            currentString.append(String(self.currentChar))
            self.nextChar()
            }
        while alphanumerics.contains(self.currentChar) && !self.atEnd && !self.atEndOfLine
        if currentString == "?"
            {
            return(.identifier("?",self.sourceLocation()))
            }
        if self.currentChar == ":" && self.currentString != "otherwise"
            {
            let nextOne = self.peekChar(at: 0)
            if nextOne == ":"
                {
                return(self.checkForSymbolOrKeywordOrIdentifier(currentString))
                }
            self.nextChar()
            return(.tag(currentString + ":",self.sourceLocation()))
            }
        return(checkForSymbolOrKeywordOrIdentifier(currentString))
        }
    
    private func checkForSymbolOrKeywordOrIdentifier(_ string:String) -> Token
        {
        if self.keywords.contains(string)
            {
            if self.nativeTypes.contains(string)
                {
                return(.nativeType(Token.Keyword(rawValue:string)!,self.sourceLocation()))
                }
            else
                {
                return(.keyword(Token.Keyword(rawValue:string)!,self.sourceLocation()))
                }
            }
        else
            {
            return(.identifier(string,self.sourceLocation()))
            }
        }
    
    private func nextSymbol() -> Token
        {
        var operatorString:String = ""
        if self.currentChar == "."
            {
            self.nextChar()
            if self.currentChar == "."
                {
                self.nextChar()
                if self.currentChar == "."
                    {
                    self.nextChar()
                    return(.symbol(.fullRange,self.sourceLocation()))
                    }
                return(.symbol(.halfRange,self.sourceLocation()))
                }
            return(.symbol(.stop,self.sourceLocation()))
            }
        if self.currentChar == "("
            {
            self.nextChar()
            return(.symbol(.leftParenthesis,self.sourceLocation()))
            }
        else if self.currentChar == ")"
            {
            self.nextChar()
            return(.symbol(.rightParenthesis,self.sourceLocation()))
            }
        else if self.currentChar == "}"
            {
            self.nextChar()
            return(.symbol(.rightBrace,self.sourceLocation()))
            }
        else if self.currentChar == "{"
            {
            self.nextChar()
            return(.symbol(.leftBrace,self.sourceLocation()))
            }
        else if self.currentChar == "]"
            {
            self.nextChar()
            return(.symbol(.rightBracket,self.sourceLocation()))
            }
        else if self.currentChar == "["
            {
            self.nextChar()
            return(.symbol(.leftBracket,self.sourceLocation()))
            }
        else if self.currentChar == "/"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.divEquals,self.sourceLocation()))
                }
            else
                {
                return(self.nextOperator(withPrefix:"/"))
                }
            }
        else if self.currentChar == ","
            {
            self.nextChar()
            return(.symbol(.comma,self.sourceLocation()))
            }
        else if self.currentChar == ">"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.rightBrocketEquals,self.sourceLocation()))
                }
            else
                {
                return(self.nextOperator(withPrefix:">"))
                }
            }
        else if self.currentChar == ":"
            {
            self.nextChar()
            if self.currentChar == ":"
                {
                self.nextChar()
                return(.symbol(.gluon,self.sourceLocation()))
                }
            return(.symbol(.colon,self.sourceLocation()))
            }
        else if self.currentChar == "="
            {
            self.nextChar()
            return(self.nextOperator(withPrefix: "="))
            }
        else if self.currentChar == "&"
            {
            self.nextChar()
            if self.currentChar == "&"
                {
                self.nextChar()
                return(.symbol(.and,self.sourceLocation()))
                }
            else if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.bitAndEquals,self.sourceLocation()))
                }
            else
                {
                return(.symbol(.bitAnd,self.sourceLocation()))
                }
            }
        else if self.currentChar == "|"
            {
            self.nextChar()
            if self.currentChar == "|"
                {
                self.nextChar()
                return(.symbol(.or,self.sourceLocation()))
                }
            else if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.bitOrEquals,self.sourceLocation()))
                }
            else
                {
                return(.symbol(.bitOr,self.sourceLocation()))
                }
            }
        else if self.currentChar == "+"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.addEquals,self.sourceLocation()))
                }
            else
                {
                return(self.nextOperator(withPrefix:"+"))
                }
            }
        else if self.currentChar == "-"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.subEquals,self.sourceLocation()))
                }
            else if self.currentChar == ">"
                {
                self.nextChar()
                return(.symbol(.rightArrow,self.sourceLocation()))
                }
            else
                {
                return(.symbol(.sub,self.sourceLocation()))
                }
            }
        else if self.currentChar == "*"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.mulEquals,self.sourceLocation()))
                }
            else
                {
                return(self.nextOperator(withPrefix:"*"))
                }            }
        else if self.currentChar == "~"
            {
            self.nextChar()
            if self.currentChar == "="
                {
                self.nextChar()
                return(.symbol(.bitNotEquals,self.sourceLocation()))
                }
            else
                {
                return(self.nextOperator(withPrefix:"~"))
                }
            }
        else if !self.operatorSymbols.contains(self.currentChar)
            {
            return(.error(CompilerError(.invalidSymbolCharacter(Character(self.currentChar)),self.sourceLocation())))
            }
        while self.operatorSymbols.contains(self.currentChar)
            {
            operatorString += String(self.currentChar)
            self.nextChar()
            }
        if let symbolType = Token.Symbol(rawValue: operatorString)
            {
            return(.symbol(symbolType,self.sourceLocation()))
            }
        return(.operator(operatorString,self.sourceLocation()))
        }
    
    internal func sourceLocation() -> SourceLocation
        {
        tokenStop = characterOffset
        return(SourceLocation(line:tokenLine,lineStart: lineStart,lineStop: self.lineStart + self.lineLength,tokenStart:max(tokenStart - 1,0),tokenStop:tokenStop-1))
        }
    
    private func nextOperator(withPrefix startString:String) -> Token
        {
        var operatorString = startString
        while self.operatorSymbols.contains(self.currentChar)
            {
            operatorString += String(self.currentChar)
            self.nextChar()
            }
        if let symbolType = Token.Symbol(rawValue: operatorString)
            {
            return(.symbol(symbolType,self.sourceLocation()))
            }
         return(.operator(operatorString,self.sourceLocation()))
        }
        
    private func initKeywords()
        {
        self.keywords = []
        self.nativeTypes = []
        for keyword in Token.Keyword.allCases
            {
            self.keywords.append(keyword.rawValue)
            }
        self.nativeTypes.append(contentsOf: ["Object","Instance","Value","Void","Date","Tuple","Float16","Float","Float32","Float64","String","List","Array","Dictionary","BitSet","Set","Boolean","Integer","UInteger","Integer64","Integer32","Integer16","Integer8","UInteger64","UInteger32","UInteger16","UInteger8","Character","Byte","Symbol"])
        }
    }

extension String
    {
    func index(from: Int) -> Index
        {
        return self.index(startIndex, offsetBy: from)
        }

    func substring(from: Int) -> String
        {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
        }

    func substring(to: Int) -> String
        {
        let toIndex = index(from: to)
        return substring(to: toIndex)
        }

    func substring(with r: Range<Int>) -> String
        {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
        }
        
//    func subString(from: Int, to: Int) -> String
//        {
//        let startIndex = self.index(self.startIndex, offsetBy: from)
//        let endIndex = self.index(self.startIndex, offsetBy: to)
//        return String(self[startIndex...endIndex])
//        }
    }
