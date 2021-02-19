//
//  Constant.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/19.
//

import Foundation

public class Constant:Variable,NSCoding
    {
    internal override var typeClass:Class
        {
        get
            {
            return(ConstantClass(shortName: Argon.nextName("CONSTANT"),class: self._class))
            }
        set
            {
            }
        }
        
    public required init?(coder: NSCoder)
        {
        super.init(coder:coder)
        }
    
    internal override init(shortName:String,class:Class)
        {
        super.init(shortName:shortName,class:`class`)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
    
    public override func encode(with coder: NSCoder)
        {
        super.encode(with:coder)
        }
        
   public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptConstant(self)
        }
    }
