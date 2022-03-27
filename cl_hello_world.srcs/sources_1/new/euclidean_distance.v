`timescale  1 ns / 1 ps
module euclidean_distance
#(
    parameter DIM=4,
    parameter DIGIT_DIM=32
)
(
    input wire clk,
    input wire en,
    input wire reset,
    input wire [DIGIT_DIM*DIM-1:0] weight,
    input wire [DIGIT_DIM*DIM-1:0] current_input,
    output wire [DIGIT_DIM-1:0] distance_out,
    output wire is_done
);

////////////////////module enables and disbles///////////////////////
reg done=0;
reg init=1;   
reg next_1=0;  
reg next_2=0;                
reg add_all_init=0;
reg wait_en = 0;
reg [DIGIT_DIM-1:0] out=0;
//////////////////////////////PART 1////////////////////////////
////////////////////distnace square module///////////////////////
reg dist_sqr_en=0;
reg dist_sqr_reset=0;
wire [DIGIT_DIM*DIM-1:0] dist_sqr_in_1;
wire [DIGIT_DIM*DIM-1:0] dist_sqr_in_2;
wire [DIGIT_DIM*DIM-1:0] dist_sqr_out;
wire [DIGIT_DIM*DIM-1:0] dist_sqr_done;
wire [DIM-1:0] dist_sqr_is_done;


////////////////////Get all done to one variable///////////////////////
genvar k;
generate
    for (k=1; k<=DIM; k=k+1) begin
        assign dist_sqr_is_done[k-1] = dist_sqr_done[(DIGIT_DIM*k)-1];
    end
endgenerate

////////////////////parallel blocks for distance square///////////////////////
genvar i;
generate
    for (i=DIGIT_DIM; i<=DIM*DIGIT_DIM; i=i+DIGIT_DIM) begin
        fpa_distance
        #(
            .DIM(DIM),
            .DIGIT_DIM(DIGIT_DIM)
        )
        dist_sqr(
            .clk(clk),
            .en(dist_sqr_en),
            .reset(dist_sqr_reset),
            .num1(weight[i-1 -:DIGIT_DIM]),
            .num2(current_input[i-1 -:DIGIT_DIM]),
            .num_out(dist_sqr_out[i-1 -:DIGIT_DIM]),
            .is_done(dist_sqr_done[i-1])
        );
    end
endgenerate
////////////////////add distance unit///////////////////////

//reg add_all_en=0;
//reg add_all_reset=0;
reg [DIGIT_DIM-1:0] add_all_in_1 = 0;
reg [DIGIT_DIM-1:0] add_all_in_2 = 0;
wire [DIGIT_DIM-1:0] add_all_out;
//wire add_all_done;

assign distance_out = out;
assign is_done = done;

//fpa_adder add_all(
//    .clk(clk),
//    .en(add_all_en),
//    .reset(add_all_reset),
//    .num1(add_all_in_1),
//    .num2(add_all_in_2),
//    .num_out(add_all_out),
//    .is_done(add_all_done)
//);
reg [2:0] reset_counter = 0;
reg aresetn = 1;

reg adder1_a_tvalid = 0;
wire adder1_a_tready;

reg adder1_b_tvalid = 0;
wire adder1_b_tready;

wire adder1_result_tvalid;
reg adder1_result_tready = 0;

adder_with_reset adder1 (
  .aclk(clk),
  .aresetn(aresetn),
  .s_axis_a_tvalid(adder1_a_tvalid),            
  .s_axis_a_tready(adder1_a_tready),            
  .s_axis_a_tdata(add_all_in_1),              
  .s_axis_b_tvalid(adder1_b_tvalid),           
  .s_axis_b_tready(adder1_b_tready),            
  .s_axis_b_tdata(add_all_in_2),              
  .m_axis_result_tvalid(adder1_result_tvalid),  
  .m_axis_result_tready(adder1_result_tready),  
  .m_axis_result_tdata(add_all_out)    
);

//////////////////get the square root///////////////////////
reg square_root_aresetn = 1;
reg square_root_a_tvalid = 0;
wire square_root_a_tready;
reg [DIGIT_DIM-1:0] square_root_a_tdata;

wire square_root_r_tvalid;
reg square_root_r_tready = 0;
wire [DIGIT_DIM-1:0] square_root_r_tdata;

square_root_with_reset square_root1(
  .aclk(clk),
  .aresetn(square_root_aresetn),
  .s_axis_a_tvalid(square_root_a_tvalid),
  .s_axis_a_tready(square_root_a_tready),
  .s_axis_a_tdata(square_root_a_tdata),
  .m_axis_result_tvalid(square_root_r_tvalid),
  .m_axis_result_tready(square_root_r_tready),
  .m_axis_result_tdata(square_root_r_tdata)
);

integer signed j=DIGIT_DIM;
////////////////////Calculate distance in parallel///////////////////////
always @(posedge clk or posedge reset) begin 
    if (reset) begin
        done=0;
        init=1;
        wait_en = 0;
        add_all_init=0;
        
        dist_sqr_en=0;
        dist_sqr_reset=1;
        
//        add_all_en=0;
//        add_all_reset=1;
        add_all_in_1=0;
        add_all_in_2=0;
        
        j=DIGIT_DIM; 
        
    end else if (en) begin
        //$display("distance to %d", dist_sqr_is_done);
        if (init) begin
            init=0;
            next_1=1;
            dist_sqr_en=1;
            dist_sqr_reset=0;   
            
        end else if (next_1 && dist_sqr_is_done == {(DIM){1'b1}}) begin
            next_1=0;
            dist_sqr_en=0;
            dist_sqr_reset=1;
            add_all_init=1;
                
        end else if (add_all_init && !wait_en) begin
            if (!aresetn && (reset_counter != 1)) begin
                reset_counter = reset_counter +1;
                
            end else begin
                reset_counter = 0;
                aresetn = 1;
                add_all_in_2 = dist_sqr_out[j-1 -:DIGIT_DIM];
                adder1_a_tvalid = 1;
                adder1_b_tvalid = 1;
                adder1_result_tready = 1;
                wait_en = 1;
            end
            
        end else if (add_all_init && adder1_result_tvalid && adder1_result_tready) begin // add_all_done
            add_all_in_1 = add_all_out;
            j = j + DIGIT_DIM;
            adder1_a_tvalid = 0;
            adder1_b_tvalid = 0;
            adder1_result_tready = 0;            
            
            if (j > DIGIT_DIM*DIM) begin
                add_all_init = 0;
                
                out = add_all_out; done = 1; // square_root_a_tdata = add_all_out;
//                square_root_a_tvalid = 1;
//                square_root_r_tready = 1;
//                square_root_aresetn = 1;
                
            end else begin
                wait_en = 0;
                aresetn = 0;
            end
                
//        end else if (square_root_r_tvalid && square_root_r_tready) begin
//            out = square_root_r_tdata;
//            square_root_a_tvalid = 0;
//            square_root_r_tready = 0;
//            square_root_aresetn = 0; // active low
//            done = 1;
            
        end
    end
end

endmodule

