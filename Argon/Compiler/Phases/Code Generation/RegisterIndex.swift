//
//  Register.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/21.
//

import Foundation

public enum RegisterIndex:Int
    {
    case none = 0
    case rr = 1 // return value
    //
    // When a pointer that is tagged as a string is loaded in
    // a character pointer register, the offset of the actual
    // bytes in the strin is loaded into the index register. That
    // means that operations done to the strijng end up being done
    // directly to the bytes pointed to by the index pointer.
    //
    case cp0 // char pointer 0
    case ci0 // char index 0
    case cp1 // char pointer 1
    case ci1 // char index 1
    case cp2 // char pointer 2
    case ci2 // char index 2
    case cp3 // char pointer 3
    case ci3 // char index 3
    //
    // When a call is made to call a function or a method
    // all the registers that are used aare flushed to RAM
    // and a pointer to the flushed window is loaded into
    // wr. This is so that routines can get at values from
    // previous stack frames if needed
    //
    case wr  // pointer to top of window in RAM
    case bp  // base pointer
    case sp  // stack pointer
    case ip  // instruction pointer
    case ss  // stack segment
    case ds  // data segment
    case ms  // memory pointer to next object
    case xs  // static segment pointer
    case cs  // code segment pointer cs:ip work as a pair as ss:sp
    case flags // flags when instructions generate them
    case r0  // general purpose register 0
    case r1
    case r2
    case r3
    case r4
    case r5
    case r6
    case r7
    case r8
    case r9
    case r10
    case r11
    case r12
    case r13
    case r14
    case r15
    case r16
    case r17
    case r18
    case r19
    case r20
    case r21
    case r22
    case r23
    case r24
    case r25
    case r26
    case r27
    case r28
    case r29
    case r30
    case r31
    case fr0 // floating point register 0
    case fr1
    case fr2
    case fr3
    case fr4
    case fr5
    case fr6
    case fr7
    case fr8
    case fr9
    case fr10
    case fr11
    case fr12
    case fr13
    case fr14
    case fr15
    case fr16
    case fr17
    case fr18
    case fr19
    case fr20
    case fr21
    case fr22
    case fr23
    case fr24
    case fr25
    case fr26
    case fr27
    case fr28
    case fr29
    case fr30
    case fr31
    }
