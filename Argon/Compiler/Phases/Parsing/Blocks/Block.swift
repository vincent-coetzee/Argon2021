//
//  Block.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Block:Statement,Scope
    {
    public func asSymbolContainer() -> SymbolContainer
        {
        return(.block(self))
        }
    
    static func ==(lhs:Block,rhs:Block) -> Bool
        {
        return(lhs.statements == rhs.statements && lhs.symbols == rhs.symbols)
        }
        
    internal var lastStatementIsNotReturn:Bool
        {
        if self.statements.isEmpty
            {
            return(true)
            }
        let last = self.statements.last!
        return(!last.isReturnStatement)
        }
        
    internal var blockLocalVariables:[LocalVariable]
        {
        return(self.symbols.symbols.filter{$0 is LocalVariable}.map{$0 as! LocalVariable})
        }
        
    public var rootSymbol:Symbol
        {
        return(self.container.rootSymbol)
        }
        
    internal var statements = Statements()
    internal var symbols = SymbolDictionary()
    internal var marker:Int?
    
    convenience init(container:SymbolContainer)
        {        
        self.init()
        self.container = container
        }
        
    init(block:Block)
        {
        self.statements = block.statements
        self.symbols = block.symbols
        self.marker = block.marker
        }
        
    init(inductionVariable:InductionVariable)
        {
        self.marker = Argon.nextIndex()
        super.init()
        self.addVariable(inductionVariable)
        }
        
    override init(location:SourceLocation = .zero)
        {
        super.init(location:location)
        }
        
    init()
        {
        super.init(location:.zero)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        for statement in self.statements
            {
            try statement.allocateAddresses(using:compiler)
            }
        fatalError("")
        }
        
    internal var lastStatement:Statement
        {
        return(self.statements.last!)
        }
        
    internal func addVariable(_ variable:Variable)
        {
        self.symbols.addSymbol(variable)
        }
        
    internal override func addStatement(_ statement:Statement?)
        {
        if let aLine = statement
            {
            self.statements.append(aLine)
            }
        }

    internal func setStatements(_ statements:[Statement])
        {
        self.statements = statements
        }
        
    public override func lookup(shortName:String) -> SymbolSet?
        {
        if let set = self.symbols.lookup(shortName:shortName)
            {
            return(set)
            }
        return(self.container.lookup(shortName:shortName))
        }
        
    public override func lookup(name:Name) -> SymbolSet?
        {
        if name.isAnchored
            {
            return(Module.rootModule.lookup(name:name))
            }
        if let set = self.symbols.lookup(name:name)
            {
            return(set)
            }
        return(self.container.lookup(name:name))
        }
        
    internal override func lookupMethod(shortName:String) -> Method?
        {
        return(self.container.lookupMethod(shortName:shortName))
        }
        
    public override func typeCheck() throws
        {
        for statement in self.statements
            {
            try statement.typeCheck()
            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        // TODO: Add check for reachability of artifical return I add at end here
        for statement in self.statements
            {
            try statement.generateIntermediateCode(in: module,codeHolder:CodeHolder.block(self), into: buffer, using: using)
            }
        }
    }
