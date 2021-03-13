//
//  EnumerationWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class EnumerationRowWrapper:RowWrapper
    {
    public override var isExpandable:Bool
        {
        return(true)
        }
        
    private let enumeration:Enumeration
        
    public override func rowView() -> NSView
        {
        let view = NSTextField(frame:.zero)
        view.isBezeled = false
        view.isEditable = false
        view.textColor = self.primaryColor
        view.layoutFrame = LayoutFrame(left:0,0,top:0,0,right:1,0,bottom:1,0)
        view.stringValue = "\(self.enumeration.shortName) :: \(self.enumeration.typeClass.completeName)"
        return(view)
        }
        
    public override var rowHeight:CGFloat
        {
        return(24)
        }
        
    public override var count:Int
        {
        return(self.enumeration.childCount)
        }
        
    public override func child(atIndex index:Int) -> RowWrapper
        {
        return(EnumerationCaseRowWrapper(enumerationCase:self.enumeration.cases[index]))
        }
        
    init(enumeration:Enumeration)
        {
        self.enumeration = enumeration
        }
    }
