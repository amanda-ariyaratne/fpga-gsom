`timescale  1 ns / 1 ps
module node #(
    parameter DIM=4,
    parameter DIGIT_DIM=32,
    parameter LOG2_NODE_SIZE=7,
    parameter CS_COUNT = 6
) (
    input clk,
    input reset,
    input [CS_COUNT-1:0] controls_in,
    
    input [LOG2_NODE_SIZE-1:0] row,
    input [LOG2_NODE_SIZE-1:0] col,
    input [DIGIT_DIM*DIM-1:0] current_input,

    input [LOG2_NODE_SIZE-1:0] winner_row,
    input [LOG2_NODE_SIZE-1:0] winner_col,
    input [DIGIT_DIM*DIM*4-1: 0] neighbor_weights,

    input [3:0] nb_radius,
    input [DIGIT_DIM-1:0] learning_rate,
    input [DIGIT_DIM-1:0] GT,
    input [DIGIT_DIM-1:0] FD,

    output [DIGIT_DIM*DIM-1:0] weight_out,
    output [DIGIT_DIM-1:0] distance,
    output [CS_COUNT-1:0] controls_out,
    output error_overflowed
);

///////////////////////////////////////////**************************variables**************************/////////////////////////////////////////////////////

reg [DIGIT_DIM*DIM-1:0] weight=0;
reg [DIGIT_DIM-1:0] error=0;
reg is_active=0;
reg [LOG2_NODE_SIZE-1:0] hz_dist = 0;
reg [LOG2_NODE_SIZE-1:0] vt_dist = 0;
reg growing_started=0;

reg [CS_COUNT-1:0] controls_out_signals = 0;
reg error_overflowed_signal = 0;

assign weight_out = weight;
assign controls_out = controls_out_signals;
assign error_overflowed = error_overflowed_signal;

///////////////////////////////////////////**************************calculate distance**************************/////////////////////////////////////////////////////
reg distance_en=0;
reg distance_reset=0;
wire distance_done;

euclidean_distance
#(
    .DIM(DIM),
    .DIGIT_DIM(DIGIT_DIM)
)
distance_module(
    .clk(clk),
    .en(distance_en),
    .reset(distance_reset),
    .weight(weight),
    .current_input(current_input),    
    .distance_out(distance),
    .is_done(distance_done)
);

///////////////////////////////////////////**************************update_bmu && update_neighbour**************************/////////////////////////////////////////////////////
reg update_en=0;
reg update_reset=0;
wire [DIGIT_DIM*DIM-1:0] update_out;
wire [DIM-1:0] update_done;

genvar update_i;
generate
    for (update_i=1; update_i<=DIM; update_i=update_i+1) begin
        update_bmu 
        #(
            .DIM(DIM),
            .DIGIT_DIM(DIGIT_DIM)
        )
        update_weight(
            .clk(clk),
            .en(update_en),
            .reset(update_reset),
            .weight(weight[(update_i*DIGIT_DIM)-1 -:DIGIT_DIM]),
            .train_row(current_input[(update_i*DIGIT_DIM)-1 -:DIGIT_DIM]),
            .alpha(learning_rate),
            .updated_weight(update_out[(update_i*DIGIT_DIM)-1 -:DIGIT_DIM]),
            .is_done(update_done[update_i-1])
        );
    end
endgenerate

///////////////////////////////////////////**************************update_node_error_spreading**************************/////////////////////////////////////////////////////
reg update_error_en = 0;
reg update_error_reset = 0;
wire update_error_is_done;
wire [DIGIT_DIM-1:0] update_error_out;

fpa_multiplier update_error(
    .clk(clk),
    .en(update_error_en),
    .reset(update_error_reset),
    .is_done(update_error_is_done),
    .num1(error),
    .num2(FD),
    .num_out(update_error_out)
);

//reg update_error_a_tvalid = 0;
//wire update_error_a_tready;
//reg update_error_b_tvalid = 0;
//wire update_error_b_tready;
//wire update_error_result_tvalid;
//reg update_error_result_tready = 0;

//multiplier update_error (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(update_error_a_tvalid),           
//  .s_axis_a_tready(update_error_a_tready),   
//  .s_axis_a_tdata(error),             
//  .s_axis_b_tvalid(update_error_b_tvalid),            
//  .s_axis_b_tready(update_error_b_tready),            
//  .s_axis_b_tdata(FD),            
//  .m_axis_result_tvalid(update_error_result_tvalid),  
//  .m_axis_result_tready(update_error_result_tready), 
//  .m_axis_result_tdata(update_error_out)  
//);

///////////////////////////////////////////**************************update_node_error**************************/////////////////////////////////////////////////////
reg error_adder_en = 0;
reg error_adder_reset = 0;
wire error_adder_is_done;
wire [DIGIT_DIM-1:0] error_adder_out;

fpa_adder error_adder(
    .clk(clk),
    .reset(error_adder_reset),
    .en(error_adder_en),
    .is_done(error_adder_is_done),
    .num1(error),
    .num2(distance),
    .num_out(error_adder_out)
          
);

//reg error_adder_a_tvalid = 0;
//wire error_adder_a_tready;
//reg error_adder_b_tvalid = 0;
//wire error_adder_b_tready;
//wire error_adder_result_tvalid;
//reg error_adder_result_tready = 0;

//adder error_adder (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(error_adder_a_tvalid),            
//  .s_axis_a_tready(error_adder_a_tready),            
//  .s_axis_a_tdata(error),              
//  .s_axis_b_tvalid(error_adder_b_tvalid),           
//  .s_axis_b_tready(error_adder_b_tready),            
//  .s_axis_b_tdata(distance),              
//  .m_axis_result_tvalid(error_adder_result_tvalid),  
//  .m_axis_result_tready(error_adder_result_tready),  
//  .m_axis_result_tdata(error_adder_out)    
//);

///////////////////////////////////////////**************************check error overflowed**************************/////////////////////////////////////////////////////
wire [1:0] comp_out; // wire [7:0] comp_out;
wire comp_is_done;
reg comp_en=0;
reg comp_reset=0;

fpa_comparator fpa_less_than_comparator( // ==1 less ==0 equal ==2 larger
    .clk(clk),
    .en(comp_en),
    .reset(comp_reset),
    .num1(error),
    .num2(GT),
    .num_out(comp_out),
    .is_done(comp_is_done)
);

//reg min_comparator_a_tvalid = 0;
//wire min_comparator_a_tready;
//reg min_comparator_b_tvalid = 0;
//wire min_comparator_b_tready;
//wire min_comparator_result_tvalid;
//reg min_comparator_result_tready = 0;


//less_than_comparator min_comparator (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(min_comparator_a_tvalid),            
//  .s_axis_a_tready(min_comparator_a_tready),            
//  .s_axis_a_tdata(GT),              
//  .s_axis_b_tvalid(min_comparator_b_tvalid),      
//  .s_axis_b_tready(min_comparator_b_tready),        
//  .s_axis_b_tdata(error),             
//  .m_axis_result_tvalid(min_comparator_result_tvalid),  
//  .m_axis_result_tready(min_comparator_result_tready),  
//  .m_axis_result_tdata(comp_out)   
//);

///////////////////////////////////////////**************************/////////////////////////////////////////////////////

always @(posedge clk or posedge reset) begin
    if (reset) begin
        weight = 0;
        error = 0;
        is_active = 0;
        hz_dist = 0;
        vt_dist = 0;
        growing_started=0;
        controls_out_signals = 0;
        error_overflowed_signal = 0;

    end else begin
        case(controls_in)

            // activate initial 4 nodes
            1 : begin
                if (row==50 && col==50) begin
                    weight = neighbor_weights[DIGIT_DIM*DIM*1-1 -:DIGIT_DIM*DIM];
                    is_active = 1;
                    $display("row==50 && col==50 active with weight %h", weight);

                end else if (row==50 && col==51) begin
                    weight = neighbor_weights[DIGIT_DIM*DIM*2-1 -:DIGIT_DIM*DIM];
                    is_active = 1;
                    $display("row==50 && col==51 active with weight %h", weight);

                end else if (row==51 && col==50) begin
                    weight = neighbor_weights[DIGIT_DIM*DIM*3-1 -:DIGIT_DIM*DIM];
                    is_active = 1;
                    $display("row==51 && col==50 active with weight %h", weight);

                end else if (row==51 && col==51) begin
                    weight = neighbor_weights[DIGIT_DIM*DIM*4-1 -:DIGIT_DIM*DIM];
                    is_active = 1;
                    $display("row==51 && col==51 active with weight %h", weight);

                end
                controls_out_signals[0] = 1;
            end

            // insert node 
            2 : begin
                
                if (!is_active && !controls_out_signals[1]) begin
                    if (winner_row+1 == row && winner_col == col) begin
                        weight=neighbor_weights[DIGIT_DIM*DIM*1-1 -:DIGIT_DIM*DIM];
                        is_active=1;
                        //$display("bottom row==%d && col==%d active with weight %h", row, col, weight);
    
                    end else if (winner_row == row && winner_col+1 == col) begin
                        weight=neighbor_weights[DIGIT_DIM*DIM*2-1 -:DIGIT_DIM*DIM];
                        is_active=1;
                        //$display("right row==%d && col==%d active with weight %h", row, col, weight);
    
                    end else if (winner_row-1 == row && winner_col == col) begin
                        weight=neighbor_weights[DIGIT_DIM*DIM*3-1 -:DIGIT_DIM*DIM];
                        is_active=1;
                        //$display("up row==%d && col==%d active with weight %h", row, col, weight);
    
                    end else if (winner_row == row && winner_col-1 == col) begin
                        weight=neighbor_weights[DIGIT_DIM*DIM*4-1 -:DIGIT_DIM*DIM];
                        is_active=1;
                        //$display("left row==%d && col==%d active with weight %h", row, col, weight);
    
                    end
                end
                controls_out_signals[1] = 1;

            end

            // calculate euclidean distance
            4 : begin
                if (is_active && !controls_out_signals[2]) begin
                    distance_en=1;
                    distance_reset=0;
                    if (distance_done) begin
                        //$display("row %d col %d distance %h", row, col, distance);
                        distance_en=0;
                        distance_reset=1;
                        controls_out_signals[2] = 1;
                    end 
                    
                end else
                    controls_out_signals[2] = 1;

            end

            // weight update bmu or neighbor
            8 : begin
                if (is_active && !controls_out_signals[3]) begin
                    
                    if (row > winner_row) begin 
                        vt_dist = row - winner_row;
                    end else begin 
                        vt_dist = winner_row - row;
                    end
                    if (col > winner_col) begin 
                        hz_dist = col - winner_col;
                    end else begin
                        hz_dist = winner_col - col;
                    end
    
                    // winner update
                    if (hz_dist + vt_dist == 0) begin   
                        update_en=1;
                        update_reset=0;
    
                        error_adder_en = 1;
                        error_adder_reset = 0;
//                        error_adder_a_tvalid = 1;
//                        error_adder_b_tvalid = 1;
//                        error_adder_result_tready = 1;
                            
                        if (update_done == {DIM{1'b1}} 
                            && error_adder_is_done) begin // error_adder_is_done
                            update_en=0;
                            update_reset=1;
                            
                            weight = update_out;
                            
                            error = error_adder_out;
                            // $display("learning rate %h", learning_rate);
                            //$display("winner row %d col %d weight %h error %h", row, col, weight, error);
    
                            error_adder_en = 0;
                            error_adder_reset = 1;
//                            error_adder_a_tvalid = 0;
//                            error_adder_b_tvalid = 0;
//                            error_adder_result_tready = 0;
    
                            comp_en = 1;
                            comp_reset = 0;
//                            min_comparator_a_tvalid = 1;
//                            min_comparator_b_tvalid = 1;
//                            min_comparator_result_tready = 1;
    
                            controls_out_signals[3] = 1;
                        end
    
                    // neighbor update
                    end else if (hz_dist + vt_dist <= nb_radius) begin
                        update_en=1;
                        update_reset=0;
    
                        if (update_done=={DIM{1'b1}}) begin
                            update_en=0;
                            update_reset=1;
                            weight = update_out;
                            //$display("nb_radius %d", nb_radius);
                            //$display("neighbour row %d col %d weight %h error %h", row, col, weight, error);
    
                            controls_out_signals[3] = 1;
                        end
                        
                    end else
                        controls_out_signals[3] = 1;
                    
                end else
                    controls_out_signals[3] = 1;
            end

            // decide to grow or not
            16 : begin

                if (winner_row == row && winner_col == col && !controls_out_signals[4]) begin
                    // $display("GT %h", GT);
                    if (comp_is_done) begin // comp_is_done
                        // $display("comp_out %d", comp_out);
                        if (comp_out == 1) begin
                            $display("error overflowed");
                            error_overflowed_signal = 1;
                            
                        end else begin
                            error_overflowed_signal = 0;
                            
                        end
                        
                        comp_en = 0;
                        comp_reset = 1;
//                        min_comparator_a_tvalid = 0;
//                        min_comparator_b_tvalid = 0;
//                        min_comparator_result_tready = 0;
                        
                        controls_out_signals[4] = 1;
                    end

                end else begin
                    error_overflowed_signal = 0;
                    controls_out_signals[4] = 1;
                end
                
            end

            // spread error
            32 : begin
                if (!controls_out_signals[5]) begin
                    if (winner_row==row && winner_col==col) begin 
                        error = GT;
                        // error[30:23] = GT[30:23]-1;
                        controls_out_signals[5] = 1;
    
                    end else if ((winner_row+1==row && winner_col==col) || 
                                (winner_row==row && winner_col+1==col) || 
                                (winner_row-1==row && winner_col==col) || 
                                (winner_row==row && winner_col-1==col)) begin 
    
                        update_error_en = 1;
                        update_error_reset = 0;
//                        update_error_a_tvalid = 1;
//                        update_error_b_tvalid = 1;
//                        update_error_result_tready = 1;
                        // $display("FD %h", FD);
                        if (update_error_is_done) begin // update_error_is_done
                            error = update_error_out;
                            // $display("spread row %d col %d error %h", row, col, error);
                            update_error_en = 0;
                            update_error_reset = 1;
//                            update_error_a_tvalid = 0;
//                            update_error_b_tvalid = 0;
//                            update_error_result_tready = 0;
    
                            controls_out_signals[5] = 1;
                        end
                        
                    end else controls_out_signals[5] = 1;
                    
                end
            end

            // when no signal comes in
            default: begin
                controls_out_signals = {CS_COUNT{1'b0}};
                error_overflowed_signal = 0;
            end   
        endcase      
    end
end 

endmodule


