//
//  Constant.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/19.
//

import Foundation

public class Constant:Variable
    {
    internal override var type:Type
        {
        get
            {
            return(.constant(self._type))
            }
        set
            {
            }
        }
        
    override init(name:Name,type:Type)
        {
        super.init(name:name,type:type)
        }
    
    override init(shortName:Identifier,type:Type)
        {
        super.init(shortName:shortName,type:type)
        }
        
    internal required init() {
        fatalError("init() has not been implemented")
    }
}
