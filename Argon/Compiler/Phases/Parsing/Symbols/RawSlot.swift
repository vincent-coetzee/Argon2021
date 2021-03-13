//
//  RawSlot.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/09.
//

import Foundation

public class RawSlot:Slot
    {
    public override var cloned:Slot
        {
        return(RawSlot(shortName:self.shortName,class:self._class,container:self.container,attributes:self.attributes))
        }
        
    public override var isRawSlot:Bool
        {
        return(true)
        }
    }
