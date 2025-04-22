            processor 6502

            include "vcs.h"
            
            seg Code
            org $f000

Start       sei         ;disable interrupts
            cld         ;disable BCD mode
            ldx #$ff    ; init stack pointer
            txs

            lda #$00    ;Clear zero page area
Zero        sta $00,x   ;Clear byte at offset x
            dex         ;decrement x reg
            bne Zero    ;loop back until
            sta $00     ;clear final byte

            lda #$30    ;load deep red color
            sta COLUBK  ;set background color

            jmp Start   ;loop back and start again

            seg Vectors
            org $fffa

            dc.w Start  ;NMI vector
            dc.w Start  ;Reset vector
            dc.w Start  ;IRQ vector
