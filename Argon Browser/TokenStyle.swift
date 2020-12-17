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
    let tokenType:Token.TokenType
    let foregroundColor:NSColor
    let font:NSFont
    
    init(type:Token.TokenType,foreground:NSColor,font:NSFont)
        {
        self.tokenType = type
        self.foregroundColor = foreground
        self.font = font
        }
        
    func apply(tokens:[Token],string:NSMutableAttributedString)
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
