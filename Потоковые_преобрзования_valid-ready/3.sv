module generate_tokens_by_number_with_flow_control
#(
    parameter WIDTH = 4
)
(
    input                clk,
    input                rst,

    input                up_valid,
    output logic         up_ready,
    input  [WIDTH-1 : 0] n_tokens,

    output logic         down_valid,
    input                down_ready,
    output logic         down_token
);

    logic [WIDTH-1:0] cnt;
    logic             busy;

    wire up_fire   = up_valid && up_ready;
    wire down_fire = down_valid && down_ready;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt       <= '0;
            busy      <= 1'b0;
        end else begin
            if (up_fire) begin
                cnt  <= n_tokens;
                busy <= (n_tokens != 0);
            end else if (down_fire) begin
                if (cnt == 1) begin
                    cnt  <= '0;
                    busy <= 1'b0;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
        end
    end

    assign up_ready   = !busy;
    assign down_valid = busy;
    assign down_token = busy;

endmodule