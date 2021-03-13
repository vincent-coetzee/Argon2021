//
//  ArgonFramedView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public protocol Framed
    {
    var layoutFrame:LayoutFrame { get }
    }
    
public typealias FrameView = NSView & Framed

public class FramingView:OutlinerRowView
    {
    public var contentView:NSView?
        {
        didSet
            {
            if let view = self.contentView as? FrameView
                {
                self.addSubview(view)
                view.frame = view.layoutFrame.frame(in: self.bounds)
                }
            }
        }
    
    public override var frame:NSRect
        {
        get
            {
            return(super.frame)
            }
        set
            {
            super.frame = newValue
            self.contentView?.frame = self.bounds
            }
        }
        
    public override func layout()
        {
        super.layout()
        self.contentView?.frame = self.bounds
        }
    }


public class FrameContainerView:NSView
    {
    private var childViews:Array<FrameView> = []
    
    func addChildView(_ view:FrameView)
        {
        view.removeFromSuperview()
        view.removeConstraints(view.constraints)
        self.childViews.append(view)
        self.addSubview(view)
        view.frame = view.layoutFrame.frame(in:self.bounds)
        }
        
    public override func layout()
        {
        super.layout()
        let bounds = self.bounds
        for child in self.childViews
            {
            child.frame = child.layoutFrame.frame(in: bounds)
                print("view \(child) layoutFrame = \(child.layoutFrame.frame(in: bounds))")
            }
        }
        
    public func layout(inView:NSView)
        {
        let bounds = inView.bounds
        for child in self.childViews
            {
            child.frame = child.layoutFrame.frame(in: bounds)
            print("view \(child) layoutFrame = \(child.layoutFrame.frame(in: bounds))")
            }
        }
    }
