            processor 6502
            include "vcs.h"

            seg Code
            org $f000

Start       sei         ; disable interrupts
            cld         ; disable BCD mode
            ldx #$ff    ; init stack pointer
            txs

            lda #$00    ; clear zero-page area
            ldx #$ff
ZeroMem     sta $00,x
            dex
            bne ZeroMem
            sta $00     ; loop doesn't cover address $00

            lda #$30    ; set background color
            sta COLUBK

            jmp Start   ; jump back, no vertical sync
                        ; logic, see alternating
                        ; red and black lines
            
            seg Vectors
            org $fffa

            dc.w Start  ; NMI vector (unused)
            dc.w Start  ; reset vector
            dc.w Start  ; IRQ vector (unused)
