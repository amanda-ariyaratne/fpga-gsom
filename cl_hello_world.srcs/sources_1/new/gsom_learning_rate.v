/**************
 LR(t +1) = alpha * psi(n) * LR(t)
 n = node count

 psi(n) = 1 -  R
              ----
               n
*************/
`timescale  1 ns / 1 ps
module gsom_learning_rate
#(
    parameter DIGIT_DIM = 32
)
(
    input wire clk,
    input wire en,
    input wire reset,
    input wire [DIGIT_DIM-1:0] node_count,
    input wire [DIGIT_DIM-1:0] prev_learning_rate,
    input wire [DIGIT_DIM-1:0] alpha,
    output wire [DIGIT_DIM-1:0] learning_rate,
    output wire is_done
);

reg [DIGIT_DIM-1:0] R = 32'h40733333;

reg divider1_aresetn = 1;
reg divider1_a_tvalid = 0;
wire divider1_a_tready;
reg [DIGIT_DIM-1:0] divider1_a_tdata;

reg divider1_b_tvalid = 0;
wire divider1_b_tready;
reg [DIGIT_DIM-1:0] divider1_b_tdata;

wire divider1_result_tvalid;
reg divider1_result_tready = 0;
wire [DIGIT_DIM-1:0] divider1_result_tdata;


divider_with_reset divider1(
  .aclk(clk),
  .aresetn(divider1_aresetn),
  .s_axis_a_tvalid(divider1_a_tvalid),
  .s_axis_a_tready(divider1_a_tready),
  .s_axis_a_tdata(divider1_a_tdata),
  .s_axis_b_tvalid(divider1_b_tvalid),
  .s_axis_b_tready(divider1_b_tready),
  .s_axis_b_tdata(divider1_b_tdata),
  .m_axis_result_tvalid(divider1_result_tvalid),
  .m_axis_result_tready(divider1_result_tready),
  .m_axis_result_tdata(divider1_result_tdata)
);

///////////////////////////////////////////*********adder1*********/////////////////////////////////////////////////////

reg adder1_en = 0;
reg adder1_reset = 0;
wire adder1_is_done;
reg [DIGIT_DIM-1:0] adder1_a_tdata;
reg [DIGIT_DIM-1:0] adder1_b_tdata;
wire [DIGIT_DIM-1:0] adder1_result_tdata;

fpa_adder adder1(
    .clk(clk),
    .en(adder1_en),
    .reset(adder1_reset),
    .num1(adder1_a_tdata),
    .num2(adder1_b_tdata),
    .num_out(adder1_result_tdata),
    .is_done(adder1_is_done)        
);

//reg adder1_a_tvalid = 0;
//wire adder1_a_tready;
//reg [DIGIT_DIM-1:0] adder1_a_tdata;

//reg adder1_b_tvalid = 0;
//wire adder1_b_tready;
//reg [DIGIT_DIM-1:0] adder1_b_tdata;

//wire adder1_result_tvalid;
//reg adder1_result_tready = 0;
//wire [DIGIT_DIM-1:0] adder1_result_tdata;

//adder adder1(
//  .aclk(clk),
//  .s_axis_a_tvalid(adder1_a_tvalid),
//  .s_axis_a_tready(adder1_a_tready),
//  .s_axis_a_tdata(adder1_a_tdata),
//  .s_axis_b_tvalid(adder1_b_tvalid),
//  .s_axis_b_tready(adder1_b_tready),
//  .s_axis_b_tdata(adder1_b_tdata),
//  .m_axis_result_tvalid(adder1_result_tvalid),
//  .m_axis_result_tready(adder1_result_tready),
//  .m_axis_result_tdata(adder1_result_tdata)
//);

///////////////////////////////////////////*********multiplier1*********/////////////////////////////////////////////////////
reg multiplier1_en = 0;
reg multiplier1_reset = 0;
wire multiplier1_is_done;
reg [DIGIT_DIM-1:0] multiplier1_a_tdata;
reg [DIGIT_DIM-1:0] multiplier1_b_tdata;
wire [DIGIT_DIM-1:0] multiplier1_result_tdata;

fpa_multiplier multiplier1(
    .clk(clk),
    .en(multiplier1_en),
    .reset(multiplier1_reset),
    .is_done(multiplier1_is_done),
    .num1(multiplier1_a_tdata),
    .num2(multiplier1_b_tdata),
    .num_out(multiplier1_result_tdata)
);

//reg multiplier1_a_tvalid = 0;
//wire multiplier1_a_tready;
//reg [DIGIT_DIM-1:0] multiplier1_a_tdata;
//reg multiplier1_b_tvalid = 0;
//wire multiplier1_b_tready;
//reg [DIGIT_DIM-1:0] multiplier1_b_tdata;
//reg multiplier1_result_tready = 0;
//wire multiplier1_result_tvalid;
//wire [DIGIT_DIM-1:0] multiplier1_result_tdata;

//multiplier multiplier1(
//  .aclk(clk),
//  .s_axis_a_tvalid(multiplier1_a_tvalid),
//  .s_axis_a_tready(multiplier1_a_tready),
//  .s_axis_a_tdata(prev_learning_rate),
//  .s_axis_b_tvalid(multiplier1_b_tvalid),
//  .s_axis_b_tready(multiplier1_b_tready),
//  .s_axis_b_tdata(alpha),
//  .m_axis_result_tvalid(multiplier1_result_tvalid),
//  .m_axis_result_tready(multiplier1_result_tready),
//  .m_axis_result_tdata(multiplier1_result_tdata)
//);

///////////////////////////////////////////*********multiplier1*********/////////////////////////////////////////////////////
reg multiplier2_en = 0;
reg multiplier2_reset = 0;
wire multiplier2_is_done;
reg [DIGIT_DIM-1:0] multiplier2_a_tdata;
reg [DIGIT_DIM-1:0] multiplier2_b_tdata;
wire [DIGIT_DIM-1:0] multiplier2_result_tdata;

fpa_multiplier multiplier2(
    .clk(clk),
    .en(multiplier2_en),
    .reset(multiplier2_reset),
    .is_done(multiplier2_is_done),
    .num1(multiplier2_a_tdata),
    .num2(multiplier2_b_tdata),
    .num_out(multiplier2_result_tdata)
);

//reg multiplier2_a_tvalid = 0;
//wire multiplier2_a_tready;
//reg [DIGIT_DIM-1:0] multiplier2_a_tdata;

//reg multiplier2_b_tvalid = 0;
//wire multiplier2_b_tready;
//reg [DIGIT_DIM-1:0] multiplier2_b_tdata;

//reg multiplier2_result_tready = 0;
//wire multiplier2_result_tvalid;
//wire [DIGIT_DIM-1:0] multiplier2_result_tdata;

//multiplier multiplier2(
//  .aclk(clk),
//  .s_axis_a_tvalid(multiplier2_a_tvalid),
//  .s_axis_a_tready(multiplier2_a_tready),
//  .s_axis_a_tdata(multiplier1_result_tdata),
//  .s_axis_b_tvalid(multiplier2_b_tvalid),
//  .s_axis_b_tready(multiplier2_b_tready),
//  .s_axis_b_tdata(adder1_result_tdata),
//  .m_axis_result_tvalid(multiplier2_result_tvalid),
//  .m_axis_result_tready(multiplier2_result_tready),
//  .m_axis_result_tdata(multiplier2_result_tdata)
//);

reg [DIGIT_DIM-1:0] out;
reg done = 0;
reg init = 1;

reg step_1 = 0;
reg step_2 = 0;
reg step_3 = 0;
reg step_4 = 0;

reg signed [23:0] shift_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done = 0;
        init = 1;
        
    end else if (en && init) begin
        out = 0;
        
        $display("R/node_count");
        
        divider1_a_tdata = R;
        divider1_b_tdata = node_count;
        divider1_a_tvalid = 1;
        divider1_b_tvalid = 1;  
        divider1_result_tready = 1;  
        divider1_aresetn = 1;
        
        $display("alpha x prev_learning_rate");
        multiplier1_a_tdata = alpha;
        multiplier1_b_tdata = prev_learning_rate;
        
        multiplier1_en = 1;
        multiplier1_reset = 0;
        
//        multiplier1_a_tvalid = 1;
//        multiplier1_b_tvalid = 1;
//        multiplier1_result_tready = 1;
        
        init = 0; 
        step_1 = 1;
        
        
    end else if (en && step_1 && divider1_result_tvalid && divider1_result_tready) begin
    
        $display("1 - R/node_count");
                
        adder1_a_tdata = 32'h3F800000;
        adder1_b_tdata = divider1_result_tdata;
        adder1_b_tdata[DIGIT_DIM-1] = ~divider1_result_tdata[DIGIT_DIM-1];
        
        adder1_en = 1;
        adder1_reset = 0;
        
        divider1_aresetn = 0;
//        adder1_a_tvalid = 1;
//        adder1_b_tvalid = 1;
//        adder1_result_tready = 1;
        
        step_1 = 0; 
        step_2 = 1;   
        
        divider1_a_tvalid = 0;
        divider1_b_tvalid = 0;
        divider1_result_tready = 0;
           
    end else if (en && step_2 
                    && multiplier1_is_done 
                    && adder1_is_done) begin
        
        $display("(1 - R/node_count) x (alpha x prev_learning_rate)");
        
        multiplier2_a_tdata = multiplier1_result_tdata;
        multiplier2_b_tdata = adder1_result_tdata;
        
        multiplier2_en = 1;
        multiplier2_reset = 0;
        
//        multiplier2_a_tvalid = 1;
//        multiplier2_b_tvalid = 1;
//        multiplier2_result_tready = 1;
        
        step_2 = 0;
        step_3 = 1;
        
//        adder1_a_tvalid = 0;
//        adder1_b_tvalid = 0;
//        adder1_result_tready = 0;
        adder1_en = 0;
        adder1_reset = 1;
        
//        multiplier1_a_tvalid = 0;
//        multiplier1_b_tvalid = 0;
//        multiplier1_result_tready = 0;
        
        multiplier1_en = 0;
        multiplier1_reset = 1;
        
    end else if (step_3 && multiplier2_is_done) begin
    
        $display("assign asnwer");
        done = 1;
        out = multiplier2_result_tdata;
        step_3 = 0;
        
//        multiplier2_a_tvalid = 0;
//        multiplier2_b_tvalid = 0;
//        multiplier2_result_tready = 0;
        
        multiplier2_en = 0;
        multiplier2_reset = 1;
        
    end
end

assign is_done = done;
assign learning_rate = out;

endmodule

