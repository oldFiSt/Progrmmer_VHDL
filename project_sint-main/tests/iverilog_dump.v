module iverilog_dump();
initial begin
    $dumpfile("pkt2axil_top_tb.fst");
    $dumpvars(0, pkt2axil_top_tb);
end
endmodule
