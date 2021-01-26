//
//  Constant.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/19.
//

import Foundation

public class Constant:Variable
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
    }
