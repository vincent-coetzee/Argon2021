//
//  SlotKindRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Foundation

public class SlotKindRowWrapper:SwitchRowWrapper
    {
    init(slot:Slot)
        {
        let titles = ["local","class","virtual","alias"]
        var rows:Array<TitledGroupRowWrapper> = []
        for title in titles
            {
            rows.append(TitledGroupRowWrapper(title:title,children:[SlotRowWrapper(slot:slot)]))
            }
        super.init(choices:rows)
        }
    }
