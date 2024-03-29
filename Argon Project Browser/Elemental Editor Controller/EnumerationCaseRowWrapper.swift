//
//  EnumerationCaseRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class EnumerationCaseRowWrapper:RowWrapper
    {
    public override var isExpandable:Bool
        {
        return(false)
        }
        
    private let enumerationCase:EnumerationCase
        
    public override func rowView() -> NSView
        {
        let view = NSTextField(frame:.zero)
        view.isBezeled = false
        view.isEditable = false
        view.textColor = self.primaryColor
        view.layoutFrame = LayoutFrame(left:0,0,top:0,0,right:1,0,bottom:1,0)
        view.stringValue = enumerationCase.symbol
        return(view)
        }
        
    public override var rowHeight:CGFloat
        {
        return(24)
        }
        
    public override var count:Int
        {
        return(0)
        }
        
    init(enumerationCase:EnumerationCase)
        {
        self.enumerationCase = enumerationCase
        }
    }
