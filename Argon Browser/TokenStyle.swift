//
//  TokenStyle.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/09.
//

import Foundation
import AppKit

public class TokenStyle
    {
    public static var styles = [Token.TokenType:TokenStyle]()

    static func initStyles()
        {
        styles[.keyword] = TokenStyle(type:.keyword,foreground: NSColor(red:128,green:189,blue:4),font:NSFont.tokenFont)
        styles[.comment] = TokenStyle(type:.comment,foreground: NSColor(red:255,green:255,blue:255),font:NSFont.tokenFont)
        styles[.nativeType] = TokenStyle(type:.nativeType,foreground: NSColor(red:255,green:38,blue:0),font:NSFont.tokenFont)
        styles[.identifier] = TokenStyle(type:.identifier,foreground: NSColor(red:170,green:13,blue:145),font:NSFont.tokenFont)
//        styles.append(TokenStyle(type:.symbol,foreground: NSColor.argonBlue,font:NSFont.tokenFont))
        styles[.symbol] = TokenStyle(type:.symbol,foreground: NSColor(red:252,green:106,blue:92),font:NSFont.tokenFont)
        styles[.true] = TokenStyle(type:.symbol,foreground: NSColor.argonCheese,font:NSFont.tokenFont)
        styles[.false] = TokenStyle(type:.symbol,foreground: NSColor.argonCheese,font:NSFont.tokenFont)
        styles[.float] = TokenStyle(type:.float,foreground: NSColor.argonCyan,font:NSFont.tokenFont)
        styles[.string] = TokenStyle(type:.string,foreground: NSColor(red:252,green:106,blue:92),font:NSFont.tokenFont)
        styles[.integer] = TokenStyle(type:.integer,foreground: NSColor(red:128,green:189,blue:4),font:NSFont.tokenFont)
        styles[.hashString] = TokenStyle(type:.hashString,foreground: NSColor.argonDeepOrange,font:NSFont.tokenFont)
        }
        
    public static func updateStyle(tokens:[Token],of textView:NSTextView)
        {
        let font = NSFont(name: "Menlo",size: 14)
        textView.font = font
        let attributedString = textView.textStorage
        let string = attributedString!.string
        let count = string.count
        for token in tokens
            {
            let type = token.tokenType
            if let style = self.styles[type]
                {
                let attributes = style.attributes
                let theRange = NSRange(location: token.location.tokenStart,length: token.location.tokenStop - token.location.tokenStart)
                if token.location.tokenStop <= count
                    {
                    attributedString?.setAttributes(attributes, range: theRange)
                    }
                else
                    {
                    print("Error")
                    }
                }
            }
        }
        
    var attributes:[NSAttributedString.Key:Any]
        {
        if self._attributes == nil
            {
            self._attributes = [NSAttributedString.Key:Any]()
            self._attributes?[.font] = self.font
            self._attributes?[.backgroundColor] = NSColor.black
            self._attributes?[.foregroundColor] = self.foregroundColor
            }
        return(self._attributes)!
        }
        
    let tokenType:Token.TokenType
    let foregroundColor:NSColor
    let font:NSFont
    private var _attributes:[NSAttributedString.Key:Any]? = nil
    
    init(type:Token.TokenType,foreground:NSColor,font:NSFont)
        {
        self.tokenType = type
        self.foregroundColor = foreground
        self.font = font
        }
        
    func apply(tokens:[Token],to string:NSMutableAttributedString)
        {
        let selectedTokens = tokens.filter{$0.isTokenType(self.tokenType)}
        let ranges = selectedTokens.map{NSRange(location:$0.location.tokenStart,length:$0.location.tokenStop - $0.location.tokenStart + 1)}
        var attributes:[NSAttributedString.Key:Any] = [:]
        attributes[.font] = self.font
        attributes[.foregroundColor] = self.foregroundColor
        let length = string.length
        for range in ranges
            {
            if range.location + range.length < length
                {
                string.setAttributes(attributes,range:range)
                }
            }
        }
    }
