//
//  CGSize+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Foundation

extension CGSize
    {
    public func expandedBy(_ amount:CGFloat) -> CGSize
        {
        return(CGSize(width: self.width + 2 * amount,height: self.height + 2 * amount))
        }
    }
