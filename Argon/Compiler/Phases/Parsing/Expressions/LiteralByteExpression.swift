//
//  LiteralByteExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralByteExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.byteClass)
        }
        
    let byte:UInt8
    
    init(byte:UInt8)
        {
        self.byte = byte
        super.init()
        }
    }
