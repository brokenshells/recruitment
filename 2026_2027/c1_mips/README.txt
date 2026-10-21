IEEE BrokenShells - Challenge 1: Core Access Portal
Category: Binary Exploitation (MIPS / MARS)

auth_overflow.asm is a MIPS program for the MARS simulator. It asks for an
"Authentication Token" and, by default, denies access. Your job is to make it
grant access.

Run it on your own computer:
    1. Open auth_overflow.asm in MARS (File > Open).
    2. Assemble it (Run > Assemble, or the wrench icon).
    3. Run it (Run > Go, or the green play icon).
    4. Type your token in the Run I/O panel at the bottom and press Enter.

There is no server for this challenge, so the flag inside the file is a
placeholder and there is no flag to submit. Instead, send a writeup that
explains:
    * what the bug is
    * what sits in memory next to the input buffer
    * which input grants access, and why it works
and add a screenshot of MARS showing access granted.

Hint: think about what happens to memory next to a fixed-size input buffer.
