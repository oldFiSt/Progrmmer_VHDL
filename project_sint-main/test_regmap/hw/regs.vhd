


-- Created with Corsair v1.0.4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs is
generic(
    ADDR_W : integer := 16;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- TEST_RW_0.data
    csr_test_rw_0_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_1.data
    csr_test_rw_1_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_2.data
    csr_test_rw_2_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_3.data
    csr_test_rw_3_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_4.data
    csr_test_rw_4_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_5.data
    csr_test_rw_5_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_6.data
    csr_test_rw_6_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_7.data
    csr_test_rw_7_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_8.data
    csr_test_rw_8_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_9.data
    csr_test_rw_9_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_10.data
    csr_test_rw_10_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_11.data
    csr_test_rw_11_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_12.data
    csr_test_rw_12_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_13.data
    csr_test_rw_13_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_14.data
    csr_test_rw_14_data_out : out std_logic_vector(31 downto 0);

    -- TEST_RW_15.data
    csr_test_rw_15_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_0.data
    csr_test_w_0_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_1.data
    csr_test_w_1_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_2.data
    csr_test_w_2_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_3.data
    csr_test_w_3_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_4.data
    csr_test_w_4_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_5.data
    csr_test_w_5_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_6.data
    csr_test_w_6_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_7.data
    csr_test_w_7_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_8.data
    csr_test_w_8_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_9.data
    csr_test_w_9_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_10.data
    csr_test_w_10_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_11.data
    csr_test_w_11_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_12.data
    csr_test_w_12_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_13.data
    csr_test_w_13_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_14.data
    csr_test_w_14_data_out : out std_logic_vector(31 downto 0);

    -- TEST_W_15.data
    csr_test_w_15_data_out : out std_logic_vector(31 downto 0);

    -- TEST_R_0.data
    csr_test_r_0_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_1.data
    csr_test_r_1_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_2.data
    csr_test_r_2_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_3.data
    csr_test_r_3_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_4.data
    csr_test_r_4_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_5.data
    csr_test_r_5_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_6.data
    csr_test_r_6_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_7.data
    csr_test_r_7_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_8.data
    csr_test_r_8_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_9.data
    csr_test_r_9_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_10.data
    csr_test_r_10_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_11.data
    csr_test_r_11_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_12.data
    csr_test_r_12_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_13.data
    csr_test_r_13_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_14.data
    csr_test_r_14_data_in : in std_logic_vector(31 downto 0);

    -- TEST_R_15.data
    csr_test_r_15_data_in : in std_logic_vector(31 downto 0);

    -- AXI-Lite
    axil_awaddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic

);
end entity;

architecture rtl of regs is

signal wready : std_logic;
signal waddr  : std_logic_vector(ADDR_W-1 downto 0);
signal wdata  : std_logic_vector(DATA_W-1 downto 0);
signal wen    : std_logic;
signal wstrb  : std_logic_vector(STRB_W-1 downto 0);
signal rdata  : std_logic_vector(DATA_W-1 downto 0);
signal rvalid : std_logic;
signal raddr  : std_logic_vector(ADDR_W-1 downto 0);
signal ren    : std_logic;
signal waddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal wdata_int       : std_logic_vector(DATA_W-1 downto 0);
signal strb_int        : std_logic_vector(STRB_W-1 downto 0);
signal awflag          : std_logic;
signal wflag           : std_logic;
signal arflag          : std_logic;
signal rflag           : std_logic;
signal wen_int         : std_logic;
signal ren_int         : std_logic;
signal axil_bvalid_int : std_logic;
signal axil_rdata_int  : std_logic_vector(DATA_W-1 downto 0);
signal axil_rvalid_int : std_logic;

signal csr_test_rw_0_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_0_wen : std_logic;
signal csr_test_rw_0_ren : std_logic;
signal csr_test_rw_0_ren_ff : std_logic;
signal csr_test_rw_0_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_1_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_1_wen : std_logic;
signal csr_test_rw_1_ren : std_logic;
signal csr_test_rw_1_ren_ff : std_logic;
signal csr_test_rw_1_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_2_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_2_wen : std_logic;
signal csr_test_rw_2_ren : std_logic;
signal csr_test_rw_2_ren_ff : std_logic;
signal csr_test_rw_2_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_3_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_3_wen : std_logic;
signal csr_test_rw_3_ren : std_logic;
signal csr_test_rw_3_ren_ff : std_logic;
signal csr_test_rw_3_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_4_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_4_wen : std_logic;
signal csr_test_rw_4_ren : std_logic;
signal csr_test_rw_4_ren_ff : std_logic;
signal csr_test_rw_4_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_5_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_5_wen : std_logic;
signal csr_test_rw_5_ren : std_logic;
signal csr_test_rw_5_ren_ff : std_logic;
signal csr_test_rw_5_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_6_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_6_wen : std_logic;
signal csr_test_rw_6_ren : std_logic;
signal csr_test_rw_6_ren_ff : std_logic;
signal csr_test_rw_6_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_7_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_7_wen : std_logic;
signal csr_test_rw_7_ren : std_logic;
signal csr_test_rw_7_ren_ff : std_logic;
signal csr_test_rw_7_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_8_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_8_wen : std_logic;
signal csr_test_rw_8_ren : std_logic;
signal csr_test_rw_8_ren_ff : std_logic;
signal csr_test_rw_8_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_9_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_9_wen : std_logic;
signal csr_test_rw_9_ren : std_logic;
signal csr_test_rw_9_ren_ff : std_logic;
signal csr_test_rw_9_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_10_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_10_wen : std_logic;
signal csr_test_rw_10_ren : std_logic;
signal csr_test_rw_10_ren_ff : std_logic;
signal csr_test_rw_10_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_11_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_11_wen : std_logic;
signal csr_test_rw_11_ren : std_logic;
signal csr_test_rw_11_ren_ff : std_logic;
signal csr_test_rw_11_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_12_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_12_wen : std_logic;
signal csr_test_rw_12_ren : std_logic;
signal csr_test_rw_12_ren_ff : std_logic;
signal csr_test_rw_12_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_13_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_13_wen : std_logic;
signal csr_test_rw_13_ren : std_logic;
signal csr_test_rw_13_ren_ff : std_logic;
signal csr_test_rw_13_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_14_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_14_wen : std_logic;
signal csr_test_rw_14_ren : std_logic;
signal csr_test_rw_14_ren_ff : std_logic;
signal csr_test_rw_14_data_ff : std_logic_vector(31 downto 0);

