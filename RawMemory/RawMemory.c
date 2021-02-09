//
//  SharedMemory.c
//  ArgonInspector
//
//  Created by Vincent Coetzee on 2018/09/25.
//  Copyright © 2018 Vincent Coetzee. All rights reserved.
//

#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#import "RawMemory.h"

int sharedMemoryOpen(const char* name)
    {
    return(shm_open(name, O_RDWR | O_CREAT , 0700));
    }
