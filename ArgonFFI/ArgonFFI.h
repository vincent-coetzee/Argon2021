//
//  ArgonFFI.h
//  Argon
//
//  Created by Vincent Coetzee on 2018/09/25.
//  Copyright © 2018 Vincent Coetzee. All rights reserved.
//

#ifndef ArgonFFI_h
#define ArgonFFI_h

typedef unsigned long long CWord;

void PushWord(CWord word);
void CallAddress(CWord address);
void VoidFunction();
CWord VoidFunctionAddress();

#endif /* ArgonFFI_h */
