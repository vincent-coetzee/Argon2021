//
//  ArgonSourceTokenizingTextView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

public class ArgonSourceTokenizingTextView:LineNumberTextView
    {
    public static let defaultTokenTypes:[TokenType] =
        {
        let font = NSFont(name:"Menlo",size:12)!
        var types:[TokenType] = []
        types.append(TokenType(type:.comment,color:NSColor.argonPurple,font: font))
        types.append(TokenType(type:.keyword,color:NSColor.argonNeonPink,font: font))
        types.append(TokenType(type:.nativeType,color:NSColor.argonSeaGreen,font: font))
        types.append(TokenType(type:.identifier,color:NSColor.argonCheese,font: font))
        types.append(TokenType(type:.symbol,color:NSColor.argonGreen,font: font))
        types.append(TokenType(type:.string,color:NSColor.argonCyan,font: font))
        types.append(TokenType(type:.hashString,color:NSColor.argonCoral,font: font))
        types.append(TokenType(type:.integer,color:NSColor.argonSizzlingRed,font: font))
        types.append(TokenType(type:.float,color:NSColor.argonYellow,font: font))
        types.append(TokenType(type:.operator,color:NSColor.argonPomelo,font: font))
        types.append(TokenType(type:.tag,color:NSColor.argonSizzlingRed,font: font))
        return(types)
        }()
        
    public struct TokenType
        {
        let type:Token.TokenType
        let font:NSFont
        let color:NSColor
        var attributes:[NSAttributedString.Key:Any] = [:]
        
        init(type:Token.TokenType,color:NSColor,font:NSFont? = nil)
            {
            self.type = type
            self.color = color
            self.font = font ?? NSFont.systemFont(ofSize:10)
            self.initAttributes()
            }
            
        private mutating func initAttributes()
            {
            self.attributes[.font] = self.font
            self.attributes[.foregroundColor] = color
            }
        }
        
    public var source:String
        {
        get
            {
            self._source = self.textStorage?.string ?? ""
            return(self._source)
            }
        set
            {
            self._source = newValue
            self.string = self._source
            self.tokenizeSource()
            }
        }
     
    public var tokenTypes:[TokenType] = ArgonSourceTokenizingTextView.defaultTokenTypes
        {
        didSet
            {
            self.indexTokenTypes()
            self.tokenizeSource()
            }
        }
        
    private let tokenStream = TokenStream()
    private var indexedTypes:[Token.TokenType:TokenType] = [:]
    private var defaultType:TokenType = TokenType(type:.none,color:NSColor.argonMangoGreen,font:NSFont(name:"Menlo-Regular",size:12)!)
    private var _source:String = ""
    
    private func indexTokenTypes()
        {
        self.indexedTypes = [:]
        for type in self.tokenTypes
            {
            self.indexedTypes[type.type] = type
            }
        }
        
    private func tokenizeSource()
        {
        self.wantsLayer = true
        self.indexTokenTypes()
//        self.string = self._source
        self.textStorage?.font = self.defaultType.font
        self.textStorage?.foregroundColor = self.defaultType.color
        let string = NSMutableAttributedString(string:self.string,attributes:[:])
        self.tokenStream.reset(source:self.string)
        let tokens = self.tokenStream.tokens(withComments:true)
        let storage = self.textStorage!
        storage.beginEditing()
        for token in tokens
            {
            let type = self.indexedTypes[token.tokenType] ?? self.defaultType
            let range = NSRange(location: token.location.tokenStart,length: token.location.tokenStop - token.location.tokenStart)
            storage.setAttributes(type.attributes,range: range)
            }
        storage.endEditing()
//        self.textStorage?.setAttributedString(string)
        self._source = self.string
        }
        
    public override func cartouche(_ cartouche:LineAnnotation,drawnIn rect:NSRect)
        {
//        let bounds = self.bounds
//        let newLine = CALayer()
//        let newFrame = NSRect(x:rect.minX,y:rect.minY,width:bounds.size.width,height:rect.size.height)
//        newLine.frame = newFrame
//        newLine.backgroundColor = NSColor.argonLime.cgColor
//        self.layer?.addSublayer(newLine)
        }
        
    public override func didChangeText()
        {
        super.didChangeText()
        self.tokenizeSource()
        }
    }
