//
//  TitledPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Cocoa

public class TitledPane:RowPane
    {
    private let title:String
    private let titlePane:TextPane
    
    init(title:String)
        {
        self.title = title
        self.titlePane = TextPane(text:title)
        super.init()
        self.initTitle()
        }
    
    internal override func style()
        {
        self.titlePane.font = NSFont(name:"Ubuntu-Bold",size:18)!
        }
        
    private func initTitle()
        {
        self.addSublayer(self.titlePane)
        }
        
    public override func layout()
        {
        let size = self.titlePane.measure()
        self.titlePane.frame = NSPoint.zero.extent(size)
        var origin = NSPoint(x:0,y:size.height + StylePalette.kRowSpacerWidth)
        for kid in self.kids
            {
            let kidSize = kid.measure()
            kid.bounds = NSPoint.zero.extent(kidSize)
            kid.position = origin.extent(kidSize).center
            origin.y += kidSize.height + StylePalette.kRowSpacerWidth
            }
        }
        
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
