//
//  ComposingRowPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/01.
//

import Cocoa

public protocol EdgeRenderer
    {
    func renderBorder(edge:PaneEdge,into:NSBezierPath,container:Pane,style:PaneStyle)
    }
    
public class ComposingRowPane:RowPane
    {
    private var padding:CGFloat = 10
    
    override init()
        {
        super.init()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public override func addKid(_ kid:Pane)
        {
        fatalError("Use addKid(_ kid:EdgeGenerationPane)")
        }
        
    public func addKid(_ kid:EdgeRenderer & Pane)
        {
        super.addKid(kid)
        }
        
    public override func layout()
        {
        let path = NSBezierPath()
        self.kids.first?.layout()
        (self.kids.first as? EdgeRenderer)?.renderBorder(edge: .top,into:path,container: self,style:StylePalette.shared.paneStyle)
        let middle = (Array(self.kids[1..<self.kids.count]) as! Array<EdgeRenderer & Pane>)
        for kid in middle
            {
            kid.layout()
            kid.renderBorder(edge: PaneEdge.sides,into:path,container: self,style:StylePalette.shared.paneStyle)
            }
        self.kids.last?.layout()
        (self.kids.last as? EdgeRenderer)?.renderBorder(edge:.bottom,into:path,container:self,style:StylePalette.shared.paneStyle)
        }
    }
