//
//  RawMemory.h
//  ArgonInspector
//
//  Created by Vincent Coetzee on 2018/09/25.
//  Copyright © 2018 Vincent Coetzee. All rights reserved.
//

#ifndef RawMemory_h
#define RawMemory_h

int sharedMemoryOpen(const char* name);

typedef unsigned long long CWord;

typedef struct _Block
    {
    CWord   count;
    CWord   size;
    CWord   words[0];
    }
    Block;
    
typedef struct _ArgonClass
    {
    Block*  superclassesBlock;
    CWord   classPointer;
    Block*  slotsBlock;
    Block*  classSlotsBlock;
    }
    ArgonClass;
    
typedef struct _ArgonObject
    {
    ArgonClass* classPointer;
    CWord       words[0];
    }
    ArgonObject;
    
#define AllocateBlockOfSize(size) ((Block*)(malloc(sizeof(Block) + size*sizeof(CWord))))
    
#endif /* RawMemory_h */
