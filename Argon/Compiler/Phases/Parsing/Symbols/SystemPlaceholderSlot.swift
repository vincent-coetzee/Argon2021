//
//  SystemPlaceholderSlot.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class SystemPlaceholderSlot:Slot
    {
    public override var isPlaceholder:Bool
        {
        return(true)
        }
    }

public class SystemPlaceholderRawSlot:SystemPlaceholderSlot
    {
    public override var isRawSlot:Bool
        {
        return(true)
        }
    }
