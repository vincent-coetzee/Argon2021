//
//  Folio.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

extension CGSize
    {
    public static let defaultPaneSize = CGSize(width:50,height:50)
    }
    
public typealias Panes = Array<Pane>

public class Pane:CAShapeLayer
    {
    public enum HorizontalAlgnment
        {
        case left
        case right
        case center
        case justified
        }
        
    public enum VerticalAlignment
        {
        case top
        case middle
        case bottom
        }
        
    internal var layoutFrame = LayoutFrame.zero
        
    public override init()
        {
        super.init()
        self.style()
        self.removeAllAnimations()
        }
    
    internal func style()
        {
        }
        
    public override init(layer:Any)
        {
        super.init(layer: layer)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func withBorder(style:StylePalette.BorderStyle = StylePalette.kDefaultBorderStyle) -> Pane
        {
        return(BorderedPane(pane:self,borderStyle:style))
        }
        
    internal func measure() -> CGSize
        {
        return(CGSize.defaultPaneSize)
        }
        
    @discardableResult
    public func layoutFrame(left:CGFloat,_ leftOffset:CGFloat,top:CGFloat,_ topOffset:CGFloat,right:CGFloat,_ rightOffset:CGFloat,bottom:CGFloat,_ bottomOffset:CGFloat) -> Pane
        {
        self.layoutFrame = LayoutFrame(left:left,leftOffset,top:top,topOffset,right:right,rightOffset,bottom:bottom,bottomOffset)
        return(self)
        }
        
    @discardableResult
    public func square(_ size:CGFloat) -> Pane
        {
        self.layoutFrame(left:0,0,top:0,0,right:0,size,bottom:0,size)
        return(self)
        }
        
    @discardableResult
    public func restLayoutAfter(_ sizeX:CGFloat,_ sizeY:CGFloat) -> Pane
        {
        self.layoutFrame(left:0,sizeX,top:0,sizeY,right:1,0,bottom:1,0)
        return(self)
        }
    
    //
    // layout lays out the pane it does NOT size it, panes are assigned
    // their size and location by their parent
    //
    public func layout()
        {
        }
        
    //
    // When this method is called as opposed to layout, the pane szes itself
    // according to whatever policy it has. The layout method does NOT self
    // size and should be called when externally assigned bounds are required.
    //
    public func layoutToFit()
        {
        self.bounds = NSRect(origin: .zero,size: self.measure())
        self.layout()
        }
    }
    



    


