//
//  ListView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

class ListView:NSView
    {
    private let list:Array<String>
    private let layerList:Array<CATextLayer>
    
    public var borderColor:NSColor = .white
        {
        didSet
            {
            self.layer?.borderColor = self.borderColor.cgColor
            }
        }
        
    public var borderWidth:CGFloat = 0
        {
        didSet
            {
            self.layer?.borderWidth = self.borderWidth
            }
        }
        
    public var cornerRadius:CGFloat = 0
        {
        didSet
            {
            self.layer?.cornerRadius = self.cornerRadius
            }
        }
        
    public var rowSpacing:CGFloat = 2
        {
        didSet
            {
            self.layoutLines()
            }
        }
        
    public var insetX:CGFloat = 20
        {
        didSet
            {
            self.layoutLines()
            }
        }
        
    public var rowHeight:CGFloat = 20
        {
        didSet
            {
            self.layoutLines()
            }
        }
        
    public var textColor:NSColor = .darkGray
        {
        didSet
            {
            for layer in layerList
                {
                layer.foregroundColor = self.textColor.cgColor
                }
            }
        }
        
    public var font:NSFont = NSFont.systemFont(ofSize: 10)
        {
        didSet
            {
            self.layoutLines()
            }
        }
        
    public var size:NSSize = .zero
        
    init(frame:NSRect,list:Array<String>)
        {
        self.list = list
        var layers:Array<CATextLayer> = []
        for string in list
            {
            let text = CATextLayer()
            text.string = string
            layers.append(text)
            }
        self.layerList = layers
        super.init(frame:frame)
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.argonNeonPink.cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = 10
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutLines()
        {
        let attributes:[NSAttributedString.Key:Any] = [.font:self.font,.foregroundColor:self.textColor]
        var index = 0
        self.size = .zero
        var offset:CGFloat = 0
        for layer in self.layerList
            {
            layer.font = font
            let layerSize = NSAttributedString(string:list[index],attributes:attributes).size()
            let inset = NSPoint(x:insetX + offset,y:(self.rowHeight - layerSize.height) / 2)
            layer.frame = inset.extent(layerSize)
            self.size.width = max(self.size.width,layerSize.width)
            offset += layerSize.height + self.rowSpacing
            self.size.height += layerSize.height + self.rowSpacing
            index += 1
            }
        }
}
