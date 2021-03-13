//
//  ListView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

public enum ListElementType
    {
    case slot
    case typeVariable
    case superclass
    }
    
public class ListLayer:CALayer,Sizable
    {
    public var layoutFrame:LayoutFrame = .zero
    
    public func measureText(_ string:String) -> NSSize
        {
        let font = StylePalette.kDefaultFont
        let attributes:[NSAttributedString.Key:Any] = [.font:font]
        let text = NSAttributedString(string:string,attributes:attributes)
        return(text.size())
        }
        
    public func addSublayer(_ layer:ListLayer,in:LayoutFrame)
        {
        layer.layoutFrame = `in`
        self.addSublayer(layer)
        }
        
    public func addSublayer(_ layer:ListTextLayer,in:LayoutFrame)
        {
        layer.layoutFrame = `in`
        self.addSublayer(layer)
        }
    }
    
public class ListTextLayer:CATextLayer,Sizable
    {
    public var layoutFrame:LayoutFrame = .zero
    }
    
public class SlotLayer:ListLayer
    {
    let titleLayer = ListTextLayer()
    let classLayer = ListTextLayer()
    let deleteButtonLayer = ListTextLayer()
    let addButtonLayer = ListTextLayer()
    let theClass:Class
    let slot:Slot
    
    init(slot:Slot)
        {
        self.slot = slot
        self.theClass = slot.typeClass
        self.titleLayer.string = slot.shortName
        self.classLayer.string = "::" + slot.typeClass.shortName
        self.deleteButtonLayer.string = "􀈓"
        self.addButtonLayer.string = "􀁌"
        super.init()
        self.addSublayer(self.titleLayer,in:LayoutFrame.firstHalf)
        let button1 = LayoutFrame(left:1,-2*24,top:0,0,right:1,-24,bottom:1,0)
        let button2 = LayoutFrame(left:1,-1*24,top:0,0,right:1,0,bottom:1,0)
        self.addSublayer(self.classLayer,in: LayoutFrame.lastHalf(after:button1,button2))
        self.addSublayer(self.deleteButtonLayer,in:button1)
        self.addSublayer(self.addButtonLayer,in:button2)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSublayers()
        {
        super.layoutSublayers()
        let myBounds = self.bounds
        for layer in self.sublayers!
            {
            let sizable = layer as! Sizable
            layer.frame = sizable.layoutFrame.frame(in: myBounds)
            }
        }
    }
    
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
        
    init(title:String,frame:NSRect,list:Array<String>,elementType:ListElementType)
        {
        self.list = list
        var layers:Array<CATextLayer> = []
        let layer = CATextLayer()
        layer.string = title
        layers.append(layer)
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