signal csr_test_rw_15_rdata : std_logic_vector(31 downto 0);
signal csr_test_rw_15_wen : std_logic;
signal csr_test_rw_15_ren : std_logic;
signal csr_test_rw_15_ren_ff : std_logic;
signal csr_test_rw_15_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_0_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_0_wen : std_logic;
signal csr_test_w_0_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_1_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_1_wen : std_logic;
signal csr_test_w_1_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_2_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_2_wen : std_logic;
signal csr_test_w_2_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_3_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_3_wen : std_logic;
signal csr_test_w_3_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_4_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_4_wen : std_logic;
signal csr_test_w_4_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_5_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_5_wen : std_logic;
signal csr_test_w_5_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_6_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_6_wen : std_logic;
signal csr_test_w_6_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_7_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_7_wen : std_logic;
signal csr_test_w_7_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_8_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_8_wen : std_logic;
signal csr_test_w_8_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_9_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_9_wen : std_logic;
signal csr_test_w_9_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_10_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_10_wen : std_logic;
signal csr_test_w_10_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_11_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_11_wen : std_logic;
signal csr_test_w_11_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_12_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_12_wen : std_logic;
signal csr_test_w_12_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_13_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_13_wen : std_logic;
signal csr_test_w_13_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_14_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_14_wen : std_logic;
signal csr_test_w_14_data_ff : std_logic_vector(31 downto 0);

signal csr_test_w_15_rdata : std_logic_vector(31 downto 0);
signal csr_test_w_15_wen : std_logic;
signal csr_test_w_15_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_0_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_0_ren : std_logic;
signal csr_test_r_0_ren_ff : std_logic;
signal csr_test_r_0_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_1_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_1_ren : std_logic;
signal csr_test_r_1_ren_ff : std_logic;
signal csr_test_r_1_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_2_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_2_ren : std_logic;
signal csr_test_r_2_ren_ff : std_logic;
signal csr_test_r_2_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_3_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_3_ren : std_logic;
signal csr_test_r_3_ren_ff : std_logic;
signal csr_test_r_3_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_4_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_4_ren : std_logic;
signal csr_test_r_4_ren_ff : std_logic;
signal csr_test_r_4_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_5_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_5_ren : std_logic;
signal csr_test_r_5_ren_ff : std_logic;
signal csr_test_r_5_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_6_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_6_ren : std_logic;
signal csr_test_r_6_ren_ff : std_logic;
signal csr_test_r_6_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_7_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_7_ren : std_logic;
signal csr_test_r_7_ren_ff : std_logic;
signal csr_test_r_7_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_8_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_8_ren : std_logic;
signal csr_test_r_8_ren_ff : std_logic;
signal csr_test_r_8_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_9_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_9_ren : std_logic;
signal csr_test_r_9_ren_ff : std_logic;
signal csr_test_r_9_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_10_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_10_ren : std_logic;
signal csr_test_r_10_ren_ff : std_logic;
signal csr_test_r_10_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_11_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_11_ren : std_logic;
signal csr_test_r_11_ren_ff : std_logic;
signal csr_test_r_11_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_12_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_12_ren : std_logic;
signal csr_test_r_12_ren_ff : std_logic;
signal csr_test_r_12_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_13_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_13_ren : std_logic;
signal csr_test_r_13_ren_ff : std_logic;
signal csr_test_r_13_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_14_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_14_ren : std_logic;
signal csr_test_r_14_ren_ff : std_logic;
signal csr_test_r_14_data_ff : std_logic_vector(31 downto 0);

signal csr_test_r_15_rdata : std_logic_vector(31 downto 0);
signal csr_test_r_15_ren : std_logic;
signal csr_test_r_15_ren_ff : std_logic;
signal csr_test_r_15_data_ff : std_logic_vector(31 downto 0);

signal rdata_ff : std_logic_vector(31 downto 0);
signal rvalid_ff : std_logic;
begin

axil_awready <= not awflag;
axil_wready  <= not wflag;
axil_bvalid  <= axil_bvalid_int;
waddr        <= waddr_int;
wdata        <= wdata_int;
wstrb        <= strb_int;
wen_int      <= awflag and wflag;
wen          <= wen_int;
axil_bresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    waddr_int <= (others => '0');
    wdata_int <= (others => '0');
    strb_int <= (others => '0');
    awflag <= '0';
    wflag <= '0';
    axil_bvalid_int <= '0';
else
    if (axil_awvalid = '1' and awflag = '0') then
        awflag    <= '1';
        waddr_int <= axil_awaddr;
    elsif (wen_int = '1' and wready = '1') then
        awflag    <= '0';
    end if;
    if (axil_wvalid = '1' and wflag = '0') then
        wflag     <= '1';
        wdata_int <= axil_wdata;
        strb_int  <= axil_wstrb;
    elsif (wen_int = '1' and wready = '1') then
        wflag     <= '0';
    end if;
    if (axil_bvalid_int = '1' and axil_bready = '1') then
        axil_bvalid_int <= '0';
    elsif ((axil_wvalid = '1' and awflag = '1') or (axil_awvalid = '1' and wflag = '1') or (wflag = '1' and awflag = '1')) then
        axil_bvalid_int <= wready;
    end if;
end if;
end if;
end process;


axil_arready <= not arflag;
axil_rdata   <= axil_rdata_int;
axil_rvalid  <= axil_rvalid_int;
raddr        <= raddr_int;
ren_int      <= arflag and (not rflag);
ren          <= ren_int;
axil_rresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    raddr_int <= (others => '0');
    arflag <= '0';
    rflag <= '0';
    axil_rdata_int <= (others => '0');
    axil_rvalid_int <= '0';
