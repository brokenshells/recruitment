###############################################################################
# Challenge: IEEE BrokenShells Recruitment - MIPS 
# Target: MARS (MIPS Assembly and Runtime Simulator)
# Architecture: MIPS32 Little-Endian
###############################################################################

.data
banner:         .asciiz "\n============================================\n[+] IEEE BrokenShells - Core Access Portal\n============================================\n"
prompt:         .asciiz "Enter Authentication Token: "
denied_msg:     .asciiz "\n[-] ACCESS DENIED.\n"
granted_msg:    .asciiz "\n[+] Access granted.\n"
flag_banner:    .asciiz "[*] FLAG: "
flag_data:      .asciiz "BSHELL{f@k3_f1ag}\n"

.text
.globl main

main:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)

    # Print portal banner
    li      $v0, 4
    la      $a0, banner
    syscall

    # Invoke authentication subroutine
    jal     verify_portal_access

    # Exit cleanly
    lw      $ra, 0($sp)
    addiu   $sp, $sp, 4
    li      $v0, 10
    syscall

# -----------------------------------------------------------------------------
# Function: verify_portal_access
# -----------------------------------------------------------------------------
verify_portal_access:
    addiu   $sp, $sp, -32       # Allocate 32-byte frame
    sw      $ra, 28($sp)        # Save return address

    sw      $zero, 16($sp)      # auth_word = 0x00000000

    # Prompt user for input
    li      $v0, 4
    la      $a0, prompt
    syscall

    move    $a0, $sp            # Destination buffer pointer
    li      $a1, 32             # Read up to 31 bytes + NULL terminator
    li      $v0, 8              # Syscall 8: read string
    syscall

    lw      $t1, 16($sp)        # auth_word

    bne     $t1, $zero, access_granted

auth_failed:
    li      $v0, 4
    la      $a0, denied_msg
    syscall
    j       portal_exit

access_granted:
    li      $v0, 4
    la      $a0, granted_msg
    syscall

    li      $v0, 4
    la      $a0, flag_banner
    syscall

    li      $v0, 4
    la      $a0, flag_data
    syscall

portal_exit:
    lw      $ra, 28($sp)        # Restore return address
    addiu   $sp, $sp, 32        # Reclaim stack frame
    jr      $ra                 # Return to main caller
