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
        fatalError("Function \(#function) should not have been called")
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
        }
        
    internal func allocateAddresses(using compiler:Compiler) throws
        {
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        fatalError("Not implemented")
        }
    }

