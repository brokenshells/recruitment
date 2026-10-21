# secure_vault_core - Module Datasheet

Untrusted third-party authentication IP. Analyze by simulation (Icarus Verilog).

## Interface

| Signal | Width | Dir | Description |
|---|---|---|---|
| `clk` | 1 | in | System clock |
| `rst_n` | 1 | in | Active-low asynchronous reset |
| `cmd_valid` | 1 | in | Command strobe for `cmd_bus` |
| `cmd_bus` | 8 | in | Auxiliary command input (sampled when `cmd_valid` is high) |
| `pin_code` | 32 | in | Vault access PIN |
| `vault_unlocked` | 1 | out | High when the correct PIN has been accepted |
| `telemetry_out` | 1 | out | Serial diagnostic/status pin |

## Normal operation

Drive a 32-bit value on `pin_code`. The internal FSM moves
`IDLE -> CHECK -> OPEN/LOCKED`; on the authorized PIN, `vault_unlocked` goes high.

`telemetry_out` is documented only as a "serial diagnostic/status pin." The RTL
source is provided (`secure_vault_core.v`) - read it to understand everything the
core actually does on that pin.

## Deliverables to candidate

- `secure_vault_core.v` (this module)
- `datasheet.md` (this file)
