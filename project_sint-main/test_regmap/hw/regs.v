// Created with Corsair v1.0.4

module regs #(
    parameter ADDR_W = 16,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // TEST_RW_0.data
    output [31:0] csr_test_rw_0_data_out,

    // TEST_RW_1.data
    output [31:0] csr_test_rw_1_data_out,

    // TEST_RW_2.data
    output [31:0] csr_test_rw_2_data_out,

    // TEST_RW_3.data
    output [31:0] csr_test_rw_3_data_out,

    // TEST_RW_4.data
    output [31:0] csr_test_rw_4_data_out,

    // TEST_RW_5.data
    output [31:0] csr_test_rw_5_data_out,

    // TEST_RW_6.data
    output [31:0] csr_test_rw_6_data_out,

    // TEST_RW_7.data
    output [31:0] csr_test_rw_7_data_out,

    // TEST_RW_8.data
    output [31:0] csr_test_rw_8_data_out,

    // TEST_RW_9.data
    output [31:0] csr_test_rw_9_data_out,

    // TEST_RW_10.data
    output [31:0] csr_test_rw_10_data_out,

    // TEST_RW_11.data
    output [31:0] csr_test_rw_11_data_out,

    // TEST_RW_12.data
    output [31:0] csr_test_rw_12_data_out,

    // TEST_RW_13.data
    output [31:0] csr_test_rw_13_data_out,

    // TEST_RW_14.data
    output [31:0] csr_test_rw_14_data_out,

    // TEST_RW_15.data
    output [31:0] csr_test_rw_15_data_out,

    // TEST_W_0.data
    output [31:0] csr_test_w_0_data_out,

    // TEST_W_1.data
    output [31:0] csr_test_w_1_data_out,

    // TEST_W_2.data
    output [31:0] csr_test_w_2_data_out,

    // TEST_W_3.data
    output [31:0] csr_test_w_3_data_out,

    // TEST_W_4.data
    output [31:0] csr_test_w_4_data_out,

    // TEST_W_5.data
    output [31:0] csr_test_w_5_data_out,

    // TEST_W_6.data
    output [31:0] csr_test_w_6_data_out,

    // TEST_W_7.data
    output [31:0] csr_test_w_7_data_out,

    // TEST_W_8.data
    output [31:0] csr_test_w_8_data_out,

    // TEST_W_9.data
    output [31:0] csr_test_w_9_data_out,

    // TEST_W_10.data
    output [31:0] csr_test_w_10_data_out,

    // TEST_W_11.data
    output [31:0] csr_test_w_11_data_out,

    // TEST_W_12.data
    output [31:0] csr_test_w_12_data_out,

    // TEST_W_13.data
    output [31:0] csr_test_w_13_data_out,

    // TEST_W_14.data
    output [31:0] csr_test_w_14_data_out,

    // TEST_W_15.data
    output [31:0] csr_test_w_15_data_out,

    // TEST_R_0.data
    input [31:0] csr_test_r_0_data_in,

    // TEST_R_1.data
    input [31:0] csr_test_r_1_data_in,

    // TEST_R_2.data
    input [31:0] csr_test_r_2_data_in,

    // TEST_R_3.data
    input [31:0] csr_test_r_3_data_in,

    // TEST_R_4.data
    input [31:0] csr_test_r_4_data_in,

    // TEST_R_5.data
    input [31:0] csr_test_r_5_data_in,

    // TEST_R_6.data
    input [31:0] csr_test_r_6_data_in,

    // TEST_R_7.data
    input [31:0] csr_test_r_7_data_in,

    // TEST_R_8.data
    input [31:0] csr_test_r_8_data_in,

    // TEST_R_9.data
    input [31:0] csr_test_r_9_data_in,

    // TEST_R_10.data
    input [31:0] csr_test_r_10_data_in,

    // TEST_R_11.data
    input [31:0] csr_test_r_11_data_in,

    // TEST_R_12.data
    input [31:0] csr_test_r_12_data_in,

    // TEST_R_13.data
    input [31:0] csr_test_r_13_data_in,

    // TEST_R_14.data
    input [31:0] csr_test_r_14_data_in,

    // TEST_R_15.data
    input [31:0] csr_test_r_15_data_in,

    // AXI
    input  [ADDR_W-1:0] axil_awaddr,
    input  [2:0]        axil_awprot,
    input               axil_awvalid,
    output              axil_awready,
    input  [DATA_W-1:0] axil_wdata,
    input  [STRB_W-1:0] axil_wstrb,
    input               axil_wvalid,
    output              axil_wready,
    output [1:0]        axil_bresp,
    output              axil_bvalid,
    input               axil_bready,

    input  [ADDR_W-1:0] axil_araddr,
    input  [2:0]        axil_arprot,
    input               axil_arvalid,
    output              axil_arready,
    output [DATA_W-1:0] axil_rdata,
    output [1:0]        axil_rresp,
    output              axil_rvalid,
    input               axil_rready
);
wire              wready;
wire [ADDR_W-1:0] waddr;
wire [DATA_W-1:0] wdata;
wire              wen;
wire [STRB_W-1:0] wstrb;
wire [DATA_W-1:0] rdata;
wire              rvalid;
wire [ADDR_W-1:0] raddr;
wire              ren;
    reg [ADDR_W-1:0] waddr_int;
    reg [ADDR_W-1:0] raddr_int;
    reg [DATA_W-1:0] wdata_int;
    reg [STRB_W-1:0] strb_int;
    reg              awflag;
    reg              wflag;
    reg              arflag;
    reg              rflag;

    reg              axil_bvalid_int;
    reg [1:0]        axil_bresp_int;
    reg [DATA_W-1:0] axil_rdata_int;
    reg              axil_rvalid_int;
    reg [1:0]        axil_rresp_int;

    // Проверка валидности адресов (AXI-Lite: 0=OKAY, 1=EXOKAY, 2=SLVERR, 3=DECERR)
    // Валидные адреса записи: 0x00..0x7C (TEST_RW_0..15, TEST_W_0..15), выровнены по 4 байта
    // Валидные адреса чтения: 0x00..0xBC (TEST_RW, TEST_W, TEST_R_0..15)
    wire waddr_valid = (waddr_int <= 16'h7C) && (waddr_int[1:0] == 2'b00);
    wire raddr_valid = (raddr_int <= 16'hBC) && (raddr_int[1:0] == 2'b00);

    assign axil_awready = ~awflag;
    assign axil_wready  = ~wflag;
    assign axil_bvalid  = axil_bvalid_int;
    assign axil_bresp   = axil_bresp_int;
    assign waddr        = waddr_int;
    assign wdata        = wdata_int;
    assign wstrb        = strb_int;
    assign wen          = awflag && wflag;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            waddr_int       <= 'd0;
            wdata_int       <= 'd0;
            strb_int        <= 'd0;
            awflag          <= 1'b0;
            wflag           <= 1'b0;
            axil_bvalid_int <= 1'b0;
            axil_bresp_int  <= 2'b00;
        end else begin
            if (axil_awvalid == 1'b1 && awflag == 1'b0) begin
                awflag    <= 1'b1;
                waddr_int <= axil_awaddr;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                awflag    <= 1'b0;
            end

            if (axil_wvalid == 1'b1 && wflag == 1'b0) begin
                wflag     <= 1'b1;
                wdata_int <= axil_wdata;
                strb_int  <= axil_wstrb;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                wflag     <= 1'b0;
            end

            if (axil_bvalid_int == 1'b1 && axil_bready == 1'b1) begin
                axil_bvalid_int <= 1'b0;
            end else if ((axil_wvalid == 1'b1 && awflag == 1'b1) || (axil_awvalid == 1'b1 && wflag == 1'b1) || (wflag == 1'b1 && awflag == 1'b1)) begin
                axil_bvalid_int <= wready;
                axil_bresp_int  <= waddr_valid ? 2'b00 : 2'b10;  // OKAY или SLVERR
            end
        end
    end

    assign axil_arready = ~arflag;
    assign axil_rdata   = axil_rdata_int;
    assign axil_rvalid  = axil_rvalid_int;
    assign axil_rresp   = axil_rresp_int;
    assign raddr        = raddr_int;
    assign ren          = arflag && ~rflag;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            raddr_int       <= 'd0;
            arflag          <= 1'b0;
            rflag           <= 1'b0;
            axil_rdata_int  <= 'd0;
            axil_rvalid_int <= 1'b0;
            axil_rresp_int  <= 2'b00;
        end else begin
            if (axil_arvalid == 1'b1 && arflag == 1'b0) begin
                arflag    <= 1'b1;
                raddr_int <= axil_araddr;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                arflag    <= 1'b0;
            end

            if (rvalid == 1'b1 && ren == 1'b1 && rflag == 1'b0) begin
                rflag <= 1'b1;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                rflag <= 1'b0;
            end

            if (rvalid == 1'b1 && axil_rvalid_int == 1'b0) begin
                axil_rdata_int  <= rdata;
                axil_rvalid_int <= 1'b1;
                axil_rresp_int  <= raddr_valid ? 2'b00 : 2'b10;  // OKAY или SLVERR
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                axil_rvalid_int <= 1'b0;
            end
        end
    end

//------------------------------------------------------------------------------
// CSR:
// [0x0] - TEST_RW_0 - Test register RW 0
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_0_rdata;

wire csr_test_rw_0_wen;
assign csr_test_rw_0_wen = wen && (waddr == 16'h0);

wire csr_test_rw_0_ren;
assign csr_test_rw_0_ren = ren && (raddr == 16'h0);
reg csr_test_rw_0_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_0_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_0_ren_ff <= csr_test_rw_0_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_0[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_0_data_ff;

assign csr_test_rw_0_rdata[31:0] = csr_test_rw_0_data_ff;

assign csr_test_rw_0_data_out = csr_test_rw_0_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_0_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_0_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_0_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_0_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_0_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_0_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_0_data_ff <= csr_test_rw_0_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4] - TEST_RW_1 - Test register RW 1
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_1_rdata;

wire csr_test_rw_1_wen;
assign csr_test_rw_1_wen = wen && (waddr == 16'h4);

wire csr_test_rw_1_ren;
assign csr_test_rw_1_ren = ren && (raddr == 16'h4);
reg csr_test_rw_1_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_1_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_1_ren_ff <= csr_test_rw_1_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_1[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_1_data_ff;

assign csr_test_rw_1_rdata[31:0] = csr_test_rw_1_data_ff;

assign csr_test_rw_1_data_out = csr_test_rw_1_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_1_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_1_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_1_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_1_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_1_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_1_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_1_data_ff <= csr_test_rw_1_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8] - TEST_RW_2 - Test register RW 2
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_2_rdata;

wire csr_test_rw_2_wen;
assign csr_test_rw_2_wen = wen && (waddr == 16'h8);

wire csr_test_rw_2_ren;
assign csr_test_rw_2_ren = ren && (raddr == 16'h8);
reg csr_test_rw_2_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_2_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_2_ren_ff <= csr_test_rw_2_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_2[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_2_data_ff;

assign csr_test_rw_2_rdata[31:0] = csr_test_rw_2_data_ff;

assign csr_test_rw_2_data_out = csr_test_rw_2_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_2_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_2_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_2_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_2_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_2_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_2_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_2_data_ff <= csr_test_rw_2_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc] - TEST_RW_3 - Test register RW 3
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_3_rdata;

wire csr_test_rw_3_wen;
assign csr_test_rw_3_wen = wen && (waddr == 16'hc);

wire csr_test_rw_3_ren;
assign csr_test_rw_3_ren = ren && (raddr == 16'hc);
reg csr_test_rw_3_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_3_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_3_ren_ff <= csr_test_rw_3_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_3[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_3_data_ff;

assign csr_test_rw_3_rdata[31:0] = csr_test_rw_3_data_ff;

assign csr_test_rw_3_data_out = csr_test_rw_3_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_3_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_3_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_3_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_3_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_3_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_3_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_3_data_ff <= csr_test_rw_3_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x10] - TEST_RW_4 - Test register RW 4
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_4_rdata;

wire csr_test_rw_4_wen;
assign csr_test_rw_4_wen = wen && (waddr == 16'h10);

wire csr_test_rw_4_ren;
assign csr_test_rw_4_ren = ren && (raddr == 16'h10);
reg csr_test_rw_4_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_4_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_4_ren_ff <= csr_test_rw_4_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_4[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_4_data_ff;

assign csr_test_rw_4_rdata[31:0] = csr_test_rw_4_data_ff;

assign csr_test_rw_4_data_out = csr_test_rw_4_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_4_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_4_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_4_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_4_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_4_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_4_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_4_data_ff <= csr_test_rw_4_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14] - TEST_RW_5 - Test register RW 5
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_5_rdata;

wire csr_test_rw_5_wen;
assign csr_test_rw_5_wen = wen && (waddr == 16'h14);

wire csr_test_rw_5_ren;
assign csr_test_rw_5_ren = ren && (raddr == 16'h14);
reg csr_test_rw_5_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_5_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_5_ren_ff <= csr_test_rw_5_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_5[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_5_data_ff;

assign csr_test_rw_5_rdata[31:0] = csr_test_rw_5_data_ff;

assign csr_test_rw_5_data_out = csr_test_rw_5_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_5_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_5_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_5_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_5_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_5_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_5_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_5_data_ff <= csr_test_rw_5_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x18] - TEST_RW_6 - Test register RW 6
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_6_rdata;

wire csr_test_rw_6_wen;
assign csr_test_rw_6_wen = wen && (waddr == 16'h18);

wire csr_test_rw_6_ren;
assign csr_test_rw_6_ren = ren && (raddr == 16'h18);
reg csr_test_rw_6_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_6_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_6_ren_ff <= csr_test_rw_6_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_6[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_6_data_ff;

assign csr_test_rw_6_rdata[31:0] = csr_test_rw_6_data_ff;

assign csr_test_rw_6_data_out = csr_test_rw_6_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_6_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_6_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_6_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_6_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_6_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_6_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_6_data_ff <= csr_test_rw_6_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x1c] - TEST_RW_7 - Test register RW 7
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_7_rdata;

wire csr_test_rw_7_wen;
assign csr_test_rw_7_wen = wen && (waddr == 16'h1c);

wire csr_test_rw_7_ren;
assign csr_test_rw_7_ren = ren && (raddr == 16'h1c);
reg csr_test_rw_7_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_7_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_7_ren_ff <= csr_test_rw_7_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_7[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_7_data_ff;

assign csr_test_rw_7_rdata[31:0] = csr_test_rw_7_data_ff;

assign csr_test_rw_7_data_out = csr_test_rw_7_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_7_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_7_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_7_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_7_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_7_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_7_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_7_data_ff <= csr_test_rw_7_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x20] - TEST_RW_8 - Test register RW 8
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_8_rdata;

wire csr_test_rw_8_wen;
assign csr_test_rw_8_wen = wen && (waddr == 16'h20);

wire csr_test_rw_8_ren;
assign csr_test_rw_8_ren = ren && (raddr == 16'h20);
reg csr_test_rw_8_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_8_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_8_ren_ff <= csr_test_rw_8_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_8[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_8_data_ff;

assign csr_test_rw_8_rdata[31:0] = csr_test_rw_8_data_ff;

assign csr_test_rw_8_data_out = csr_test_rw_8_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_8_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_8_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_8_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_8_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_8_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_8_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_8_data_ff <= csr_test_rw_8_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x24] - TEST_RW_9 - Test register RW 9
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_9_rdata;

wire csr_test_rw_9_wen;
assign csr_test_rw_9_wen = wen && (waddr == 16'h24);

wire csr_test_rw_9_ren;
assign csr_test_rw_9_ren = ren && (raddr == 16'h24);
reg csr_test_rw_9_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_9_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_9_ren_ff <= csr_test_rw_9_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_9[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_9_data_ff;

assign csr_test_rw_9_rdata[31:0] = csr_test_rw_9_data_ff;

assign csr_test_rw_9_data_out = csr_test_rw_9_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_9_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_9_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_9_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_9_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_9_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_9_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_9_data_ff <= csr_test_rw_9_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x28] - TEST_RW_10 - Test register RW 10
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_10_rdata;

wire csr_test_rw_10_wen;
assign csr_test_rw_10_wen = wen && (waddr == 16'h28);

wire csr_test_rw_10_ren;
assign csr_test_rw_10_ren = ren && (raddr == 16'h28);
reg csr_test_rw_10_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_10_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_10_ren_ff <= csr_test_rw_10_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_10[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_10_data_ff;

assign csr_test_rw_10_rdata[31:0] = csr_test_rw_10_data_ff;

assign csr_test_rw_10_data_out = csr_test_rw_10_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_10_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_10_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_10_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_10_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_10_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_10_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_10_data_ff <= csr_test_rw_10_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x2c] - TEST_RW_11 - Test register RW 11
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_11_rdata;

wire csr_test_rw_11_wen;
assign csr_test_rw_11_wen = wen && (waddr == 16'h2c);

wire csr_test_rw_11_ren;
assign csr_test_rw_11_ren = ren && (raddr == 16'h2c);
reg csr_test_rw_11_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_11_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_11_ren_ff <= csr_test_rw_11_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_11[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_11_data_ff;

assign csr_test_rw_11_rdata[31:0] = csr_test_rw_11_data_ff;

assign csr_test_rw_11_data_out = csr_test_rw_11_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_11_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_11_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_11_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_11_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_11_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_11_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_11_data_ff <= csr_test_rw_11_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x30] - TEST_RW_12 - Test register RW 12
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_12_rdata;

wire csr_test_rw_12_wen;
assign csr_test_rw_12_wen = wen && (waddr == 16'h30);

wire csr_test_rw_12_ren;
assign csr_test_rw_12_ren = ren && (raddr == 16'h30);
reg csr_test_rw_12_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_12_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_12_ren_ff <= csr_test_rw_12_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_12[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_12_data_ff;

assign csr_test_rw_12_rdata[31:0] = csr_test_rw_12_data_ff;

assign csr_test_rw_12_data_out = csr_test_rw_12_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_12_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_12_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_12_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_12_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_12_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_12_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_12_data_ff <= csr_test_rw_12_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x34] - TEST_RW_13 - Test register RW 13
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_13_rdata;

wire csr_test_rw_13_wen;
assign csr_test_rw_13_wen = wen && (waddr == 16'h34);

wire csr_test_rw_13_ren;
assign csr_test_rw_13_ren = ren && (raddr == 16'h34);
reg csr_test_rw_13_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_13_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_13_ren_ff <= csr_test_rw_13_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_13[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_13_data_ff;

assign csr_test_rw_13_rdata[31:0] = csr_test_rw_13_data_ff;

assign csr_test_rw_13_data_out = csr_test_rw_13_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_13_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_13_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_13_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_13_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_13_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_13_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_13_data_ff <= csr_test_rw_13_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x38] - TEST_RW_14 - Test register RW 14
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_14_rdata;

wire csr_test_rw_14_wen;
assign csr_test_rw_14_wen = wen && (waddr == 16'h38);

wire csr_test_rw_14_ren;
assign csr_test_rw_14_ren = ren && (raddr == 16'h38);
reg csr_test_rw_14_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_14_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_14_ren_ff <= csr_test_rw_14_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_14[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_14_data_ff;

assign csr_test_rw_14_rdata[31:0] = csr_test_rw_14_data_ff;

assign csr_test_rw_14_data_out = csr_test_rw_14_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_14_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_14_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_14_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_14_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_14_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_14_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_14_data_ff <= csr_test_rw_14_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x3c] - TEST_RW_15 - Test register RW 15
//------------------------------------------------------------------------------
wire [31:0] csr_test_rw_15_rdata;

wire csr_test_rw_15_wen;
assign csr_test_rw_15_wen = wen && (waddr == 16'h3c);

wire csr_test_rw_15_ren;
assign csr_test_rw_15_ren = ren && (raddr == 16'h3c);
reg csr_test_rw_15_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_15_ren_ff <= 1'b0;
    end else begin
        csr_test_rw_15_ren_ff <= csr_test_rw_15_ren;
    end
end
//---------------------
// Bit field:
// TEST_RW_15[31:0] - data - Test data field
// access: rw, hardware: o
//---------------------
reg [31:0] csr_test_rw_15_data_ff;

assign csr_test_rw_15_rdata[31:0] = csr_test_rw_15_data_ff;

assign csr_test_rw_15_data_out = csr_test_rw_15_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_rw_15_data_ff <= 32'h0;
    end else  begin
     if (csr_test_rw_15_wen) begin
            if (wstrb[0]) begin
                csr_test_rw_15_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_rw_15_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_rw_15_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_rw_15_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_rw_15_data_ff <= csr_test_rw_15_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x40] - TEST_W_0 - Test register W 0
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_0_rdata;

wire csr_test_w_0_wen;
assign csr_test_w_0_wen = wen && (waddr == 16'h40);

//---------------------
// Bit field:
// TEST_W_0[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_0_data_ff;

assign csr_test_w_0_rdata[31:0] = 32'h0;

assign csr_test_w_0_data_out = csr_test_w_0_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_0_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_0_wen) begin
            if (wstrb[0]) begin
                csr_test_w_0_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_0_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_0_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_0_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_0_data_ff <= csr_test_w_0_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x44] - TEST_W_1 - Test register W 1
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_1_rdata;

wire csr_test_w_1_wen;
assign csr_test_w_1_wen = wen && (waddr == 16'h44);

//---------------------
// Bit field:
// TEST_W_1[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_1_data_ff;

assign csr_test_w_1_rdata[31:0] = 32'h0;

assign csr_test_w_1_data_out = csr_test_w_1_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_1_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_1_wen) begin
            if (wstrb[0]) begin
                csr_test_w_1_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_1_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_1_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_1_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_1_data_ff <= csr_test_w_1_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x48] - TEST_W_2 - Test register W 2
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_2_rdata;

wire csr_test_w_2_wen;
assign csr_test_w_2_wen = wen && (waddr == 16'h48);

//---------------------
// Bit field:
// TEST_W_2[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_2_data_ff;

assign csr_test_w_2_rdata[31:0] = 32'h0;

assign csr_test_w_2_data_out = csr_test_w_2_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_2_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_2_wen) begin
            if (wstrb[0]) begin
                csr_test_w_2_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_2_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_2_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_2_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_2_data_ff <= csr_test_w_2_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4c] - TEST_W_3 - Test register W 3
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_3_rdata;

wire csr_test_w_3_wen;
assign csr_test_w_3_wen = wen && (waddr == 16'h4c);

//---------------------
// Bit field:
// TEST_W_3[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_3_data_ff;

assign csr_test_w_3_rdata[31:0] = 32'h0;

assign csr_test_w_3_data_out = csr_test_w_3_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_3_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_3_wen) begin
            if (wstrb[0]) begin
                csr_test_w_3_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_3_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_3_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_3_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_3_data_ff <= csr_test_w_3_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x50] - TEST_W_4 - Test register W 4
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_4_rdata;

wire csr_test_w_4_wen;
assign csr_test_w_4_wen = wen && (waddr == 16'h50);

//---------------------
// Bit field:
// TEST_W_4[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_4_data_ff;

assign csr_test_w_4_rdata[31:0] = 32'h0;

assign csr_test_w_4_data_out = csr_test_w_4_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_4_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_4_wen) begin
            if (wstrb[0]) begin
                csr_test_w_4_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_4_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_4_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_4_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_4_data_ff <= csr_test_w_4_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x54] - TEST_W_5 - Test register W 5
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_5_rdata;

wire csr_test_w_5_wen;
assign csr_test_w_5_wen = wen && (waddr == 16'h54);

//---------------------
// Bit field:
// TEST_W_5[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_5_data_ff;

assign csr_test_w_5_rdata[31:0] = 32'h0;

assign csr_test_w_5_data_out = csr_test_w_5_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_5_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_5_wen) begin
            if (wstrb[0]) begin
                csr_test_w_5_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_5_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_5_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_5_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_5_data_ff <= csr_test_w_5_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x58] - TEST_W_6 - Test register W 6
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_6_rdata;

wire csr_test_w_6_wen;
assign csr_test_w_6_wen = wen && (waddr == 16'h58);

//---------------------
// Bit field:
// TEST_W_6[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_6_data_ff;

assign csr_test_w_6_rdata[31:0] = 32'h0;

assign csr_test_w_6_data_out = csr_test_w_6_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_6_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_6_wen) begin
            if (wstrb[0]) begin
                csr_test_w_6_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_6_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_6_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_6_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_6_data_ff <= csr_test_w_6_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x5c] - TEST_W_7 - Test register W 7
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_7_rdata;

wire csr_test_w_7_wen;
assign csr_test_w_7_wen = wen && (waddr == 16'h5c);

//---------------------
// Bit field:
// TEST_W_7[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_7_data_ff;

assign csr_test_w_7_rdata[31:0] = 32'h0;

assign csr_test_w_7_data_out = csr_test_w_7_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_7_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_7_wen) begin
            if (wstrb[0]) begin
                csr_test_w_7_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_7_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_7_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_7_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_7_data_ff <= csr_test_w_7_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x60] - TEST_W_8 - Test register W 8
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_8_rdata;

wire csr_test_w_8_wen;
assign csr_test_w_8_wen = wen && (waddr == 16'h60);

//---------------------
// Bit field:
// TEST_W_8[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_8_data_ff;

assign csr_test_w_8_rdata[31:0] = 32'h0;

assign csr_test_w_8_data_out = csr_test_w_8_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_8_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_8_wen) begin
            if (wstrb[0]) begin
                csr_test_w_8_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_8_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_8_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_8_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_8_data_ff <= csr_test_w_8_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x64] - TEST_W_9 - Test register W 9
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_9_rdata;

wire csr_test_w_9_wen;
assign csr_test_w_9_wen = wen && (waddr == 16'h64);

//---------------------
// Bit field:
// TEST_W_9[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_9_data_ff;

assign csr_test_w_9_rdata[31:0] = 32'h0;

assign csr_test_w_9_data_out = csr_test_w_9_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_9_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_9_wen) begin
            if (wstrb[0]) begin
                csr_test_w_9_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_9_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_9_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_9_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_9_data_ff <= csr_test_w_9_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x68] - TEST_W_10 - Test register W 10
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_10_rdata;

wire csr_test_w_10_wen;
assign csr_test_w_10_wen = wen && (waddr == 16'h68);

//---------------------
// Bit field:
// TEST_W_10[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_10_data_ff;

assign csr_test_w_10_rdata[31:0] = 32'h0;

assign csr_test_w_10_data_out = csr_test_w_10_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_10_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_10_wen) begin
            if (wstrb[0]) begin
                csr_test_w_10_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_10_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_10_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_10_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_10_data_ff <= csr_test_w_10_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x6c] - TEST_W_11 - Test register W 11
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_11_rdata;

wire csr_test_w_11_wen;
assign csr_test_w_11_wen = wen && (waddr == 16'h6c);

//---------------------
// Bit field:
// TEST_W_11[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_11_data_ff;

assign csr_test_w_11_rdata[31:0] = 32'h0;

assign csr_test_w_11_data_out = csr_test_w_11_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_11_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_11_wen) begin
            if (wstrb[0]) begin
                csr_test_w_11_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_11_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_11_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_11_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_11_data_ff <= csr_test_w_11_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x70] - TEST_W_12 - Test register W 12
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_12_rdata;

wire csr_test_w_12_wen;
assign csr_test_w_12_wen = wen && (waddr == 16'h70);

//---------------------
// Bit field:
// TEST_W_12[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_12_data_ff;

assign csr_test_w_12_rdata[31:0] = 32'h0;

assign csr_test_w_12_data_out = csr_test_w_12_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_12_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_12_wen) begin
            if (wstrb[0]) begin
                csr_test_w_12_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_12_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_12_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_12_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_12_data_ff <= csr_test_w_12_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x74] - TEST_W_13 - Test register W 13
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_13_rdata;

wire csr_test_w_13_wen;
assign csr_test_w_13_wen = wen && (waddr == 16'h74);

//---------------------
// Bit field:
// TEST_W_13[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_13_data_ff;

assign csr_test_w_13_rdata[31:0] = 32'h0;

assign csr_test_w_13_data_out = csr_test_w_13_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_13_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_13_wen) begin
            if (wstrb[0]) begin
                csr_test_w_13_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_13_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_13_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_13_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_13_data_ff <= csr_test_w_13_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x78] - TEST_W_14 - Test register W 14
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_14_rdata;

wire csr_test_w_14_wen;
assign csr_test_w_14_wen = wen && (waddr == 16'h78);

//---------------------
// Bit field:
// TEST_W_14[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_14_data_ff;

assign csr_test_w_14_rdata[31:0] = 32'h0;

assign csr_test_w_14_data_out = csr_test_w_14_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_14_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_14_wen) begin
            if (wstrb[0]) begin
                csr_test_w_14_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_14_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_14_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_14_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_14_data_ff <= csr_test_w_14_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x7c] - TEST_W_15 - Test register W 15
//------------------------------------------------------------------------------
wire [31:0] csr_test_w_15_rdata;

wire csr_test_w_15_wen;
assign csr_test_w_15_wen = wen && (waddr == 16'h7c);

//---------------------
// Bit field:
// TEST_W_15[31:0] - data - Test data field
// access: wo, hardware: o
//---------------------
reg [31:0] csr_test_w_15_data_ff;

assign csr_test_w_15_rdata[31:0] = 32'h0;

assign csr_test_w_15_data_out = csr_test_w_15_data_ff;

always @(posedge clk) begin
    if (rst) begin
        csr_test_w_15_data_ff <= 32'h0;
    end else  begin
     if (csr_test_w_15_wen) begin
            if (wstrb[0]) begin
                csr_test_w_15_data_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_test_w_15_data_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_test_w_15_data_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_test_w_15_data_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_test_w_15_data_ff <= csr_test_w_15_data_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x80] - TEST_R_0 - Test register R 0
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_0_rdata;


wire csr_test_r_0_ren;
assign csr_test_r_0_ren = ren && (raddr == 16'h80);
reg csr_test_r_0_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_0_ren_ff <= 1'b0;
    end else begin
        csr_test_r_0_ren_ff <= csr_test_r_0_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_0[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_0_data_ff;

assign csr_test_r_0_rdata[31:0] = csr_test_r_0_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_0_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_0_data_ff <= csr_test_r_0_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x84] - TEST_R_1 - Test register R 1
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_1_rdata;


wire csr_test_r_1_ren;
assign csr_test_r_1_ren = ren && (raddr == 16'h84);
reg csr_test_r_1_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_1_ren_ff <= 1'b0;
    end else begin
        csr_test_r_1_ren_ff <= csr_test_r_1_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_1[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_1_data_ff;

assign csr_test_r_1_rdata[31:0] = csr_test_r_1_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_1_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_1_data_ff <= csr_test_r_1_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x88] - TEST_R_2 - Test register R 2
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_2_rdata;


wire csr_test_r_2_ren;
assign csr_test_r_2_ren = ren && (raddr == 16'h88);
reg csr_test_r_2_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_2_ren_ff <= 1'b0;
    end else begin
        csr_test_r_2_ren_ff <= csr_test_r_2_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_2[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_2_data_ff;

assign csr_test_r_2_rdata[31:0] = csr_test_r_2_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_2_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_2_data_ff <= csr_test_r_2_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8c] - TEST_R_3 - Test register R 3
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_3_rdata;


wire csr_test_r_3_ren;
assign csr_test_r_3_ren = ren && (raddr == 16'h8c);
reg csr_test_r_3_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_3_ren_ff <= 1'b0;
    end else begin
        csr_test_r_3_ren_ff <= csr_test_r_3_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_3[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_3_data_ff;

assign csr_test_r_3_rdata[31:0] = csr_test_r_3_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_3_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_3_data_ff <= csr_test_r_3_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x90] - TEST_R_4 - Test register R 4
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_4_rdata;


wire csr_test_r_4_ren;
assign csr_test_r_4_ren = ren && (raddr == 16'h90);
reg csr_test_r_4_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_4_ren_ff <= 1'b0;
    end else begin
        csr_test_r_4_ren_ff <= csr_test_r_4_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_4[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_4_data_ff;

assign csr_test_r_4_rdata[31:0] = csr_test_r_4_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_4_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_4_data_ff <= csr_test_r_4_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x94] - TEST_R_5 - Test register R 5
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_5_rdata;


wire csr_test_r_5_ren;
assign csr_test_r_5_ren = ren && (raddr == 16'h94);
reg csr_test_r_5_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_5_ren_ff <= 1'b0;
    end else begin
        csr_test_r_5_ren_ff <= csr_test_r_5_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_5[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_5_data_ff;

assign csr_test_r_5_rdata[31:0] = csr_test_r_5_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_5_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_5_data_ff <= csr_test_r_5_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x98] - TEST_R_6 - Test register R 6
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_6_rdata;


wire csr_test_r_6_ren;
assign csr_test_r_6_ren = ren && (raddr == 16'h98);
reg csr_test_r_6_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_6_ren_ff <= 1'b0;
    end else begin
        csr_test_r_6_ren_ff <= csr_test_r_6_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_6[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_6_data_ff;

assign csr_test_r_6_rdata[31:0] = csr_test_r_6_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_6_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_6_data_ff <= csr_test_r_6_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x9c] - TEST_R_7 - Test register R 7
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_7_rdata;


wire csr_test_r_7_ren;
assign csr_test_r_7_ren = ren && (raddr == 16'h9c);
reg csr_test_r_7_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_7_ren_ff <= 1'b0;
    end else begin
        csr_test_r_7_ren_ff <= csr_test_r_7_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_7[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_7_data_ff;

assign csr_test_r_7_rdata[31:0] = csr_test_r_7_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_7_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_7_data_ff <= csr_test_r_7_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa0] - TEST_R_8 - Test register R 8
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_8_rdata;


wire csr_test_r_8_ren;
assign csr_test_r_8_ren = ren && (raddr == 16'ha0);
reg csr_test_r_8_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_8_ren_ff <= 1'b0;
    end else begin
        csr_test_r_8_ren_ff <= csr_test_r_8_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_8[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_8_data_ff;

assign csr_test_r_8_rdata[31:0] = csr_test_r_8_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_8_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_8_data_ff <= csr_test_r_8_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa4] - TEST_R_9 - Test register R 9
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_9_rdata;


wire csr_test_r_9_ren;
assign csr_test_r_9_ren = ren && (raddr == 16'ha4);
reg csr_test_r_9_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_9_ren_ff <= 1'b0;
    end else begin
        csr_test_r_9_ren_ff <= csr_test_r_9_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_9[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_9_data_ff;

assign csr_test_r_9_rdata[31:0] = csr_test_r_9_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_9_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_9_data_ff <= csr_test_r_9_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa8] - TEST_R_10 - Test register R 10
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_10_rdata;


wire csr_test_r_10_ren;
assign csr_test_r_10_ren = ren && (raddr == 16'ha8);
reg csr_test_r_10_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_10_ren_ff <= 1'b0;
    end else begin
        csr_test_r_10_ren_ff <= csr_test_r_10_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_10[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_10_data_ff;

assign csr_test_r_10_rdata[31:0] = csr_test_r_10_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_10_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_10_data_ff <= csr_test_r_10_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xac] - TEST_R_11 - Test register R 11
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_11_rdata;


wire csr_test_r_11_ren;
assign csr_test_r_11_ren = ren && (raddr == 16'hac);
reg csr_test_r_11_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_11_ren_ff <= 1'b0;
    end else begin
        csr_test_r_11_ren_ff <= csr_test_r_11_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_11[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_11_data_ff;

assign csr_test_r_11_rdata[31:0] = csr_test_r_11_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_11_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_11_data_ff <= csr_test_r_11_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb0] - TEST_R_12 - Test register R 12
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_12_rdata;


wire csr_test_r_12_ren;
assign csr_test_r_12_ren = ren && (raddr == 16'hb0);
reg csr_test_r_12_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_12_ren_ff <= 1'b0;
    end else begin
        csr_test_r_12_ren_ff <= csr_test_r_12_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_12[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_12_data_ff;

assign csr_test_r_12_rdata[31:0] = csr_test_r_12_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_12_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_12_data_ff <= csr_test_r_12_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb4] - TEST_R_13 - Test register R 13
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_13_rdata;


wire csr_test_r_13_ren;
assign csr_test_r_13_ren = ren && (raddr == 16'hb4);
reg csr_test_r_13_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_13_ren_ff <= 1'b0;
    end else begin
        csr_test_r_13_ren_ff <= csr_test_r_13_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_13[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_13_data_ff;

assign csr_test_r_13_rdata[31:0] = csr_test_r_13_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_13_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_13_data_ff <= csr_test_r_13_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb8] - TEST_R_14 - Test register R 14
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_14_rdata;


wire csr_test_r_14_ren;
assign csr_test_r_14_ren = ren && (raddr == 16'hb8);
reg csr_test_r_14_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_14_ren_ff <= 1'b0;
    end else begin
        csr_test_r_14_ren_ff <= csr_test_r_14_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_14[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_14_data_ff;

assign csr_test_r_14_rdata[31:0] = csr_test_r_14_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_14_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_14_data_ff <= csr_test_r_14_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xbc] - TEST_R_15 - Test register R 15
//------------------------------------------------------------------------------
wire [31:0] csr_test_r_15_rdata;


wire csr_test_r_15_ren;
assign csr_test_r_15_ren = ren && (raddr == 16'hbc);
reg csr_test_r_15_ren_ff;
always @(posedge clk) begin
    if (rst) begin
        csr_test_r_15_ren_ff <= 1'b0;
    end else begin
        csr_test_r_15_ren_ff <= csr_test_r_15_ren;
    end
end
//---------------------
// Bit field:
// TEST_R_15[31:0] - data - Test data field
// access: ro, hardware: i
//---------------------
reg [31:0] csr_test_r_15_data_ff;

assign csr_test_r_15_rdata[31:0] = csr_test_r_15_data_ff;


always @(posedge clk) begin
    if (rst) begin
        csr_test_r_15_data_ff <= 32'h0;
    end else  begin
              begin            csr_test_r_15_data_ff <= csr_test_r_15_data_in;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk) begin
    if (rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            16'h0: rdata_ff <= csr_test_rw_0_rdata;
            16'h4: rdata_ff <= csr_test_rw_1_rdata;
            16'h8: rdata_ff <= csr_test_rw_2_rdata;
            16'hc: rdata_ff <= csr_test_rw_3_rdata;
            16'h10: rdata_ff <= csr_test_rw_4_rdata;
            16'h14: rdata_ff <= csr_test_rw_5_rdata;
            16'h18: rdata_ff <= csr_test_rw_6_rdata;
            16'h1c: rdata_ff <= csr_test_rw_7_rdata;
            16'h20: rdata_ff <= csr_test_rw_8_rdata;
            16'h24: rdata_ff <= csr_test_rw_9_rdata;
            16'h28: rdata_ff <= csr_test_rw_10_rdata;
            16'h2c: rdata_ff <= csr_test_rw_11_rdata;
            16'h30: rdata_ff <= csr_test_rw_12_rdata;
            16'h34: rdata_ff <= csr_test_rw_13_rdata;
            16'h38: rdata_ff <= csr_test_rw_14_rdata;
            16'h3c: rdata_ff <= csr_test_rw_15_rdata;
            16'h40: rdata_ff <= csr_test_w_0_rdata;
            16'h44: rdata_ff <= csr_test_w_1_rdata;
            16'h48: rdata_ff <= csr_test_w_2_rdata;
            16'h4c: rdata_ff <= csr_test_w_3_rdata;
            16'h50: rdata_ff <= csr_test_w_4_rdata;
            16'h54: rdata_ff <= csr_test_w_5_rdata;
            16'h58: rdata_ff <= csr_test_w_6_rdata;
            16'h5c: rdata_ff <= csr_test_w_7_rdata;
            16'h60: rdata_ff <= csr_test_w_8_rdata;
            16'h64: rdata_ff <= csr_test_w_9_rdata;
            16'h68: rdata_ff <= csr_test_w_10_rdata;
            16'h6c: rdata_ff <= csr_test_w_11_rdata;
            16'h70: rdata_ff <= csr_test_w_12_rdata;
            16'h74: rdata_ff <= csr_test_w_13_rdata;
            16'h78: rdata_ff <= csr_test_w_14_rdata;
            16'h7c: rdata_ff <= csr_test_w_15_rdata;
            16'h80: rdata_ff <= csr_test_r_0_rdata;
            16'h84: rdata_ff <= csr_test_r_1_rdata;
            16'h88: rdata_ff <= csr_test_r_2_rdata;
            16'h8c: rdata_ff <= csr_test_r_3_rdata;
            16'h90: rdata_ff <= csr_test_r_4_rdata;
            16'h94: rdata_ff <= csr_test_r_5_rdata;
            16'h98: rdata_ff <= csr_test_r_6_rdata;
            16'h9c: rdata_ff <= csr_test_r_7_rdata;
            16'ha0: rdata_ff <= csr_test_r_8_rdata;
            16'ha4: rdata_ff <= csr_test_r_9_rdata;
            16'ha8: rdata_ff <= csr_test_r_10_rdata;
            16'hac: rdata_ff <= csr_test_r_11_rdata;
            16'hb0: rdata_ff <= csr_test_r_12_rdata;
            16'hb4: rdata_ff <= csr_test_r_13_rdata;
            16'hb8: rdata_ff <= csr_test_r_14_rdata;
            16'hbc: rdata_ff <= csr_test_r_15_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk) begin
    if (rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule