; Autor reseni: Andrii Klymenko xklyme00
; Pocet cyklu k serazeni puvodniho retezce: 2650
; Pocet cyklu razeni sestupne serazeneho retezce: 2917
; Pocet cyklu razeni vzestupne serazeneho retezce: 422
; Pocet cyklu razeni retezce s vasim loginem: 631
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
login:          .asciiz "xklyme00"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        
        daddi r20, r0, 0 ; r20 = 0, r20 will contain string length
loop1:
        lb r21, login(r20) ; r21 = login[r20], load the character from the string
        beq r21, r0, end1 ; if(r21 == '\0'), if the character is '\0', break a loop

        daddi r20, r20, 1 ; r20++, increment string length
        j loop1 ; loop again

end1:
        beqz r20, end2
        daddi r22, r0, 1
        dsub r20, r20, r22 ; r20--, r20 will contain string length - 1
        daddi r22, r0, 0 ; r22 (i) = 0, r22 will contain i index

loop2:        
        beq r22, r20, end2 ; if(i == string_length - 1) break a loop
        daddi r23, r0, 0 ; r23 = false, r23 will contain boolean swapped

        daddi r24, r0, 0 ; r24 (j) = 0
        dsubu r25, r20, r22 ; r25 = string length - 1 - i

        inner_loop:
                
                beq r24, r25, inner_loop_end ; if(j == string_length - 1 - i)

                daddi r26, r24, 1 ; r26 = j + 1
                lb r27, login(r24) ; r27 = login[j]
                lb r28, login(r26) ; r28 = login[j + 1]

                slt r29, r28, r27 ; slt = login[j + 1] < login[j]

                beqz r29, increment ; if(login[j + 1] >= login[j])

                ; if(login[j + 1] < login[j]) => need to swap values
                sb r27, login(r26) ; login[j + 1] = login[j]
                sb r28, login(r24) ; login[j] = login[j + 1]
                daddi r23, r0, 1 ; swapped = true;

                increment:
                        daddi r24, r24, 1 ; j++
                        j inner_loop ; loop again

        inner_loop_end:

        beqz r23, end2 ; if(!swapped)

        daddi r22, r22, 1
        j loop2

end2:
        daddi   r4, r0, login   ; vozrovy vypis: adresa login: do r4
        jal     print_string    ; vypis pomoci print_string - viz nize

        syscall 0   ; halt


print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
