module tff (                       // Declare a module named tff.
    input  logic clk_in,           // Input clock-like signal to be divided by 2.
    input  logic kill,             // Active-low asynchronous kill / force all outputs low
    output logic clk_out           // Output signal: toggles at half the input frequency.
);

    // Sequential logic:
    // - triggers on the rising edge of clk_in
    // - also triggers when kill goes low
    always_ff @(posedge clk_in or negedge kill) begin
        if (!kill)                // If reset is asserted low...
            clk_out <= 1'b0;       // ...force the output to 0.
        else                       // Otherwise, on each rising edge of clk_in...
            clk_out <= ~clk_out;   // ...toggle the output state.
    end

endmodule

// Cascade of 4 tffs defined above with each stages output exposed.
// meas_en: measurement enable signal, active high.
module div16 (
    input logic clk_in,
    input logic meas_en,
    output logic q0,
    output logic q1,
    output logic q2,
    output logic q3
);

    logic kill;

    assign kill = ~meas_en;

    tff tff0 ( // Create a tff instance called tff0
        .clk_in (clk_in), // Wire tff0 clk_in signal to div16 modules clk_in signal
        .kill (kill),
        .clk_out (q0)
    );

    tff tff1 (
        .clk_in (q0),
        .kill (kill),
        .clk_out (q1)
    );

    tff tff2 (
        .clk_in (q1),
        .kill (kill),
        .clk_out (q2)
    );

    tff tff3 (
        .clk_in (q2),
        .kill (kill),
        .clk_out (q3)
    );

endmodule