else
    if (axil_arvalid = '1' and arflag = '0') then
        arflag    <= '1';
        raddr_int <= axil_araddr;
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        arflag    <= '0';
    end if;
    if (rvalid = '1' and ren_int = '1' and rflag = '0') then
        rflag <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        rflag <= '0';
    end if;
    if (rvalid = '1' and axil_rvalid_int = '0') then
        axil_rdata_int  <= rdata;
        axil_rvalid_int <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        axil_rvalid_int <= '0';
    end if;
end if;
end if;
end process;


--------------------------------------------------------------------------------
-- CSR:
-- [0x0] - TEST_RW_0 - Test register RW 0
--------------------------------------------------------------------------------

csr_test_rw_0_wen <= wen when (waddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0

csr_test_rw_0_ren <= ren when (raddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_0_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_0_ren_ff <= csr_test_rw_0_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_0(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_0_rdata(31 downto 0) <= csr_test_rw_0_data_ff;

csr_test_rw_0_data_out <= csr_test_rw_0_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_0_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_0_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_0_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_0_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_0_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_0_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_0_data_ff <= csr_test_rw_0_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4] - TEST_RW_1 - Test register RW 1
--------------------------------------------------------------------------------

csr_test_rw_1_wen <= wen when (waddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4

csr_test_rw_1_ren <= ren when (raddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_1_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_1_ren_ff <= csr_test_rw_1_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_1(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_1_rdata(31 downto 0) <= csr_test_rw_1_data_ff;

csr_test_rw_1_data_out <= csr_test_rw_1_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_1_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_1_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_1_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_1_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_1_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_1_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_1_data_ff <= csr_test_rw_1_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8] - TEST_RW_2 - Test register RW 2
--------------------------------------------------------------------------------

csr_test_rw_2_wen <= wen when (waddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8

csr_test_rw_2_ren <= ren when (raddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_2_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_2_ren_ff <= csr_test_rw_2_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_2(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_2_rdata(31 downto 0) <= csr_test_rw_2_data_ff;

csr_test_rw_2_data_out <= csr_test_rw_2_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_2_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_2_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_2_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_2_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_2_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_2_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_2_data_ff <= csr_test_rw_2_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - TEST_RW_3 - Test register RW 3
--------------------------------------------------------------------------------

csr_test_rw_3_wen <= wen when (waddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc

csr_test_rw_3_ren <= ren when (raddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_3_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_3_ren_ff <= csr_test_rw_3_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_3(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_3_rdata(31 downto 0) <= csr_test_rw_3_data_ff;

csr_test_rw_3_data_out <= csr_test_rw_3_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_3_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_3_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_3_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_3_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_3_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_3_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_3_data_ff <= csr_test_rw_3_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - TEST_RW_4 - Test register RW 4
--------------------------------------------------------------------------------

csr_test_rw_4_wen <= wen when (waddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10

csr_test_rw_4_ren <= ren when (raddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_4_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_4_ren_ff <= csr_test_rw_4_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_4(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_4_rdata(31 downto 0) <= csr_test_rw_4_data_ff;

csr_test_rw_4_data_out <= csr_test_rw_4_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_4_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_4_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_4_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_4_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_4_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_4_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_4_data_ff <= csr_test_rw_4_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - TEST_RW_5 - Test register RW 5
--------------------------------------------------------------------------------

csr_test_rw_5_wen <= wen when (waddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14

csr_test_rw_5_ren <= ren when (raddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_5_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_5_ren_ff <= csr_test_rw_5_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_5(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_5_rdata(31 downto 0) <= csr_test_rw_5_data_ff;

csr_test_rw_5_data_out <= csr_test_rw_5_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_5_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_5_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_5_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_5_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_5_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_5_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_5_data_ff <= csr_test_rw_5_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - TEST_RW_6 - Test register RW 6
--------------------------------------------------------------------------------

csr_test_rw_6_wen <= wen when (waddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18

csr_test_rw_6_ren <= ren when (raddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_6_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_6_ren_ff <= csr_test_rw_6_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_6(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_6_rdata(31 downto 0) <= csr_test_rw_6_data_ff;

csr_test_rw_6_data_out <= csr_test_rw_6_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_6_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_6_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_6_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_6_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_6_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_6_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_6_data_ff <= csr_test_rw_6_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x1c] - TEST_RW_7 - Test register RW 7
--------------------------------------------------------------------------------

csr_test_rw_7_wen <= wen when (waddr = std_logic_vector(to_unsigned(28, ADDR_W))) else '0'; -- 0x1c

csr_test_rw_7_ren <= ren when (raddr = std_logic_vector(to_unsigned(28, ADDR_W))) else '0'; -- 0x1c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_7_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_7_ren_ff <= csr_test_rw_7_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_7(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_7_rdata(31 downto 0) <= csr_test_rw_7_data_ff;

csr_test_rw_7_data_out <= csr_test_rw_7_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_7_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_7_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_7_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_7_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_7_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_7_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_7_data_ff <= csr_test_rw_7_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x20] - TEST_RW_8 - Test register RW 8
--------------------------------------------------------------------------------

csr_test_rw_8_wen <= wen when (waddr = std_logic_vector(to_unsigned(32, ADDR_W))) else '0'; -- 0x20

csr_test_rw_8_ren <= ren when (raddr = std_logic_vector(to_unsigned(32, ADDR_W))) else '0'; -- 0x20
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_8_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_8_ren_ff <= csr_test_rw_8_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_8(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_8_rdata(31 downto 0) <= csr_test_rw_8_data_ff;

csr_test_rw_8_data_out <= csr_test_rw_8_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_8_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_8_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_8_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_8_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_8_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_8_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_8_data_ff <= csr_test_rw_8_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x24] - TEST_RW_9 - Test register RW 9
--------------------------------------------------------------------------------

csr_test_rw_9_wen <= wen when (waddr = std_logic_vector(to_unsigned(36, ADDR_W))) else '0'; -- 0x24

csr_test_rw_9_ren <= ren when (raddr = std_logic_vector(to_unsigned(36, ADDR_W))) else '0'; -- 0x24
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_9_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_9_ren_ff <= csr_test_rw_9_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_9(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_9_rdata(31 downto 0) <= csr_test_rw_9_data_ff;

csr_test_rw_9_data_out <= csr_test_rw_9_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_9_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_9_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_9_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_9_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_9_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_9_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_9_data_ff <= csr_test_rw_9_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x28] - TEST_RW_10 - Test register RW 10
--------------------------------------------------------------------------------

csr_test_rw_10_wen <= wen when (waddr = std_logic_vector(to_unsigned(40, ADDR_W))) else '0'; -- 0x28

csr_test_rw_10_ren <= ren when (raddr = std_logic_vector(to_unsigned(40, ADDR_W))) else '0'; -- 0x28
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_10_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_10_ren_ff <= csr_test_rw_10_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_10(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_10_rdata(31 downto 0) <= csr_test_rw_10_data_ff;

csr_test_rw_10_data_out <= csr_test_rw_10_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_10_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_10_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_10_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_10_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_10_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_10_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_10_data_ff <= csr_test_rw_10_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x2c] - TEST_RW_11 - Test register RW 11
--------------------------------------------------------------------------------

csr_test_rw_11_wen <= wen when (waddr = std_logic_vector(to_unsigned(44, ADDR_W))) else '0'; -- 0x2c

csr_test_rw_11_ren <= ren when (raddr = std_logic_vector(to_unsigned(44, ADDR_W))) else '0'; -- 0x2c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_11_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_11_ren_ff <= csr_test_rw_11_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_11(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_11_rdata(31 downto 0) <= csr_test_rw_11_data_ff;

csr_test_rw_11_data_out <= csr_test_rw_11_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_11_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_11_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_11_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_11_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_11_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_11_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_11_data_ff <= csr_test_rw_11_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x30] - TEST_RW_12 - Test register RW 12
--------------------------------------------------------------------------------

csr_test_rw_12_wen <= wen when (waddr = std_logic_vector(to_unsigned(48, ADDR_W))) else '0'; -- 0x30

csr_test_rw_12_ren <= ren when (raddr = std_logic_vector(to_unsigned(48, ADDR_W))) else '0'; -- 0x30
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_12_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_12_ren_ff <= csr_test_rw_12_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_12(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_12_rdata(31 downto 0) <= csr_test_rw_12_data_ff;

csr_test_rw_12_data_out <= csr_test_rw_12_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_12_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_12_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_12_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_12_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_12_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_12_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_12_data_ff <= csr_test_rw_12_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x34] - TEST_RW_13 - Test register RW 13
--------------------------------------------------------------------------------

csr_test_rw_13_wen <= wen when (waddr = std_logic_vector(to_unsigned(52, ADDR_W))) else '0'; -- 0x34

csr_test_rw_13_ren <= ren when (raddr = std_logic_vector(to_unsigned(52, ADDR_W))) else '0'; -- 0x34
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_13_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_13_ren_ff <= csr_test_rw_13_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_13(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_13_rdata(31 downto 0) <= csr_test_rw_13_data_ff;

csr_test_rw_13_data_out <= csr_test_rw_13_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_13_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_13_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_13_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_13_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_13_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_13_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_13_data_ff <= csr_test_rw_13_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x38] - TEST_RW_14 - Test register RW 14
--------------------------------------------------------------------------------

csr_test_rw_14_wen <= wen when (waddr = std_logic_vector(to_unsigned(56, ADDR_W))) else '0'; -- 0x38

csr_test_rw_14_ren <= ren when (raddr = std_logic_vector(to_unsigned(56, ADDR_W))) else '0'; -- 0x38
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_14_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_14_ren_ff <= csr_test_rw_14_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_14(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_14_rdata(31 downto 0) <= csr_test_rw_14_data_ff;

csr_test_rw_14_data_out <= csr_test_rw_14_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_14_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_14_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_14_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_14_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_14_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_14_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_14_data_ff <= csr_test_rw_14_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x3c] - TEST_RW_15 - Test register RW 15
--------------------------------------------------------------------------------

csr_test_rw_15_wen <= wen when (waddr = std_logic_vector(to_unsigned(60, ADDR_W))) else '0'; -- 0x3c

csr_test_rw_15_ren <= ren when (raddr = std_logic_vector(to_unsigned(60, ADDR_W))) else '0'; -- 0x3c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_15_ren_ff <= '0'; -- 0x0
else
        csr_test_rw_15_ren_ff <= csr_test_rw_15_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_RW_15(31 downto 0) - data - Test data field
-- access: rw, hardware: o
-----------------------

csr_test_rw_15_rdata(31 downto 0) <= csr_test_rw_15_data_ff;

csr_test_rw_15_data_out <= csr_test_rw_15_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_rw_15_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_rw_15_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_rw_15_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_rw_15_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_rw_15_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_rw_15_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_rw_15_data_ff <= csr_test_rw_15_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x40] - TEST_W_0 - Test register W 0
--------------------------------------------------------------------------------

csr_test_w_0_wen <= wen when (waddr = std_logic_vector(to_unsigned(64, ADDR_W))) else '0'; -- 0x40

-----------------------
-- Bit field:
-- TEST_W_0(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_0_rdata(31 downto 0) <= (others => '0');

csr_test_w_0_data_out <= csr_test_w_0_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_0_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_0_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_0_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_0_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_0_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_0_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_0_data_ff <= csr_test_w_0_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x44] - TEST_W_1 - Test register W 1
--------------------------------------------------------------------------------

csr_test_w_1_wen <= wen when (waddr = std_logic_vector(to_unsigned(68, ADDR_W))) else '0'; -- 0x44

-----------------------
-- Bit field:
-- TEST_W_1(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_1_rdata(31 downto 0) <= (others => '0');

csr_test_w_1_data_out <= csr_test_w_1_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_1_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_1_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_1_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_1_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_1_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_1_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_1_data_ff <= csr_test_w_1_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x48] - TEST_W_2 - Test register W 2
--------------------------------------------------------------------------------

csr_test_w_2_wen <= wen when (waddr = std_logic_vector(to_unsigned(72, ADDR_W))) else '0'; -- 0x48

-----------------------
-- Bit field:
-- TEST_W_2(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_2_rdata(31 downto 0) <= (others => '0');

csr_test_w_2_data_out <= csr_test_w_2_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_2_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_2_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_2_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_2_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_2_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_2_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_2_data_ff <= csr_test_w_2_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4c] - TEST_W_3 - Test register W 3
--------------------------------------------------------------------------------

csr_test_w_3_wen <= wen when (waddr = std_logic_vector(to_unsigned(76, ADDR_W))) else '0'; -- 0x4c

-----------------------
-- Bit field:
-- TEST_W_3(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_3_rdata(31 downto 0) <= (others => '0');

csr_test_w_3_data_out <= csr_test_w_3_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_3_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_3_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_3_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_3_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_3_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_3_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_3_data_ff <= csr_test_w_3_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x50] - TEST_W_4 - Test register W 4
--------------------------------------------------------------------------------

csr_test_w_4_wen <= wen when (waddr = std_logic_vector(to_unsigned(80, ADDR_W))) else '0'; -- 0x50

-----------------------
-- Bit field:
-- TEST_W_4(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_4_rdata(31 downto 0) <= (others => '0');

csr_test_w_4_data_out <= csr_test_w_4_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_4_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_4_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_4_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_4_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_4_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_4_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_4_data_ff <= csr_test_w_4_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x54] - TEST_W_5 - Test register W 5
--------------------------------------------------------------------------------

csr_test_w_5_wen <= wen when (waddr = std_logic_vector(to_unsigned(84, ADDR_W))) else '0'; -- 0x54

-----------------------
-- Bit field:
-- TEST_W_5(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_5_rdata(31 downto 0) <= (others => '0');

csr_test_w_5_data_out <= csr_test_w_5_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_5_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_5_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_5_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_5_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_5_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_5_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_5_data_ff <= csr_test_w_5_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x58] - TEST_W_6 - Test register W 6
--------------------------------------------------------------------------------

csr_test_w_6_wen <= wen when (waddr = std_logic_vector(to_unsigned(88, ADDR_W))) else '0'; -- 0x58

-----------------------
-- Bit field:
-- TEST_W_6(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_6_rdata(31 downto 0) <= (others => '0');

csr_test_w_6_data_out <= csr_test_w_6_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_6_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_6_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_6_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_6_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_6_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_6_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_6_data_ff <= csr_test_w_6_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x5c] - TEST_W_7 - Test register W 7
--------------------------------------------------------------------------------

csr_test_w_7_wen <= wen when (waddr = std_logic_vector(to_unsigned(92, ADDR_W))) else '0'; -- 0x5c

-----------------------
-- Bit field:
-- TEST_W_7(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_7_rdata(31 downto 0) <= (others => '0');

csr_test_w_7_data_out <= csr_test_w_7_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_7_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_7_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_7_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_7_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_7_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_7_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_7_data_ff <= csr_test_w_7_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x60] - TEST_W_8 - Test register W 8
--------------------------------------------------------------------------------

csr_test_w_8_wen <= wen when (waddr = std_logic_vector(to_unsigned(96, ADDR_W))) else '0'; -- 0x60

-----------------------
-- Bit field:
-- TEST_W_8(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_8_rdata(31 downto 0) <= (others => '0');

csr_test_w_8_data_out <= csr_test_w_8_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_8_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_8_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_8_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_8_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_8_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_8_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_8_data_ff <= csr_test_w_8_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x64] - TEST_W_9 - Test register W 9
--------------------------------------------------------------------------------

csr_test_w_9_wen <= wen when (waddr = std_logic_vector(to_unsigned(100, ADDR_W))) else '0'; -- 0x64

-----------------------
-- Bit field:
-- TEST_W_9(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_9_rdata(31 downto 0) <= (others => '0');

csr_test_w_9_data_out <= csr_test_w_9_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_9_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_9_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_9_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_9_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_9_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_9_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_9_data_ff <= csr_test_w_9_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x68] - TEST_W_10 - Test register W 10
--------------------------------------------------------------------------------

csr_test_w_10_wen <= wen when (waddr = std_logic_vector(to_unsigned(104, ADDR_W))) else '0'; -- 0x68

-----------------------
-- Bit field:
-- TEST_W_10(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_10_rdata(31 downto 0) <= (others => '0');

csr_test_w_10_data_out <= csr_test_w_10_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_10_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_10_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_10_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_10_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_10_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_10_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_10_data_ff <= csr_test_w_10_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x6c] - TEST_W_11 - Test register W 11
--------------------------------------------------------------------------------

csr_test_w_11_wen <= wen when (waddr = std_logic_vector(to_unsigned(108, ADDR_W))) else '0'; -- 0x6c

-----------------------
-- Bit field:
-- TEST_W_11(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_11_rdata(31 downto 0) <= (others => '0');

csr_test_w_11_data_out <= csr_test_w_11_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_11_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_11_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_11_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_11_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_11_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_11_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_11_data_ff <= csr_test_w_11_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x70] - TEST_W_12 - Test register W 12
--------------------------------------------------------------------------------

csr_test_w_12_wen <= wen when (waddr = std_logic_vector(to_unsigned(112, ADDR_W))) else '0'; -- 0x70

-----------------------
-- Bit field:
-- TEST_W_12(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_12_rdata(31 downto 0) <= (others => '0');

csr_test_w_12_data_out <= csr_test_w_12_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_12_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_12_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_12_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_12_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_12_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_12_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_12_data_ff <= csr_test_w_12_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x74] - TEST_W_13 - Test register W 13
--------------------------------------------------------------------------------

csr_test_w_13_wen <= wen when (waddr = std_logic_vector(to_unsigned(116, ADDR_W))) else '0'; -- 0x74

-----------------------
-- Bit field:
-- TEST_W_13(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_13_rdata(31 downto 0) <= (others => '0');

csr_test_w_13_data_out <= csr_test_w_13_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_13_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_13_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_13_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_13_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_13_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_13_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_13_data_ff <= csr_test_w_13_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x78] - TEST_W_14 - Test register W 14
--------------------------------------------------------------------------------

csr_test_w_14_wen <= wen when (waddr = std_logic_vector(to_unsigned(120, ADDR_W))) else '0'; -- 0x78

-----------------------
-- Bit field:
-- TEST_W_14(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_14_rdata(31 downto 0) <= (others => '0');

csr_test_w_14_data_out <= csr_test_w_14_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_14_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_14_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_14_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_14_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_14_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_14_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_14_data_ff <= csr_test_w_14_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x7c] - TEST_W_15 - Test register W 15
--------------------------------------------------------------------------------

csr_test_w_15_wen <= wen when (waddr = std_logic_vector(to_unsigned(124, ADDR_W))) else '0'; -- 0x7c

-----------------------
-- Bit field:
-- TEST_W_15(31 downto 0) - data - Test data field
-- access: wo, hardware: o
-----------------------

csr_test_w_15_rdata(31 downto 0) <= (others => '0');

csr_test_w_15_data_out <= csr_test_w_15_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_w_15_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_test_w_15_wen = '1') then
            if (wstrb(0) = '1') then
                csr_test_w_15_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_test_w_15_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_test_w_15_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_test_w_15_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_test_w_15_data_ff <= csr_test_w_15_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x80] - TEST_R_0 - Test register R 0
--------------------------------------------------------------------------------


csr_test_r_0_ren <= ren when (raddr = std_logic_vector(to_unsigned(128, ADDR_W))) else '0'; -- 0x80
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_0_ren_ff <= '0'; -- 0x0
else
        csr_test_r_0_ren_ff <= csr_test_r_0_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_0(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_0_rdata(31 downto 0) <= csr_test_r_0_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_0_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_0_data_ff <= csr_test_r_0_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x84] - TEST_R_1 - Test register R 1
--------------------------------------------------------------------------------


csr_test_r_1_ren <= ren when (raddr = std_logic_vector(to_unsigned(132, ADDR_W))) else '0'; -- 0x84
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_1_ren_ff <= '0'; -- 0x0
else
        csr_test_r_1_ren_ff <= csr_test_r_1_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_1(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_1_rdata(31 downto 0) <= csr_test_r_1_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_1_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_1_data_ff <= csr_test_r_1_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x88] - TEST_R_2 - Test register R 2
--------------------------------------------------------------------------------


csr_test_r_2_ren <= ren when (raddr = std_logic_vector(to_unsigned(136, ADDR_W))) else '0'; -- 0x88
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_2_ren_ff <= '0'; -- 0x0
else
        csr_test_r_2_ren_ff <= csr_test_r_2_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_2(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_2_rdata(31 downto 0) <= csr_test_r_2_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_2_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_2_data_ff <= csr_test_r_2_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8c] - TEST_R_3 - Test register R 3
--------------------------------------------------------------------------------


csr_test_r_3_ren <= ren when (raddr = std_logic_vector(to_unsigned(140, ADDR_W))) else '0'; -- 0x8c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_3_ren_ff <= '0'; -- 0x0
else
        csr_test_r_3_ren_ff <= csr_test_r_3_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_3(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_3_rdata(31 downto 0) <= csr_test_r_3_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_3_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_3_data_ff <= csr_test_r_3_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x90] - TEST_R_4 - Test register R 4
--------------------------------------------------------------------------------


csr_test_r_4_ren <= ren when (raddr = std_logic_vector(to_unsigned(144, ADDR_W))) else '0'; -- 0x90
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_4_ren_ff <= '0'; -- 0x0
else
        csr_test_r_4_ren_ff <= csr_test_r_4_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_4(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_4_rdata(31 downto 0) <= csr_test_r_4_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_4_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_4_data_ff <= csr_test_r_4_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x94] - TEST_R_5 - Test register R 5
--------------------------------------------------------------------------------


csr_test_r_5_ren <= ren when (raddr = std_logic_vector(to_unsigned(148, ADDR_W))) else '0'; -- 0x94
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_5_ren_ff <= '0'; -- 0x0
else
        csr_test_r_5_ren_ff <= csr_test_r_5_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_5(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_5_rdata(31 downto 0) <= csr_test_r_5_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_5_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_5_data_ff <= csr_test_r_5_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x98] - TEST_R_6 - Test register R 6
--------------------------------------------------------------------------------


csr_test_r_6_ren <= ren when (raddr = std_logic_vector(to_unsigned(152, ADDR_W))) else '0'; -- 0x98
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_6_ren_ff <= '0'; -- 0x0
else
        csr_test_r_6_ren_ff <= csr_test_r_6_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_6(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_6_rdata(31 downto 0) <= csr_test_r_6_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_6_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_6_data_ff <= csr_test_r_6_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x9c] - TEST_R_7 - Test register R 7
--------------------------------------------------------------------------------


csr_test_r_7_ren <= ren when (raddr = std_logic_vector(to_unsigned(156, ADDR_W))) else '0'; -- 0x9c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_7_ren_ff <= '0'; -- 0x0
else
        csr_test_r_7_ren_ff <= csr_test_r_7_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_7(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_7_rdata(31 downto 0) <= csr_test_r_7_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_7_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_7_data_ff <= csr_test_r_7_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xa0] - TEST_R_8 - Test register R 8
--------------------------------------------------------------------------------


csr_test_r_8_ren <= ren when (raddr = std_logic_vector(to_unsigned(160, ADDR_W))) else '0'; -- 0xa0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_8_ren_ff <= '0'; -- 0x0
else
        csr_test_r_8_ren_ff <= csr_test_r_8_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_8(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_8_rdata(31 downto 0) <= csr_test_r_8_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_8_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_8_data_ff <= csr_test_r_8_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xa4] - TEST_R_9 - Test register R 9
--------------------------------------------------------------------------------


csr_test_r_9_ren <= ren when (raddr = std_logic_vector(to_unsigned(164, ADDR_W))) else '0'; -- 0xa4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_9_ren_ff <= '0'; -- 0x0
else
        csr_test_r_9_ren_ff <= csr_test_r_9_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_9(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_9_rdata(31 downto 0) <= csr_test_r_9_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_9_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_9_data_ff <= csr_test_r_9_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xa8] - TEST_R_10 - Test register R 10
--------------------------------------------------------------------------------


csr_test_r_10_ren <= ren when (raddr = std_logic_vector(to_unsigned(168, ADDR_W))) else '0'; -- 0xa8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_10_ren_ff <= '0'; -- 0x0
else
        csr_test_r_10_ren_ff <= csr_test_r_10_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_10(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_10_rdata(31 downto 0) <= csr_test_r_10_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_10_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_10_data_ff <= csr_test_r_10_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xac] - TEST_R_11 - Test register R 11
--------------------------------------------------------------------------------


csr_test_r_11_ren <= ren when (raddr = std_logic_vector(to_unsigned(172, ADDR_W))) else '0'; -- 0xac
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_11_ren_ff <= '0'; -- 0x0
else
        csr_test_r_11_ren_ff <= csr_test_r_11_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_11(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_11_rdata(31 downto 0) <= csr_test_r_11_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_11_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_11_data_ff <= csr_test_r_11_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xb0] - TEST_R_12 - Test register R 12
--------------------------------------------------------------------------------


csr_test_r_12_ren <= ren when (raddr = std_logic_vector(to_unsigned(176, ADDR_W))) else '0'; -- 0xb0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_12_ren_ff <= '0'; -- 0x0
else
        csr_test_r_12_ren_ff <= csr_test_r_12_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_12(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_12_rdata(31 downto 0) <= csr_test_r_12_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_12_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_12_data_ff <= csr_test_r_12_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xb4] - TEST_R_13 - Test register R 13
--------------------------------------------------------------------------------


csr_test_r_13_ren <= ren when (raddr = std_logic_vector(to_unsigned(180, ADDR_W))) else '0'; -- 0xb4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_13_ren_ff <= '0'; -- 0x0
else
        csr_test_r_13_ren_ff <= csr_test_r_13_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_13(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_13_rdata(31 downto 0) <= csr_test_r_13_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_13_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_13_data_ff <= csr_test_r_13_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xb8] - TEST_R_14 - Test register R 14
--------------------------------------------------------------------------------


csr_test_r_14_ren <= ren when (raddr = std_logic_vector(to_unsigned(184, ADDR_W))) else '0'; -- 0xb8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_14_ren_ff <= '0'; -- 0x0
else
        csr_test_r_14_ren_ff <= csr_test_r_14_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_14(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_14_rdata(31 downto 0) <= csr_test_r_14_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_14_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_14_data_ff <= csr_test_r_14_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xbc] - TEST_R_15 - Test register R 15
--------------------------------------------------------------------------------


csr_test_r_15_ren <= ren when (raddr = std_logic_vector(to_unsigned(188, ADDR_W))) else '0'; -- 0xbc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_15_ren_ff <= '0'; -- 0x0
else
        csr_test_r_15_ren_ff <= csr_test_r_15_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TEST_R_15(31 downto 0) - data - Test data field
-- access: ro, hardware: i
-----------------------

csr_test_r_15_rdata(31 downto 0) <= csr_test_r_15_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_test_r_15_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_test_r_15_data_ff <= csr_test_r_15_data_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- Write ready
--------------------------------------------------------------------------------
wready <= '1';

--------------------------------------------------------------------------------
-- Read address decoder
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rdata_ff <= "00000000000000000000000000000000"; -- 0x0
else
    if (ren = '1') then
        if raddr = std_logic_vector(to_unsigned(0, ADDR_W)) then -- 0x0
            rdata_ff <= csr_test_rw_0_rdata;
        elsif raddr = std_logic_vector(to_unsigned(4, ADDR_W)) then -- 0x4
            rdata_ff <= csr_test_rw_1_rdata;
        elsif raddr = std_logic_vector(to_unsigned(8, ADDR_W)) then -- 0x8
            rdata_ff <= csr_test_rw_2_rdata;
        elsif raddr = std_logic_vector(to_unsigned(12, ADDR_W)) then -- 0xc
            rdata_ff <= csr_test_rw_3_rdata;
        elsif raddr = std_logic_vector(to_unsigned(16, ADDR_W)) then -- 0x10
            rdata_ff <= csr_test_rw_4_rdata;
        elsif raddr = std_logic_vector(to_unsigned(20, ADDR_W)) then -- 0x14
            rdata_ff <= csr_test_rw_5_rdata;
        elsif raddr = std_logic_vector(to_unsigned(24, ADDR_W)) then -- 0x18
            rdata_ff <= csr_test_rw_6_rdata;
        elsif raddr = std_logic_vector(to_unsigned(28, ADDR_W)) then -- 0x1c
            rdata_ff <= csr_test_rw_7_rdata;
        elsif raddr = std_logic_vector(to_unsigned(32, ADDR_W)) then -- 0x20
            rdata_ff <= csr_test_rw_8_rdata;
        elsif raddr = std_logic_vector(to_unsigned(36, ADDR_W)) then -- 0x24
            rdata_ff <= csr_test_rw_9_rdata;
        elsif raddr = std_logic_vector(to_unsigned(40, ADDR_W)) then -- 0x28
            rdata_ff <= csr_test_rw_10_rdata;
        elsif raddr = std_logic_vector(to_unsigned(44, ADDR_W)) then -- 0x2c
            rdata_ff <= csr_test_rw_11_rdata;
        elsif raddr = std_logic_vector(to_unsigned(48, ADDR_W)) then -- 0x30
            rdata_ff <= csr_test_rw_12_rdata;
        elsif raddr = std_logic_vector(to_unsigned(52, ADDR_W)) then -- 0x34
            rdata_ff <= csr_test_rw_13_rdata;
        elsif raddr = std_logic_vector(to_unsigned(56, ADDR_W)) then -- 0x38
            rdata_ff <= csr_test_rw_14_rdata;
        elsif raddr = std_logic_vector(to_unsigned(60, ADDR_W)) then -- 0x3c
            rdata_ff <= csr_test_rw_15_rdata;
        elsif raddr = std_logic_vector(to_unsigned(64, ADDR_W)) then -- 0x40
            rdata_ff <= csr_test_w_0_rdata;
        elsif raddr = std_logic_vector(to_unsigned(68, ADDR_W)) then -- 0x44
            rdata_ff <= csr_test_w_1_rdata;
        elsif raddr = std_logic_vector(to_unsigned(72, ADDR_W)) then -- 0x48
            rdata_ff <= csr_test_w_2_rdata;
        elsif raddr = std_logic_vector(to_unsigned(76, ADDR_W)) then -- 0x4c
            rdata_ff <= csr_test_w_3_rdata;
        elsif raddr = std_logic_vector(to_unsigned(80, ADDR_W)) then -- 0x50
            rdata_ff <= csr_test_w_4_rdata;
        elsif raddr = std_logic_vector(to_unsigned(84, ADDR_W)) then -- 0x54
            rdata_ff <= csr_test_w_5_rdata;
        elsif raddr = std_logic_vector(to_unsigned(88, ADDR_W)) then -- 0x58
            rdata_ff <= csr_test_w_6_rdata;
        elsif raddr = std_logic_vector(to_unsigned(92, ADDR_W)) then -- 0x5c
            rdata_ff <= csr_test_w_7_rdata;
        elsif raddr = std_logic_vector(to_unsigned(96, ADDR_W)) then -- 0x60
            rdata_ff <= csr_test_w_8_rdata;
        elsif raddr = std_logic_vector(to_unsigned(100, ADDR_W)) then -- 0x64
            rdata_ff <= csr_test_w_9_rdata;
        elsif raddr = std_logic_vector(to_unsigned(104, ADDR_W)) then -- 0x68
            rdata_ff <= csr_test_w_10_rdata;
        elsif raddr = std_logic_vector(to_unsigned(108, ADDR_W)) then -- 0x6c
            rdata_ff <= csr_test_w_11_rdata;
        elsif raddr = std_logic_vector(to_unsigned(112, ADDR_W)) then -- 0x70
            rdata_ff <= csr_test_w_12_rdata;
        elsif raddr = std_logic_vector(to_unsigned(116, ADDR_W)) then -- 0x74
            rdata_ff <= csr_test_w_13_rdata;
        elsif raddr = std_logic_vector(to_unsigned(120, ADDR_W)) then -- 0x78
            rdata_ff <= csr_test_w_14_rdata;
        elsif raddr = std_logic_vector(to_unsigned(124, ADDR_W)) then -- 0x7c
            rdata_ff <= csr_test_w_15_rdata;
        elsif raddr = std_logic_vector(to_unsigned(128, ADDR_W)) then -- 0x80
            rdata_ff <= csr_test_r_0_rdata;
        elsif raddr = std_logic_vector(to_unsigned(132, ADDR_W)) then -- 0x84
            rdata_ff <= csr_test_r_1_rdata;
        elsif raddr = std_logic_vector(to_unsigned(136, ADDR_W)) then -- 0x88
            rdata_ff <= csr_test_r_2_rdata;
        elsif raddr = std_logic_vector(to_unsigned(140, ADDR_W)) then -- 0x8c
            rdata_ff <= csr_test_r_3_rdata;
        elsif raddr = std_logic_vector(to_unsigned(144, ADDR_W)) then -- 0x90
            rdata_ff <= csr_test_r_4_rdata;
        elsif raddr = std_logic_vector(to_unsigned(148, ADDR_W)) then -- 0x94
            rdata_ff <= csr_test_r_5_rdata;
        elsif raddr = std_logic_vector(to_unsigned(152, ADDR_W)) then -- 0x98
            rdata_ff <= csr_test_r_6_rdata;
        elsif raddr = std_logic_vector(to_unsigned(156, ADDR_W)) then -- 0x9c
            rdata_ff <= csr_test_r_7_rdata;
        elsif raddr = std_logic_vector(to_unsigned(160, ADDR_W)) then -- 0xa0
            rdata_ff <= csr_test_r_8_rdata;
        elsif raddr = std_logic_vector(to_unsigned(164, ADDR_W)) then -- 0xa4
            rdata_ff <= csr_test_r_9_rdata;
        elsif raddr = std_logic_vector(to_unsigned(168, ADDR_W)) then -- 0xa8
            rdata_ff <= csr_test_r_10_rdata;
        elsif raddr = std_logic_vector(to_unsigned(172, ADDR_W)) then -- 0xac
            rdata_ff <= csr_test_r_11_rdata;
        elsif raddr = std_logic_vector(to_unsigned(176, ADDR_W)) then -- 0xb0
            rdata_ff <= csr_test_r_12_rdata;
        elsif raddr = std_logic_vector(to_unsigned(180, ADDR_W)) then -- 0xb4
            rdata_ff <= csr_test_r_13_rdata;
        elsif raddr = std_logic_vector(to_unsigned(184, ADDR_W)) then -- 0xb8
            rdata_ff <= csr_test_r_14_rdata;
        elsif raddr = std_logic_vector(to_unsigned(188, ADDR_W)) then -- 0xbc
            rdata_ff <= csr_test_r_15_rdata;
        else 
            rdata_ff <= "00000000000000000000000000000000"; -- 0x0
        end if;
    else
        rdata_ff <= "00000000000000000000000000000000"; -- 0x0
    end if;
end if;
end if;
end process;

rdata <= rdata_ff;

--------------------------------------------------------------------------------
-- Read data valid
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rvalid_ff <= '0'; -- 0x0
else
    if ((ren = '1') and (rvalid = '1')) then
        rvalid_ff <= '0';
    elsif (ren = '1') then
        rvalid_ff <= '1';
    end if;
end if;
end if;
end process;


rvalid <= rvalid_ff;

end architecture;