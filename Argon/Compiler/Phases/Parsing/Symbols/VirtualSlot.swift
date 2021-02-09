//
//  VirtualSlot.swift
//  Argon
//
//  Created by Vincent Coetzee on 21/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class VirtualSlot:Slot
    {
    public override var cloned:Slot
        {
        return(VirtualSlot(shortName:self.shortName,class:self._class,container:self.containingSymbol,attributes:self.attributes))
        }
    }

//internal class ModuleSlot:Slot
//    {
//    }
//    
//internal class MetaSlot:Slot
//    {
//    }
//
//
