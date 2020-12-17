//
//  Lvalue.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/11/22.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public indirect enum LValue
    {
    case none
    case slot([String])
    case `subscript`(Expression)
    case variable(String)
    case tuple([LValue])
    case compound([LValue])
    }
