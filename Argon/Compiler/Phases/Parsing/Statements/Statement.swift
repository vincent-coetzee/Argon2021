//
//  Statement.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Statement:ParseNode
    {
    public static func ==(lhs:Statement,rhs:Statement) -> Bool
        {
        return(lhs.id == rhs.id)
        }
        
    internal var isReturnStatement:Bool
        {
        return(false)
        }
        
    internal var location:SourceLocation = .zero
        
    public func typeCheck() throws
        {
        }
        
    public init(location:SourceLocation = .zero)
        {
        self.location = location
        super.init()
        }
        
    public required init(coder:NSCoder)
        {
        super.init(coder:coder)!
        }
        
    internal func allocateAddresses(using compiler:Compiler) throws
        {
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        fatalError("Not implemented")
        }
    }

public typealias Statements = Array<Statement>

public typealias LocalVariableDictionary = Dictionary<String,LocalVariable>
