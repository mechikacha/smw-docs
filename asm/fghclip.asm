; smw defines
!playerxpos     = $0094
!util_axlr      = $0da4
!util_byetudlr  = $0da6

; added defines
!f_select       = $58 ; empty
!f_jump         = $5c ; empty
!jumpframe      = $60 ; empty

!pos_sel        = $0061

; unused: hijack
;    org $00a182 ; gm14hijack
;                jsl main
;                lda #$00
;                bra $14

; hex edits
    org $009c42
            lda #$00

    org $009dd3
        jsr powerups
        nop #2

    org $009de6
        nop #3

    org $009e8e ; submap id
            db $03, $03

    org $009e94 ; overworld position
            dw $0068, $0178, $0068, $0178
            dw $0006, $0017, $0006, $0017

; powerups hack
    org $00ff30
    powerups:
        lda #$02
        sta $19
        lda #$04
        sta $0dc2
        rts

; unused: main
    org $03D6AC ; unused
    main:
            lda !f_select
            cmp #$01
            beq +
            lda $95
            cmp #$01 
            bne .done ; runs only if players are in "clip-able" area
            lda !util_byetudlr
            and #%00100000
            cmp #%00100000
            bne .done
            lda #$01
            sta !f_select

            rep #$20
            lda !playerxpos
            sta !pos_sel

          + lda !f_jump
            cmp #$01
            beq .done
            inc !jumpframe
            lda !util_axlr
            and #%10000000
            cmp #%10000000
            bne .done 
            lda #$01
            sta !f_jump
        .done:
            rtl
