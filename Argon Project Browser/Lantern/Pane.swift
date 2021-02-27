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
    internal var layoutFrame = LayoutFrame.zero
        
    internal var parentPane:Pane?
        
    public override init()
        {
        super.init()
        self.initBorderStyle()
        self.initShadowStyle()
        self.initMasking()
        self.initGrounds()
        self.removeAllAnimations()
        }
    
    internal func initGrounds()
        {
        // set backGROUND
        // set foreGROUND
        }
    internal func initMasking()
        {
        self.masksToBounds = true
        }
        
    internal func initShadowStyle()
        {
        self.shadowColor = StylePalette.kShadowColor.cgColor
        self.shadowRadius = StylePalette.kShadowRadius
        self.shadowOffset = StylePalette.kShadowOffset
        }
        
    internal func initBorderStyle()
        {
        self.cornerRadius = StylePalette.kCornerRadius
        self.borderWidth = StylePalette.kBorderWidth
        self.borderColor = StylePalette.kPrimaryBorderColor.cgColor
        }
        
    public override init(layer:Any)
        {
        super.init(layer: layer)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func measure() -> CGSize
        {
        return(CGSize.defaultPaneSize.expandedBy(StylePalette.kPaneBorderWidth))
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
    
    public func layout()
        {
        }
    }
    



    


