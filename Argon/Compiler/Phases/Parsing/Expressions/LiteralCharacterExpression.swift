//
//  LiteralCharacterExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralCharacterExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.characterClass)
        }
        
    let character:Argon.Character
    
    init(character:Argon.Character)
        {
        self.character = character
        super.init()
        }
    }
    
