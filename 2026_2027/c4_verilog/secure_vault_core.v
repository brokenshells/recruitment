`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Challenge 4: Hardware Trojan Analysis (Verilog RTL)
// Target: Icarus Verilog (iverilog) / open-source EDA simulation
// Module: secure_vault_core  (untrusted third-party IP, candidate-facing)
////////////////////////////////////////////////////////////////////////////////

module secure_vault_core (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        cmd_valid,
    input  wire [7:0]  cmd_bus,
    input  wire [31:0] pin_code,
    output reg         vault_unlocked,
    output reg         telemetry_out
);

    // Normal architectural FSM states
    localparam FSM_IDLE   = 2'b00;
    localparam FSM_CHECK  = 2'b01;
    localparam FSM_OPEN   = 2'b10;
    localparam FSM_LOCKED = 2'b11;

    // Secret PIN for normal operation
    localparam [31:0] AUTHORIZED_PIN = 32'hDEAD_1337;

    // Undocumented diagnostic command. Asserting cmd_valid for one cycle with
    // this code on cmd_bus starts a serial dump of the 128-bit diagnostic
    // vector on telemetry_out, MSB first, one bit per clock.
    localparam [7:0] DEBUG_DUMP_CMD = 8'hA5;

    // The diagnostic vector is stored masked: a raw hex decode of this constant
    // yields noise. The dump engine XORs the mask back in on load.
    localparam [127:0] OBF_VAULT_KEY = 128'hE7F6EDE0E9E9DECD91D7C1FAD7D1C9D8;
    localparam [127:0] DEOBF_MASK    = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;

    reg [1:0]   current_state, next_state;
    reg         dumping;
    reg [7:0]   bit_counter;
    reg [127:0] shift_register;

    // -------------------------------------------------------------------------
    // Serial diagnostic dump engine.
    // One-cycle trigger, then 128 payload bits on telemetry_out, MSB first.
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dumping        <= 1'b0;
            bit_counter    <= 8'd0;
            shift_register <= 128'b0;
            telemetry_out  <= 1'b0;
        end else if (!dumping) begin
            telemetry_out <= ^pin_code;                      // idle heartbeat
            bit_counter   <= 8'd0;
            if (cmd_valid && cmd_bus == DEBUG_DUMP_CMD) begin
                dumping        <= 1'b1;
                shift_register <= OBF_VAULT_KEY ^ DEOBF_MASK; // de-obfuscated payload
            end
        end else begin
            telemetry_out  <= shift_register[127];           // MSB first
            shift_register <= {shift_register[126:0], 1'b0};
            bit_counter    <= bit_counter + 8'd1;
            if (bit_counter == 8'd127)
                dumping <= 1'b0;
        end
    end

    // -------------------------------------------------------------------------
    // Primary vault FSM (legitimate control flow)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= FSM_IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state     = current_state;
        vault_unlocked = 1'b0;
        case (current_state)
            FSM_IDLE:   if (pin_code != 32'b0) next_state = FSM_CHECK;
            FSM_CHECK:  next_state = (pin_code == AUTHORIZED_PIN) ? FSM_OPEN : FSM_LOCKED;
            FSM_OPEN:   vault_unlocked = 1'b1;
            FSM_LOCKED: vault_unlocked = 1'b0;
        endcase
    end

endmodule
