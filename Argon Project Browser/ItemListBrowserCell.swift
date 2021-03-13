//
//  ListView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

extension NSFont
    {
    public func size(ofString:String) -> NSSize
        {
        let string = NSAttributedString(string:ofString,attributes:[.font:self])
        return(string.size())
        }
    }
    
public class ItemListBrowserCell:ItemBrowserCell
    {
    private let listView:ListView
    private let list:ElementalList
    
    init(list:ElementalList,textColor:NSColor)
        {
        self.list = list
        listView = ListView(title:list.title,frame:.zero,list:list.titles,elementType:.slot)
        listView.textColor = textColor
        listView.rowSpacing = 2
        listView.cornerRadius = 10
        listView.borderColor = textColor
        listView.borderWidth = 1
        listView.font = Self.kDefaultFont
        super.init()
        self.addSubview(listView)
        let totalHeight = self.totalHeight()
        listView.rowHeight = totalHeight
        }
    
    private func totalHeight() -> CGFloat
        {
        let titleSize = Self.kDefaultFont.size(ofString: list.title)
        let totalHeight = CGFloat(list.titles.count + 1) * titleSize.height
        return(totalHeight)
        }
        
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
