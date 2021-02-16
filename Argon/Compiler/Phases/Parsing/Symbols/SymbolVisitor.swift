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
    func acceptBitSet(_ bitSet:BitSet)
    func acceptEnumeration(_ enumeration:Enumeration)
    func acceptConstant(_ constant:Constant)
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
        
    public func acceptBitSet(_ bitSet:BitSet)
        {
        self.indented
            {
            print("\(indent)BitSet(\(bitSet.shortName))")
            self.indented
                {
                for field in bitSet.fields.values
                    {
                    print("\(indent)\(field.name)(\(field.offset),\(field.width))")
                    }
                }
            }
        }
        
    public func acceptEnumeration(_ enumeration:Enumeration)
        {
        self.indented
            {
            print("\(indent)Enumeration(\(enumeration.shortName))")
            self.indented
                {
                for aCase in enumeration.cases
                    {
                    print("\(indent)\(aCase.displayString)")
                    }
                }
            }
        }
        
    public func acceptConstant(_ constant:Constant)
        {
        self.indented
            {
            print("\(indent)Constant(\(constant.shortName))")
            }
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
        self.indented
            {
            var supers = aClass.superclasses.map{$0.fullName.stringName}.joined(separator:",")
            if !supers.isEmpty
                {
                supers = "::(" + supers + ")"
                }
            print("\(indent)Class(\(aClass.shortName))\(supers)")
            self.indented
                {
                for slot in aClass.localSlots.values
                    {
                    print("\(indent)\(slot.shortName) \(slot._class.shortName)")
                    }
                }
            }
        }
        
    public func acceptMethod(_ method:Method)
        {
        self.indented
            {
            print("\(indent)Method(\(method.shortName))")
            }
        }
    }
