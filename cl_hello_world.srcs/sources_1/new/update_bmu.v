`timescale  1 ns / 1 ps
module update_bmu
#(
    parameter DIM=4,
    parameter DIGIT_DIM=32
)
(
    input wire clk,
    input wire en,
    input wire reset,
    input wire [DIGIT_DIM-1:0] weight,
    input wire [DIGIT_DIM-1:0] train_row,
    input wire [DIGIT_DIM-1:0] alpha,
    output wire [DIGIT_DIM-1:0] updated_weight,
    output wire is_done    
);

reg [DIGIT_DIM-1:0] out;
reg en_1=1;
reg en_2=0;
reg en_3=0;
reg en_4=0;
reg done=0;

reg add_en=0;
reg add_reset;
reg [DIGIT_DIM-1:0] add_in_1;
reg [DIGIT_DIM-1:0] add_in_2;
wire [DIGIT_DIM-1:0] add_out;
wire add_done;

fpa_adder adder(
    .clk(clk),
    .en(add_en),
    .reset(add_reset),
    .num1(add_in_1),
    .num2(add_in_2),
    .num_out(add_out),
    .is_done(add_done)
);

//reg adder1_a_tvalid = 0;
//wire adder1_a_tready;
//reg adder1_b_tvalid = 0;
//wire adder1_b_tready;
//wire adder1_result_tvalid;
//reg adder1_result_tready = 0;

//adder adder1 (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(adder1_a_tvalid),            
//  .s_axis_a_tready(adder1_a_tready),            
//  .s_axis_a_tdata(add_in_1),              
//  .s_axis_b_tvalid(adder1_b_tvalid),           
//  .s_axis_b_tready(adder1_b_tready),            
//  .s_axis_b_tdata(add_in_2),              
//  .m_axis_result_tvalid(adder1_result_tvalid),  
//  .m_axis_result_tready(adder1_result_tready),  
//  .m_axis_result_tdata(add_out)    
//);

//reg adder2_a_tvalid = 0;
//wire adder2_a_tready;
//reg adder2_b_tvalid = 0;
//wire adder2_b_tready;
//wire adder2_result_tvalid;
//reg adder2_result_tready = 0;
//wire [DIGIT_DIM-1:0] add_out_2;

//adder adder2 (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(adder2_a_tvalid),            
//  .s_axis_a_tready(adder2_a_tready),            
//  .s_axis_a_tdata(weight),              
//  .s_axis_b_tvalid(adder2_b_tvalid),           
//  .s_axis_b_tready(adder2_b_tready),            
//  .s_axis_b_tdata(mul_out),              
//  .m_axis_result_tvalid(adder2_result_tvalid),  
//  .m_axis_result_tready(adder2_result_tready),  
//  .m_axis_result_tdata(add_out_2)    
//);

reg mul_en=0;
reg mul_reset;
reg [DIGIT_DIM-1:0] mul_in_1;
reg [DIGIT_DIM-1:0] mul_in_2;
wire [DIGIT_DIM-1:0] mul_out;
wire mul_done;

fpa_multiplier multiplier(
    .clk(clk),
    .en(mul_en),
    .reset(mul_reset),
    .num1(mul_in_1),
    .num2(mul_in_2),
    .num_out(mul_out),
    .is_done(mul_done)
);

//reg multiplier1_a_tvalid = 0;
//wire multiplier1_a_tready;
//reg multiplier1_b_tvalid = 0;
//wire multiplier1_b_tready;
//wire multiplier1_result_tvalid;
//reg multiplier1_result_tready = 0;

//multiplier multiplier1 (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(multiplier1_a_tvalid),           
//  .s_axis_a_tready(multiplier1_a_tready),   
//  .s_axis_a_tdata(mul_in_1),             
//  .s_axis_b_tvalid(multiplier1_b_tvalid),            
//  .s_axis_b_tready(multiplier1_b_tready),            
//  .s_axis_b_tdata(mul_in_2),            
//  .m_axis_result_tvalid(multiplier1_result_tvalid),  
//  .m_axis_result_tready(multiplier1_result_tready), 
//  .m_axis_result_tdata(mul_out)  
//);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done = 0;
        en_1 = 1;

    end else begin

        if (en && en_1) begin
            
            add_in_1 = weight;
            add_in_2 = train_row;
            add_in_1[DIGIT_DIM-1] = ~add_in_1[DIGIT_DIM-1]; // indicate subtraction
            
            add_reset = 0;
            add_en = 1; 
//            adder1_a_tvalid = 1;
//            adder1_b_tvalid = 1;
//            adder1_result_tready = 1;            
            en_1=0; // off this block
            en_2=1; // on next block

        end else if (en && en_2 && add_done) begin // add_done
    
            add_en=0; 
            add_reset = 1;            
//            adder1_a_tvalid = 0;
//            adder1_b_tvalid = 0;
//            adder1_result_tready = 0;   
         
            mul_in_1 = add_out;
            mul_in_2 = alpha;            
            mul_reset = 0;
            mul_en = 1; 
//            multiplier1_a_tvalid = 1;
//            multiplier1_b_tvalid = 1;
//            multiplier1_result_tready = 1;     
       
            en_2=0; // off this block
            en_3=1; // on next block

        end else if (en && en_3 && mul_done) begin // mul_done
//            multiplier1_a_tvalid = 0;
//            multiplier1_b_tvalid = 0;
//            multiplier1_result_tready = 0;
            mul_en=0; 
            mul_reset = 1;
            
            add_in_1 = weight;
            add_in_2 = mul_out;
            add_reset = 0;
            add_en = 1; 
//            adder2_a_tvalid = 1;
//            adder2_b_tvalid = 1;
//            adder2_result_tready = 1;
            
            en_3=0; // off this block
            en_4=1; // on next block

        end else if (en && en_4 && add_done) begin // add_done
            add_en = 0;
            add_reset=1;
//            adder2_a_tvalid = 0;
//            adder2_b_tvalid = 0;
//            adder2_result_tready = 0;

            done=1;
            en_4=0;
        end
    end
end

assign updated_weight = add_out;
assign is_done = done;

endmodule

