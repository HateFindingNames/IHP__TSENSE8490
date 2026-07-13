`timescale 1ns/1ps

module div16_tb;

    // Testbench signals
    logic clk_in;
    logic meas_en;
    logic q0;
    logic q1;
    logic q2;
    logic q3;

    // Instantiate DUT = Device Under Test
    div16 dut (
        .clk_in (clk_in),
        .meas_en (meas_en),
        .q0 (q0),
        .q1 (q1),
        .q2 (q2),
        .q3 (q3)
    );

    // Clock generation:
    // Toggle every 2.5 ns -> full period = 5 ns
    initial begin
        clk_in = 0;
        forever #2.5 clk_in = ~clk_in; // changes every 2.5ns
    end

    // Stimulus:
    // Apply reset, then release it, then let it run
    initial begin
        meas_en = 1;           // hold meas_en high
        #12;                   // wait 20ns
        meas_en = 0;           // set meas_en low
        #200;                // let simulation run for 100ns
        meas_en = 1;           // hold meas_en high again
        #12;                   // wait 20ns
        $finish;
    end

    // Simple monitoring in console
    initial begin
        $display("time\tclk_in\tmeas_en\tq0\tq1\tq2\tq3");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b", $time, clk_in, meas_en, q0, q1, q2, q3);
    end

    initial begin
        $dumpfile("sim/div16_tb.vcd");
        $dumpvars(0, div16_tb);
    end

endmodule
