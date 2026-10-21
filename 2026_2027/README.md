# IEEE BrokenShells 2026/2027 Recruitment Challenges

Welcome to the BrokenShells recruitment challenge set. Each task is self-contained and can be solved on its own. The point is real problem solving, so work it out yourself and keep notes on your approach (these tasks reward actual engineering even if you use an LLM, provide the whole conversation in your report, and your writeup matters as much as the code).

## Getting the Files

You don't need git. Go to the main page of the repository (https://github.com/brokenshells/recruitment), click the green **Code** button, then **Download ZIP**. Unzip it anywhere on your computer and open the `2026_2027` folder. Each challenge has its own folder (`c1_mips`, `c2_enigma`, `c3_osint`, `c4_verilog`, `c5_spice`).

If you already use git:

```
git clone https://github.com/brokenshells/recruitment.git
```

The challenges are then in `recruitment/2026_2027`.

## Setup

You only need the tools for the challenges you pick.

- **Python 3** (B, E): install it from https://www.python.org/downloads/ (on Windows, tick "Add python.exe to PATH" in the installer). For E, also run `pip install numpy scipy` in a terminal.
- **MARS** (A): it runs on Java, so install Java first from https://adoptium.net/. Then download `Mars4_5.jar` from https://computerscience.missouristate.edu/mars-mips-simulator.htm and open it by double clicking, or with `java -jar Mars4_5.jar`.
- **Icarus Verilog and GTKWave** (D): on Windows use the installer from https://bleyer.org/icarus/ (it includes GTKWave). On Linux: `sudo apt install iverilog gtkwave`. On macOS: `brew install icarus-verilog`.
- **ngspice** (E): on Windows download it from https://ngspice.sourceforge.io/download.html. On Linux: `sudo apt install ngspice`. On macOS: `brew install ngspice`.
- **A web browser** (C): nothing to install.

## Answer Format

Every answer is a short code which is called a flag:

```
BSHELL{...}
```

- The format is case-sensitive.
- When a task gives you letters or digits to recover, wrap exactly what you recover: `BSHELL{recovered_text}`.
- If you don't find the whole flag but only a part of it, or if you are unsure send your findings either way.
- Challenge A is the exception: there is no flag to submit, only a writeup (see its section below).

**Submission: ieee_uth_ehacking@protonmail.com**

## Writeups

A writeup is a short report of how you solved (or tried to solve) a challenge, written so that someone else could follow your steps and get the same result. It is the most important part of your submission: we care more about how you think than about the flag itself.

For each challenge you attempt, include:

- **What you understood** from the files and what you tried first.
- **The steps that worked**, in order: the commands you ran, the code you wrote, the tools you used. Screenshots help.
- **Dead ends**: what didn't work and why you moved on. These count too.
- **The result**: the flag, or how far you got if you didn't reach it.
- **Your LLM conversation**, in full, if you used one.

Any format is fine (PDF, Markdown, Word). Clear and simple beats fancy. Attach any code or scripts you wrote.

The best writeups for each challenge will be published in this repository, with credit to their authors (we'll ask you first).

## Challenges

### A) Smashing the Stack

- **Field:** low-level systems / MIPS assembly
- **Files:** `README.txt` (short brief with steps to run it) and `auth_overflow.asm` (the program)
- **Tools:** the MARS MIPS simulator (see Setup)

A small MIPS program asks for a token and normally refuses access. There is a subtle mistake in how it handles the input you send. Run it in MARS on your own computer and work out how your input affects the program's memory so that it grants access.

There is no server for this challenge, so the flag inside the file is a placeholder and you don't submit a flag. Your answer is the writeup: explain the bug, what sits in memory next to the input, which input grants access and why it works. Add a screenshot of MARS showing access granted.

### B) Bletchley Park

- **Field:** cryptography
- **Files:** `challenge.txt` (the intercepted message plus the full machine configuration) and `enigma_sim.py` (a working Python model of the historical Enigma I rotor cipher machine)
- **Tools:** Python 3

You are given one enciphered message and the complete machine settings used to produce it. Use the provided Python model with those settings to turn the message back into readable text, then read the code out of the recovered text. Note: this historical machine only handles the letters A to Z, so the recovered text spells the answer in letters.

### C) GeoGuessr

- **Field:** osint
- **Files:** `challenge.txt` (the challenge description, questions you'll need to answer and the flag format) and `photo.jpg` (open it and see)
- **Tools:** Google

You are given one scenario and a photo of a place in Volos. You need to use online tools like Google Maps or something more useful to answer questions of this photo. Answering them will create the flag.

### D) Verilog Vault

- **Field:** digital hardware / Verilog RTL
- **Files:** `secure_vault_core.v` (a hardware module written in Verilog) and `datasheet.md` (its signal interface)
- **Tools:** Icarus Verilog (`iverilog` and `vvp`). GTKWave is useful for viewing waveforms

You receive an unfamiliar hardware module. Reading the source reveals an undocumented diagnostic command that, when driven correctly, sends a hidden value out one of the pins one bit at a time. Write your own small simulation (a testbench) to drive the module, capture that serial output over the right number of clock cycles, and reassemble it into the answer.

### E) Predator

- **Field:** analog electronics / signals
- **Files:** `carrier.wav` (an audio recording) and `analog_filter.cir` (a SPICE netlist of an analog filter)
- **Tools:** ngspice (for the netlist) and Python with numpy/scipy (for the audio). Any approach that applies the filter works

The recording carries a short sequence of telephone-style tones, but a strong interfering tone sits on top of them, so a plain tone decoder reads it wrong. Study what the provided filter does, apply it to clean up the recording, then decode the tones into the answer. The filter is not optional here (you need it to get a correct reading).

## General Notes

- Tasks are independent and can be done in any order.
- Try to solve as many as possible but it's okay to skip some but give your thoughts on the report.
- Remember the answer format: `BSHELL{...}`.

Good luck, and hack (ethically).
