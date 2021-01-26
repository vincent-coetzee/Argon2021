//
//  InferredSlotExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class InferredSlotExpression:AccessExpression
    {
    let slot:String
    
    init(slot:String)
        {
        self.slot = slot
        super.init()
        }
    }
    
