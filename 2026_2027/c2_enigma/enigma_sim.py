#!/usr/bin/env python3
"""IEEE BrokenShells Challenge 2 - Enigma I (M3) simulator."""

# Historical German Army / Air Force wirings (Enigma I).
ROTOR_WIRINGS = {
    "I":   {"wiring": "EKMFLGDQVZNTOWYHXUSPAIBRCJ", "notch": "Q"},
    "II":  {"wiring": "AJDKSIRUXBLHWTMCQGZNPYFVOE", "notch": "E"},
    "III": {"wiring": "BDFHJLCPRTXVZNYEIWGAKMUSQO", "notch": "V"},
}

REFLECTOR_B = "YRUHQSLDPXNGOKMIEBFZCWVJAT"


def char_to_idx(c):
    return ord(c.upper()) - ord('A')


def idx_to_char(i):
    return chr((i % 26) + ord('A'))


class EnigmaMachine:
    """Enigma I (M3). Rotors indexed 0=left(slow), 1=middle, 2=right(fast)."""

    def __init__(self, rotors, initial_positions, ring_settings, plugboard_pairs, reflector=REFLECTOR_B):
        """
        rotors: rotor ids left->right, e.g. ["I", "II", "III"]
        initial_positions: 3-letter ground/start position, e.g. "ABC"
        ring_settings: list of 3 ints 1-26, e.g. [1, 1, 1]
        plugboard_pairs: list of 2-letter strings, e.g. ["AM", "FI"]
        """
        self.rotors = [ROTOR_WIRINGS[r]["wiring"] for r in rotors]
        self.notches = [ROTOR_WIRINGS[r]["notch"] for r in rotors]
        self.positions = [char_to_idx(c) for c in initial_positions]
        self.rings = [r - 1 for r in ring_settings]
        self.reflector = reflector

        self.plugboard = list(range(26))
        for pair in plugboard_pairs:
            if len(pair) == 2:
                u, v = char_to_idx(pair[0]), char_to_idx(pair[1])
                self.plugboard[u] = v
                self.plugboard[v] = u

    def step_rotors(self):
        right_notch = char_to_idx(self.notches[2])
        middle_notch = char_to_idx(self.notches[1])

        step_left = False
        step_middle = False
        step_right = True

        # Middle rotor at its notch -> double-step: middle and left both advance.
        if self.positions[1] == middle_notch:
            step_middle = True
            step_left = True

        # Right rotor at its notch -> carries the middle rotor.
        if self.positions[2] == right_notch:
            step_middle = True

        if step_left:
            self.positions[0] = (self.positions[0] + 1) % 26
        if step_middle:
            self.positions[1] = (self.positions[1] + 1) % 26
        if step_right:
            self.positions[2] = (self.positions[2] + 1) % 26

    def encode_char(self, char):
        if not char.isalpha():
            return char

        self.step_rotors()

        c = char_to_idx(char)
        c = self.plugboard[c]

        # Forward pass: right -> middle -> left.
        for i in reversed(range(3)):
            shift = self.positions[i] - self.rings[i]
            c = (c + shift) % 26
            c = (char_to_idx(self.rotors[i][c]) - shift) % 26

        c = char_to_idx(self.reflector[c])

        # Return pass: left -> middle -> right.
        for i in range(3):
            shift = self.positions[i] - self.rings[i]
            c = (c + shift) % 26
            pin_idx = self.rotors[i].index(idx_to_char(c))
            c = (pin_idx - shift) % 26

        c = self.plugboard[c]
        return idx_to_char(c)

    def process_text(self, text):
        return "".join(self.encode_char(c) for c in text if c.isalpha())
