            processor 6502
            include "vcs.h"
            include "macro.h"

            seg.u Data
            org $80

Counter     ds.b 1

            seg Code
            org $f000

Start       CLEAN_START

NextFrame   VERTICAL_SYNC

            ldx #36         ; 36 lines of VBLANK
LVBlank     sta WSYNC
            dex
            bne LVBlank

            SLEEP 20        ; 20 cycle delay
            sta RESP0       ; set position of player 0
            SLEEP 35        ; 35 cycle delay
            sta RESP1       ; set position of player 1

            ldx #192        ; 192 visible scanlines
            lda #0
            ldy Counter
            
ScanLoop    sta WSYNC
            sta COLUBK      ; set background color
            sta GRP0        ; set player 0 bitmap
            sta GRP1        ; set player 1 bitmap
            adc #1
            dex
            bne ScanLoop

            stx COLUBK      ; clear background color
            stx GRP0        ; clear sprite bitmaps
            stx GRP1

            ldx #30         ; 30 lines of overscan
LVOver      sta WSYNC
            dex
            bne LVOver

            inc Counter     ; cycle sprint colors for next frame
            lda Counter
            sta COLUP0
            sta COLUP1

            jmp NextFrame

            seg Vectors
            org $fffa

            dc.w Start
            dc.w Start
            dc.w Start
