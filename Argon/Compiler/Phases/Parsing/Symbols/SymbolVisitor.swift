//
//  SymbolVisitor.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/16.
//

import Foundation

public protocol SymbolVisitor
    {
    func acceptSymbol(_ symbol:Symbol)
    func acceptModule(_ module:Module)
    func acceptClass(_ aClass:Class)
    func acceptMethod(_ method:Method)
    }

public protocol SymbolVisitorAcceptor
    {
    func accept(_ visitor:SymbolVisitor)
    }
    
public class SymbolWalker:SymbolVisitor
    {
    var indent = ""
    var visitedSymbols:[Symbol] = []
    
    private func indented(_ closure:()->Void)
        {
        let lastIndent = self.indent
        self.indent += "\t"
        closure()
        self.indent = lastIndent
        }
        
    public func walkSymbols(_ module:Module)
        {
        self.indented
            {
            module.accept(self)
            }
        }
        
    public func acceptSymbol(_ symbol:Symbol)
        {
        print("ERROR: \(Swift.type(of:symbol)) \(symbol.shortName) should have been handled directly")
        }
        
    public func acceptModule(_ module:Module)
        {
        self.indented
            {
            if visitedSymbols.contains(module)
                {
                print("WARNING: Module \(module.shortName) already walked")
                }
            else
                {
                if module is ImportedModuleReference
                    {
                    print("\(indent) IMPORTED MODULE")
                    }
                print("\n\(indent)START Module \(module.shortName) ------------------------------")
                for symbol in module.allSymbols.filter{$0 is Module}
                    {
                    symbol.accept(self)
                    }
                for symbol in module.allSymbols.filter{!($0 is Module)}
                    {
                    symbol.accept(self)
                    }
                print("\(indent)END Module \(module.shortName) ------------------------------\n")
                }
            visitedSymbols.append(module)
            }
        }
        
    public func acceptClass(_ aClass:Class)
        {
        print("\(indent)Class(\(aClass.shortName))")
        self.indented
            {
            for slot in aClass.localSlots.values
                {
                print("\(indent)\(slot.shortName) \(slot._class.shortName)")
                }
            }
        }
        
    public func acceptMethod(_ method:Method)
        {
        print("\(indent)Method(\(method.shortName))")
        }
    }
