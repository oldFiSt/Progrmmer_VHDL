//
//  schoolRISCV - small RISC-V CPU
//
//  Originally based on Sarah L. Harris MIPS CPU
//  & schoolMIPS project.
//
//  Copyright (c) 2017-2020 Stanislav Zhelnio & Aleksandr Romanov.
//
//  Modified in 2024 by Yuri Panchul & Mike Kuskov
//  for systemverilog-homework project.
//

module cpu_cluster
#(
    parameter nCPUs = 3
)
(
    input                        clk,      // clock
    input                        rst,      // reset

    input   [nCPUs - 1:0][31:0]  rstPC,    // program counter set on reset
    input   [nCPUs - 1:0][ 4:0]  regAddr,  // debug access reg address
    output  [nCPUs - 1:0][31:0]  regData   // debug access reg data
);

    // ----------------------------
    // CPU <-> instruction memory
    // ----------------------------

    logic [nCPUs - 1:0][31:0] imAddr;
    logic [nCPUs - 1:0][31:0] imData;
    logic [nCPUs - 1:0]       imDataVld;

    // ----------------------------
    // Arbiter
    // ----------------------------

    logic [7:0] req;
    logic [7:0] gnt;

    always_comb
    begin
        req = 8'b0;
        for (int i = 0; i < nCPUs; i++)
            req[i] = 1'b1; // every CPU always requests next instruction
    end

    round_robin_arbiter_8 arbiter
    (
        .clk ( clk ),
        .rst ( rst ),
        .req ( req ),
        .gnt ( gnt )
    );

    // ----------------------------
    // Shared instruction ROM
    // ----------------------------

    logic [31:0] romAddr;
    logic [31:0] romData;

    always_comb
    begin
        romAddr = 32'b0;

        for (int i = 0; i < nCPUs; i++)
            if (gnt[i])
                romAddr = imAddr[i];
    end

    instruction_rom rom
    (
        .a  ( romAddr[$clog2(64)-1:0] ),
        .rd ( romData                  )
    );

    // Broadcast ROM data to all CPUs,
    // but valid only for the granted CPU

    always_comb
    begin
        for (int i = 0; i < nCPUs; i++)
        begin
            imData[i]    = romData;
            imDataVld[i] = gnt[i];
        end
    end

    // ----------------------------
    // CPU instances
    // ----------------------------

    genvar j;
    generate
        for (j = 0; j < nCPUs; j++) begin : gen_cpu
            sr_cpu cpu
            (
                .clk       ( clk         ),
                .rst       ( rst         ),
                .rstPC     ( rstPC[j]    ),
                .imAddr    ( imAddr[j]   ),
                .imData    ( imData[j]   ),
                .imDataVld ( imDataVld[j]),
                .regAddr   ( regAddr[j]  ),
                .regData   ( regData[j]  )
            );
        end
    endgenerate

endmodule