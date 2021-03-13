//
//  SwitchRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class SwitchRowWrapper:RowWrapper
    {
        
    public override var isExpandable:Bool
        {
        return(true)
        }
        
    public override func rowView() -> NSView
        {
        let view = NSPopUpButton(frame:.zero)
        view.addItems(withTitles: self.choices.map{$0.title})
        view.target = self
        view.action = #selector(onTitleSelected)
        self.button = view
        return(view)
        }
        
    @IBAction
    public func onTitleSelected(_ sender:Any?)
        {
        let title = self.button!.selectedItem!.title
        for element in self.choices
            {
            if element.title == title
                {
                self.selectedTitle = element
                break
                }
            }
        if let outliner = self.button!.outlinerView
            {
            outliner.reloadData()
            }
        }
        
    public override var rowHeight:CGFloat
        {
        return(18)
        }
        
    public override var count:Int
        {
        return(selectedTitle == nil ? 0 : 1)
        }
        
    public override func child(atIndex index:Int) -> RowWrapper
        {
        if selectedTitle == nil
            {
            fatalError()
            }
        return(self.selectedTitle!)
        }
        
    private let choices:Array<TitledGroupRowWrapper>
    private var selectedTitle:TitledGroupRowWrapper?
    private var button:NSPopUpButton?
    
    init(choices:Array<TitledGroupRowWrapper>)
        {
        self.choices = choices
        }
    }



