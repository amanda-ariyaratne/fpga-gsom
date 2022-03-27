`timescale  1 ns / 1 ps
module grow_node_on_one_side
#(
    parameter DIGIT_DIM=32
)
(
    input clk,
    input reset,
    input en,
    input [DIGIT_DIM-1:0] winner,
    input [DIGIT_DIM-1:0] node_next,
    output [DIGIT_DIM-1:0] weight,
    output is_done
);

reg done = 0;
reg init = 1;
reg [DIGIT_DIM-1:0] out;

reg adder_en = 0;
reg adder_reset = 0;
wire adder_is_done;
reg [DIGIT_DIM-1:0] winner_in = 0;
reg [DIGIT_DIM-1:0] node_next_in = 0;
wire [DIGIT_DIM-1:0] new_weight_out;


fpa_adder adder(
    .clk(clk),
    .reset(adder_reset),
    .en(adder_en),
    .num1(winner_in),
    .num2(node_next_in),
    .num_out(new_weight_out),
    .is_done(adder_is_done)        
);

//reg adder1_a_tvalid = 0;
//wire adder1_a_tready;
//reg adder1_b_tvalid = 0;
//wire adder1_b_tready;
//wire adder1_result_tvalid;
//reg adder1_result_tready = 0;

//adder adder1(
//  .aclk(clk),
//  .s_axis_a_tvalid(adder1_a_tvalid),
//  .s_axis_a_tready(adder1_a_tready),
//  .s_axis_a_tdata(winner_in),
//  .s_axis_b_tvalid(adder1_b_tvalid),
//  .s_axis_b_tready(adder1_b_tready),
//  .s_axis_b_tdata(node_next_in),
//  .m_axis_result_tvalid(adder1_result_tvalid),
//  .m_axis_result_tready(adder1_result_tready),
//  .m_axis_result_tdata(new_weight_out)
//);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done = 0;
        init = 1;
        
    end else if (en) begin    
        if (init) begin
            winner_in = winner;
            winner_in[30:23] = winner[30:23]+1; // x2
            node_next_in = node_next;
            node_next_in[31] = ~node_next_in[31]; // -
            
            adder_en = 1;
            adder_reset = 0;
//            adder1_a_tvalid = 1;
//            adder1_b_tvalid = 1;
//            adder1_result_tready = 1;
            init=0;
            
        end else if (adder_is_done) begin // adder_is_done
            out = new_weight_out;   
            done = 1; 
            
            adder_en = 0;
            adder_reset = 1;
//            adder1_a_tvalid = 0;
//            adder1_b_tvalid = 0;
//            adder1_result_tready = 0;
        end
    end
end

assign is_done = done;
assign weight = out;

endmodule

