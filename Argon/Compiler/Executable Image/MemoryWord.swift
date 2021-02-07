//
//  MemoryWord.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/27.
//

import Foundation

public enum MemoryWord
    {
    case integer(Argon.Integer)
    case float(Argon.Float)
    case pointer(MemoryAddress)
    case boolean(Argon.Boolean)
    case byte(Argon.Byte)
    case character(Argon.Character)
    }
