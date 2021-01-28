//
//  Break.m
//  Argon
//
//  Created by Vincent Coetzee on 2020/09/25.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

#import "Break.h"

@implementation Break

- (void) callDebugger
    {
    asm("int3");
    }
    
@end
