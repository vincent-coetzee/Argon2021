//
//  OutlinerRowView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/09.
//

import Cocoa

public class OutlinerRowView:NSView
    {
    private var views = Array<Framed & NSView>()
    
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        }
        
    init()
        {
        super.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addFramedView(_ view:NSView & Framed)
        {
        self.views.append(view)
        self.addSubview(view)
        }
        
    public override func layout()
        {
        super.layout()
        let theBounds = self.bounds
        for view in self.views
            {
            view.frame = view.layoutFrame.frame(in:theBounds)
            }
        }
}
