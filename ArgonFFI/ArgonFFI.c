//
//  ArgonFFI.c
//  Argon
//
//  Created by Vincent Coetzee on 2018/09/25.
//  Copyright © 2018 Vincent Coetzee. All rights reserved.
//

#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#import "ArgonFFI.h"

void PushWord(CWord word)
    {
    asm("push %(word)");
    }

void CallAddress(CWord address)
    {
    asm("call %(address)")
    }
    
void VoidFunction()
    {
    printf("Void function called");
    }
    
CWord VoidFunctionAddress()
    {
    return((CWord)VoidFunction)
    }
