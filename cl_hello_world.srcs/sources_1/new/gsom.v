`timescale 1ns / 1ps

module gsom
#(
    parameter DIM = 4,
    parameter LOG2_DIM = 3, 
    parameter DIGIT_DIM = 32,
    parameter CS_COUNT = 6,
    
    parameter INIT_ROWS = 2,
    parameter INIT_COLS = 2,
    
//    parameter MAX_ROWS = 10,
//    parameter MAX_COLS = 10,
    
//    parameter LOG2_ROWS = 4,         
//    parameter LOG2_COLS = 4,

    parameter MAX_NODE_SIZE = 100,
    parameter LOG2_NODE_SIZE = 8,
    
    parameter GROWING_ITERATIONS = 1,
    parameter LOG2_GROWING_ITERATIONS = 5,
    parameter SMOOTHING_ITERATIONS = 10,
    parameter LOG2_SMOOTHING_ITERATIONS = 4,
    parameter delta_growing_iter = 5,
    parameter delta_smoothing_iter = 3,
    
    parameter TRAIN_ROWS = 75,
    parameter LOG2_TRAIN_ROWS = 7,
    parameter TEST_ROWS = 150,
    parameter LOG2_TEST_ROWS = 8, 
    
    parameter LOG2_NUM_CLASSES = 2,
    
    // model parameters
    parameter spread_factor = 32'h3DCCCCCD, //0.1
    parameter spread_factor_logval = 32'hBF800000, // BF800000 = -1
    
    parameter GT = 32'h41135D8E, //9.21034037198 = -4*ln(spread_factor)
    parameter learning_rate=32'h3E99999A, // 0.3
    parameter smooth_learning_factor= 32'h3F4CCCCD, //0.8
    parameter max_radius=4,
    parameter FD=32'h3F8CCCCD, //1.1
    parameter r=32'h40733333, //3.8
    parameter alpha=32'h3F666666 //0.9
)
(
    input clk,
    input reset,
    input [DIGIT_DIM*DIM-1:0] x,
    input [LOG2_NODE_SIZE-1:0] weight_out_index,
    output get_next_x,
    output done_training,
    output [DIGIT_DIM*DIM-1:0] weight_out
);

///////////////////////////////////////////**************************variables**************************/////////////////////////////////////////////////////

reg [LOG2_NODE_SIZE-1:0] node_count = 0;
reg [DIGIT_DIM-1:0] node_count_ieee754 = 32'h00000000;

reg [DIGIT_DIM-1:0] growth_threshold = GT;
reg signed [3:0] radius;
reg [DIGIT_DIM-1:0] current_learning_rate;
reg signed [LOG2_GROWING_ITERATIONS:0] iteration;

reg signed [LOG2_TRAIN_ROWS:0] t1 = 0;
reg signed [LOG2_TEST_ROWS:0] t2 = 0;

reg init_gsom = 1;
reg fit_en = 0;
reg growing_iter_en = 0;
reg smoothing_iter_en = 0;
reg get_LR_en = 0;
reg grow_en = 0;
reg smooth_en = 0;
reg weights_update=0;
reg adjust_weights_en=0;
reg smoothing_en=0;
reg spread_weighs_en=0;
reg grow_nodes_en=0;

reg next_iteration_en = 0;
reg next_t1_en = 0;

reg dist_enable = 0;
reg init_neigh_search_en=0;  
reg nb_search_en=0;
reg not_man_dist_en=0;
reg write_en = 0;
reg is_completed = 0;
reg min_distance_en=0;
reg bmu_en=0;
reg test_mode=0;
reg classification_en=0;

reg [DIGIT_DIM-1:0] min_distance;
integer matrix_i, matrix_j;

reg [LOG2_NODE_SIZE-1:0] bmu [1:0];

reg [LOG2_NODE_SIZE-1:0] left_j, right_j, up_j, bottom_j;
reg [LOG2_NODE_SIZE-1:0] left_i, right_i, up_i, bottom_i;    
reg [LOG2_NODE_SIZE-1:0] up_index, right_index, bottom_index, left_index;

reg up = 1, right = 1, bottom = 1, left =1;
///////////////////////////////////////////**************************initialize_inputs**************************/////////////////////////////////////////////////////

reg [DIGIT_DIM*DIM-1:0] trainX;    
reg [DIGIT_DIM*DIM-1:0] random_weights [INIT_ROWS + INIT_COLS - 1:0];

//reg [DIGIT_DIM*DIM*4-1: 0] neighbor_weights;

reg [DIGIT_DIM*DIM-1: 0] up_weight;
reg [DIGIT_DIM*DIM-1: 0] right_weight;
reg [DIGIT_DIM*DIM-1: 0] bottom_weight;
reg [DIGIT_DIM*DIM-1: 0] left_weight;

initial begin
    $readmemb("gsom_weights.mem", random_weights);
    up_weight = random_weights[0];
    right_weight = random_weights[1];
    bottom_weight = random_weights[2];
    left_weight = random_weights[3];
end


///////////////////////////////////////////**************************weight_modules**************************/////////////////////////////////////////////////////
reg [DIGIT_DIM-1:0] p_inf = 32'b0_11111111_00000000_00000000_0000000;
reg [DIGIT_DIM-1:0] n_inf = 32'b1_11111111_00000000_00000000_0000000;

reg [CS_COUNT-1:0] controls_in=0;



wire [DIGIT_DIM*DIM-1 :0] weights [MAX_NODE_SIZE-1: 0];
//LOG2_NODE_SIZE

reg [LOG2_NODE_SIZE-1:0] coordinate_map [MAX_NODE_SIZE: 0][1:0];
wire [DIGIT_DIM-1 :0] distances [MAX_NODE_SIZE-1: 0];
wire [MAX_NODE_SIZE-1: 0] controls_out [CS_COUNT-1:0];
wire [MAX_NODE_SIZE-1: 0] error_overflowed;

genvar i, j;
generate
    for (i = 0; i < MAX_NODE_SIZE; i = i + 1) begin
        node #(
            .DIM(DIM),
            .DIGIT_DIM(DIGIT_DIM),
            .LOG2_NODE_SIZE(LOG2_NODE_SIZE),
            .CS_COUNT(CS_COUNT)
        ) weight_module(
            .clk(clk),
            .reset(reset),
            .controls_in(controls_in),

            .row(coordinate_map[i][1]),
            .col(coordinate_map[i][0]),
            .current_input(trainX),

            .winner_row(bmu[1]),
            .winner_col(bmu[0]),
            .neighbor_weights({left_weight, bottom_weight, right_weight, up_weight}),

            .nb_radius(radius),
            .learning_rate(current_learning_rate),
            .GT(GT),
            .FD(FD),

            .weight_out(weights[i]),
            .distance(distances[i]),
            .controls_out({controls_out[5][i], controls_out[4][i], controls_out[3][i], controls_out[2][i], controls_out[1][i], controls_out[0][i]}),
            .error_overflowed(error_overflowed[i])
        );
    end
endgenerate

///////////////////////////////////////////**************************new_node_in_middle**************************/////////////////////////////////////////////////////
reg [DIGIT_DIM*DIM-1:0] winner;

reg [DIGIT_DIM*DIM-1:0] up_new_node_next_node;

reg up_new_node_in_middle_en = 0;
reg up_new_node_in_middle_reset = 1;
wire [DIM-1:0] up_new_node_in_middle_is_done;
wire [DIGIT_DIM*DIM-1:0] up_new_node_in_middle_weight;

reg up_new_node_on_one_side_en = 0;
reg up_new_node_on_one_side_reset = 1;
wire [DIM-1:0] up_new_node_on_one_side_is_done;
wire [DIGIT_DIM*DIM-1:0] up_new_node_on_one_side_weight;

reg [DIGIT_DIM*DIM-1:0] right_new_node_next_node;

reg right_new_node_in_middle_en = 0;
reg right_new_node_in_middle_reset = 1;
wire [DIM-1:0] right_new_node_in_middle_is_done;
wire [DIGIT_DIM*DIM-1:0] right_new_node_in_middle_weight;

reg right_new_node_on_one_side_en = 0;
reg right_new_node_on_one_side_reset = 1;
wire [DIM-1:0] right_new_node_on_one_side_is_done;
wire [DIGIT_DIM*DIM-1:0] right_new_node_on_one_side_weight;

reg [DIGIT_DIM*DIM-1:0] bottom_new_node_next_node;

reg bottom_new_node_in_middle_en = 0;
reg bottom_new_node_in_middle_reset = 1;
wire [DIM-1:0] bottom_new_node_in_middle_is_done;
wire [DIGIT_DIM*DIM-1:0] bottom_new_node_in_middle_weight;

reg bottom_new_node_on_one_side_en = 0;
reg bottom_new_node_on_one_side_reset = 1;
wire [DIM-1:0] bottom_new_node_on_one_side_is_done;
wire [DIGIT_DIM*DIM-1:0] bottom_new_node_on_one_side_weight;

reg [DIGIT_DIM*DIM-1:0] left_new_node_next_node;

reg left_new_node_in_middle_en = 0;
reg left_new_node_in_middle_reset = 1;
wire [DIM-1:0] left_new_node_in_middle_is_done;
wire [DIGIT_DIM*DIM-1:0] left_new_node_in_middle_weight;

reg left_new_node_on_one_side_en = 0;
reg left_new_node_on_one_side_reset = 1;
wire [DIM-1:0] left_new_node_on_one_side_is_done;
wire [DIGIT_DIM*DIM-1:0] left_new_node_on_one_side_weight;

genvar nim_dim_i;
generate
    for (nim_dim_i=0; nim_dim_i<DIM; nim_dim_i=nim_dim_i+1) begin
        grow_node_in_middle 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        up_grow_node_in_middle_module(
            .clk(clk),
            .reset(up_new_node_in_middle_reset),
            .en(up_new_node_in_middle_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(up_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(up_new_node_in_middle_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(up_new_node_in_middle_is_done[nim_dim_i])
        );
    
        grow_node_on_one_side 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        up_grow_node_on_one_side_module(
            .clk(clk),
            .reset(up_new_node_on_one_side_reset),
            .en(up_new_node_on_one_side_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(up_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(up_new_node_on_one_side_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(up_new_node_on_one_side_is_done[nim_dim_i])
        );
    
        grow_node_in_middle 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        right_grow_node_in_middle_module(
            .clk(clk),
            .reset(right_new_node_in_middle_reset),
            .en(right_new_node_in_middle_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(right_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(right_new_node_in_middle_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(right_new_node_in_middle_is_done[nim_dim_i])
        );
    
        grow_node_on_one_side 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        right_grow_node_on_one_side_module(
            .clk(clk),
            .reset(right_new_node_on_one_side_reset),
            .en(right_new_node_on_one_side_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(right_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(right_new_node_on_one_side_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(right_new_node_on_one_side_is_done[nim_dim_i])
        );
    
        grow_node_in_middle 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        bottom_grow_node_in_middle_module(
            .clk(clk),
            .reset(bottom_new_node_in_middle_reset),
            .en(bottom_new_node_in_middle_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(bottom_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(bottom_new_node_in_middle_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(bottom_new_node_in_middle_is_done[nim_dim_i])
        );
    
        grow_node_on_one_side 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        bottom_grow_node_on_one_side_module(
            .clk(clk),
            .reset(bottom_new_node_on_one_side_reset),
            .en(bottom_new_node_on_one_side_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(bottom_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(bottom_new_node_on_one_side_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(bottom_new_node_on_one_side_is_done[nim_dim_i])
        );
    
        grow_node_in_middle 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        left_grow_node_in_middle_module(
            .clk(clk),
            .reset(left_new_node_in_middle_reset),
            .en(left_new_node_in_middle_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(left_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(left_new_node_in_middle_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(left_new_node_in_middle_is_done[nim_dim_i])
        );
    
        grow_node_on_one_side 
        #(
            .DIGIT_DIM(DIGIT_DIM)
        )
        left_grow_node_on_one_side_module(
            .clk(clk),
            .reset(left_new_node_on_one_side_reset),
            .en(left_new_node_on_one_side_en),
            .winner(winner[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM ]),
            .node_next(left_new_node_next_node[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .weight(left_new_node_on_one_side_weight[(DIGIT_DIM*(nim_dim_i+1))-1 -:DIGIT_DIM] ),
            .is_done(left_new_node_on_one_side_is_done[nim_dim_i])
        );
    end
endgenerate
///////////////////////////////////////////**************************learning_rate**************************/////////////////////////////////////////////////////
reg lr_en = 0;
reg lr_reset = 0;
wire [DIGIT_DIM-1:0] lr_out;
wire lr_is_done;

gsom_learning_rate lr(
    .clk(clk), .en(lr_en), .reset(lr_reset),
    .node_count(node_count_ieee754),
    .prev_learning_rate(current_learning_rate),
    .alpha(alpha),
    .learning_rate(lr_out),
    .is_done(lr_is_done)
);

///////////////////////////////////////////**************************node_count_adder**************************/////////////////////////////////////////////////////
reg [LOG2_NODE_SIZE-1:0] no_of_new_node;
reg [LOG2_NODE_SIZE-1:0] old_node_count;

reg node_count_adder_en = 0;
reg node_count_adder_reset = 0;
wire node_count_adder_is_done;

reg [DIGIT_DIM-1:0] nca_count = 0;
wire [DIGIT_DIM-1:0] nca_num_out;


fpa_adder fpa_node_count_adder(
    .clk(clk),
    .reset(node_count_adder_reset),
    .en(node_count_adder_en),
    .num1(node_count_ieee754),
    .num2(nca_count),
    .num_out(nca_num_out),
    .is_done(node_count_adder_is_done)        
);

//reg node_count_adder_a_tvalid = 0;
//wire node_count_adder_a_tready;
//reg node_count_adder_b_tvalid = 0;
//wire node_count_adder_b_tready;
//wire node_count_adder_result_tvalid;
//reg node_count_adder_result_tready = 0;

//adder node_count_adder (
//  .aclk(clk),                                  
//  .s_axis_a_tvalid(node_count_adder_a_tvalid),            
//  .s_axis_a_tready(node_count_adder_a_tready),            
//  .s_axis_a_tdata(node_count_ieee754),              
//  .s_axis_b_tvalid(node_count_adder_b_tvalid),            
//  .s_axis_b_tready(node_count_adder_b_tready),            
//  .s_axis_b_tdata(nca_count),              
//  .m_axis_result_tvalid(node_count_adder_result_tvalid),  
//  .m_axis_result_tready(node_count_adder_result_tready),  
//  .m_axis_result_tdata(nca_num_out)    
//);


///////////////////////////////////////////**************************get_min**************************/////////////////////////////////////////////////////
reg [DIGIT_DIM-1:0] comp_in_1=0;
reg [DIGIT_DIM-1:0] comp_in_2=0;
//wire [7:0] comp_out; 

wire [1:0] comp_out;
wire comp_done;
reg comp_en=0;
reg comp_reset=0;
reg [1:0] comp_reset_counter = 0;

fpa_comparator get_min(
    .clk(clk),
    .en(comp_en),
    .reset(comp_reset),
    .num1(comp_in_1),
    .num2(comp_in_2),
    .num_out(comp_out),
    .is_done(comp_done)
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
//  .s_axis_a_tdata(comp_in_1),              
//  .s_axis_b_tvalid(min_comparator_b_tvalid),      
//  .s_axis_b_tready(min_comparator_b_tready),        
//  .s_axis_b_tdata(comp_in_2),             
//  .m_axis_result_tvalid(min_comparator_result_tvalid),  
//  .m_axis_result_tready(min_comparator_result_tready),  
//  .m_axis_result_tdata(comp_out)   
//);

///////////////////////////////////////////**************************multiplier**************************/////////////////////////////////////////////////////
reg multi_en = 0;
reg multi_reset = 0;
wire multi_is_done;
reg [DIGIT_DIM-1:0] multi_num1;
reg [DIGIT_DIM-1:0] multi_num2;
wire [DIGIT_DIM-1:0] multi_num_out;

fpa_multiplier multiplier(
    .clk(clk),
    .en(multi_en),
    .reset(multi_reset),
    .is_done(multi_is_done),
    .num1(multi_num1),
    .num2(multi_num2),
    .num_out(multi_num_out)
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
//  .s_axis_a_tdata(multi_num1),             
//  .s_axis_b_tvalid(multiplier1_b_tvalid),            
//  .s_axis_b_tready(multiplier1_b_tready),            
//  .s_axis_b_tdata(multi_num2),            
//  .m_axis_result_tvalid(multiplier1_result_tvalid),  
//  .m_axis_result_tready(multiplier1_result_tready), 
//  .m_axis_result_tdata(multi_num_out)  
//);

///////////////////////////////////////////**************************check_is_in_map**************************/////////////////////////////////////////////////////
integer active_i;
function [LOG2_NODE_SIZE-1:0] is_active_in_map;
    input [LOG2_NODE_SIZE-1:0] coord_i;
    input [LOG2_NODE_SIZE-1:0] coord_j;
    
    begin
        is_active_in_map = 0;
        for (active_i=1; active_i<=MAX_NODE_SIZE; active_i=active_i+1) begin
            if (active_i <= node_count) begin
                if (coordinate_map[active_i][1]==coord_i && coordinate_map[active_i][0]==coord_j)
                    is_active_in_map = active_i;
            end
        end
    end
endfunction

///////////////////////////////////////////**************************always block**************************/////////////////////////////////////////////////////

always @(posedge clk) begin
    if (init_gsom) begin
        coordinate_map[0][1] = 50;
        coordinate_map[0][0] = 50;
        
        coordinate_map[1][1] = 50;
        coordinate_map[1][0] = 51;
        
        coordinate_map[2][1] = 51;
        coordinate_map[2][0] = 50;
        
        coordinate_map[3][1] = 51;
        coordinate_map[3][0] = 51;
        
        $display("gsom init started");
        controls_in[0] = 1;
        // Todo : don't know whether this is correct or not
        
        
        if (controls_out[0] == { MAX_NODE_SIZE{1'b1} }) begin
            $display("initialized first four nodes");
            controls_in[0] = 0;
            node_count = 4;        
            node_count_ieee754 = 32'h40800000;
            init_gsom = 0;
            fit_en = 1;
            growing_iter_en = 1;
            $display("gsom init finished");
        end
        
    end else if (fit_en && growing_iter_en) begin
        $display("fit_en && growing_iter_en");
        current_learning_rate = learning_rate;
        iteration = -1;            
        next_iteration_en = 1;
        fit_en = 0;

    end else if (fit_en && smoothing_iter_en) begin
        $display("fit_en && smoothing_iter_en");
        multi_num1 = learning_rate;
        multi_num2 = smooth_learning_factor;
        
        multi_en = 1;
        multi_reset = 0;
        
//        multiplier1_a_tvalid = 1;
//        multiplier1_b_tvalid = 1;
//        multiplier1_result_tready = 1;
        
        if (multi_is_done) begin // multi_is_done
            current_learning_rate = multi_num_out;
            
            multi_en = 0;
            multi_reset = 1;

//            multiplier1_a_tvalid = 0;
//            multiplier1_b_tvalid = 0;
//            multiplier1_result_tready = 0;
            
            iteration = -1;
            next_iteration_en = 1;
            fit_en = 0;
        end

    end else if (next_iteration_en && growing_iter_en) begin
        $display("next_iteration_en && growing_iter_en");
        if (iteration < GROWING_ITERATIONS) begin
            iteration = iteration + 1;
            
            // neighbourhood                
            if (iteration <= delta_growing_iter) begin
                radius = 4;
            end else if ((iteration <= delta_growing_iter*2) && (iteration > delta_growing_iter*1)) begin
                radius = 2;
            end else if ((iteration <= delta_growing_iter*3) && (iteration > delta_growing_iter*2)) begin
                radius = 1;
            end 
            
            $display("growing iteration %d \t radius %d", iteration, radius);
            
            // learning rate
            if (iteration != 0) begin
                get_LR_en = 1;

            end else begin
                current_learning_rate = learning_rate;
                grow_en = 1;
            end
        end else begin
            fit_en = 1;
            smoothing_iter_en = 1;                
            growing_iter_en = 0;
        end
        next_iteration_en = 0;

    end else  if (get_LR_en && growing_iter_en) begin
        $display("get_LR_en && growing_iter_en");
        lr_reset = 0;
        lr_en = 1;
        if (lr_is_done) begin
            lr_en = 0;
            lr_reset = 1;
            current_learning_rate = lr_out;
            get_LR_en = 0;
            grow_en = 1;
        end

    end else if (grow_en) begin    
        $display("grow_en");
        grow_en = 0;
        t1 = -1;
        next_t1_en = 1;

    end else if (next_iteration_en && smoothing_iter_en) begin
        $display("next_iteration_en && smoothing_iter_en");
        if (iteration < SMOOTHING_ITERATIONS) begin
            iteration = iteration + 1;

            // neighbourhood                
            if (iteration <= delta_smoothing_iter) begin
                radius = 4;                
            end else if ((iteration <= delta_smoothing_iter*2) && (iteration > delta_smoothing_iter*1)) begin
                radius = 2;
            end else if ((iteration <= delta_smoothing_iter*3) && (iteration > delta_smoothing_iter*2)) begin
                radius = 1;
            end 
            
            $display("smoothing iteration %d \t radius %d", iteration, radius);
            
            // learning rate
            if (iteration != 0)
                get_LR_en = 1;
            else 
                smooth_en = 1;
            
            next_iteration_en = 0;

        end else begin
            iteration = -1;
            // write_en = 1;
            is_completed = 1;
            smoothing_iter_en = 0;
        end

    end else if (get_LR_en && smoothing_iter_en) begin
        $display("get_LR_en && smoothing_iter_en");
        lr_en = 1;
        lr_reset = 0;
        if (lr_is_done) begin
            lr_en = 0;
            lr_reset = 1;
            current_learning_rate = lr_out;
            get_LR_en = 0;
            smooth_en = 1;
        end

    end else if (smooth_en) begin
        $display("smooth_en");
        smooth_en = 0;
        t1 = -1;
        next_t1_en = 1;

    end else if (next_t1_en) begin
        $display("next_t1_en");
        if (t1 < TRAIN_ROWS-1) begin
            t1 = t1 + 1; 
            trainX = x;
            $display("iteration %d \t t1 %d \t node count %d \t input %h", iteration, t1, node_count, trainX);
            dist_enable = 1;
            
        end else begin
            next_iteration_en = 1;
        end
        next_t1_en = 0;

    end else if (dist_enable) begin
        $display("dist_enable");
        controls_in[2] = 1;

        if (controls_out[2] == { MAX_NODE_SIZE{1'b1} }) begin
            $display("finished distance calculation");
            controls_in[2] = 0;
            matrix_i = 0;
            min_distance = p_inf;
            dist_enable = 0;
            min_distance_en = 1;
            comp_reset = 0; //  to start immediately
        end

    end else if (min_distance_en) begin
        $display("min_distance_en");
        if (comp_reset) begin
            comp_reset_counter = comp_reset_counter + 1;
            if (comp_reset_counter == 2)
                comp_reset = 0;
            
        end else if (matrix_i <= node_count) begin
            
            comp_in_1 = distances[matrix_i];
            comp_in_2 = min_distance;
            comp_en = 1;
//            min_comparator_a_tvalid = 1;
//            min_comparator_b_tvalid = 1;
//            min_comparator_result_tready = 1;
            
            if (comp_done) begin    
                
                if (comp_out == 2) begin // == 1 when ipcore
                    bmu[1] = coordinate_map[matrix_i][1];
                    bmu[0] = coordinate_map[matrix_i][0];
                    min_distance = distances[matrix_i];
                    
                end
                
                matrix_i = matrix_i + 1;
                if (matrix_i >= node_count) begin
                    $display("bmu ", bmu[1], bmu[0]);
                    min_distance_en=0;
                    weights_update=1;
                end
                
                comp_en = 0;
                comp_reset = 1;
//                min_comparator_a_tvalid = 0;
//                min_comparator_b_tvalid = 0;
//                min_comparator_result_tready = 0;
                
            end
        end else begin
            matrix_i = matrix_i + 1;
            if (matrix_i >= node_count) begin
                $display("bmu ", bmu[1], bmu[0]);
                min_distance_en=0;
                weights_update=1;
            end
        end
        
    end else if (weights_update) begin
        $display("weights_update");
        // update weights
        controls_in[3] = 1;            
        if (controls_out[3] == { MAX_NODE_SIZE{1'b1} }) begin
            $display("finished weights update");
            controls_in[3] = 0;
            weights_update = 0;
            if (growing_iter_en)
                adjust_weights_en = 1;
            else 
                next_t1_en = 1;
        end

    end else if (adjust_weights_en) begin
        $display("adjust_weights_en");
        // winner error > GT        
        controls_in[4] = 1;
        if (controls_out[4] == { MAX_NODE_SIZE{1'b1} }) begin
            controls_in[4] = 0;

            if (^error_overflowed) begin
                $display("error > GT");
                // spread or grow
                left_j = bmu[0]-1;    left_i = bmu[1];
                right_j = bmu[0]+1;   right_i = bmu[1];
                up_j = bmu[0];        up_i = bmu[1]+1;
                bottom_j = bmu[0];    bottom_i = bmu[1]-1;
                
                up_index = is_active_in_map(up_i, up_j);
                right_index = is_active_in_map(right_i, right_j);
                bottom_index = is_active_in_map(bottom_i, bottom_j);
                left_index = is_active_in_map(left_i, left_j);
                
                if (is_active_in_map(left_i, left_j) != 0 
                    && is_active_in_map(right_i, right_j) != 0 
                    && is_active_in_map(up_i, up_j) != 0 
                    && is_active_in_map(bottom_i, bottom_j) != 0 ) begin
                    
                    spread_weighs_en = 1;  
                    $display("decided to spread weight"); 

                end else begin
                    $display("decided to grow nodes");
                    
                    
                    
                    grow_nodes_en = 1;
                    winner = weights[bmu[1]][bmu[0]];
                end
                adjust_weights_en = 0;       

            end else begin
                next_t1_en = 1;
                bmu_en=0;
            end
        end
        

    end else if (spread_weighs_en) begin
        // spread error
        controls_in[5] = 1;
        if (controls_out[5] == { MAX_NODE_SIZE{1'b1} }) begin
            controls_in[5] = 0;    
            next_t1_en = 1;    
            spread_weighs_en = 0;      
             
        end

    end else if (grow_nodes_en && up && right && bottom && left) begin
        $display("grow_nodes_en && up && right && bottom && left");
        
        old_node_count = node_count;
        no_of_new_node = 0;
        
        if (up_index == 0) begin
            coordinate_map[node_count][1] = up_i;
            coordinate_map[node_count][0] = up_j;
            node_count = node_count + 1;           
        end 
        if (right_index == 0) begin
            coordinate_map[node_count][1] = right_i;
            coordinate_map[node_count][0] = right_j;    
            node_count = node_count + 1;     
        end
        if (bottom_index == 0) begin
            coordinate_map[node_count][1] = bottom_i;
            coordinate_map[node_count][0] = bottom_j;    
            node_count = node_count + 1;   
        end
        if (left_index == 0) begin
            coordinate_map[node_count][1] = left_i;
            coordinate_map[node_count][0] = left_j;  
            node_count = node_count + 1;      
        end
        
        // grow nodes
        grow_nodes_en = 0;
        controls_in[1] = 1;
        
        no_of_new_node = node_count - old_node_count;
        if (no_of_new_node==1)
            nca_count = 32'h3F800000;
        else if (no_of_new_node==2)
            nca_count = 32'h40000000;
        else if (no_of_new_node==3)
            nca_count = 32'h40400000;
            
        node_count_adder_en = 1;
        node_count_adder_reset = 0;
//        node_count_adder_a_tvalid = 1;
//        node_count_adder_b_tvalid = 1;
//        node_count_adder_result_tready = 1;
        
    end else if (controls_in[1]) begin
        //$display("controls_in[1]");
        if (controls_out[1] == { MAX_NODE_SIZE {1'b1} } 
                && node_count_adder_is_done) begin // node_count_adder_is_done
            controls_in[1] = 0;
            next_t1_en = 1; 
            
            node_count_ieee754 = nca_num_out;
            
            node_count_adder_en = 0;
            node_count_adder_reset = 1;
//            node_count_adder_a_tvalid = 0;
//            node_count_adder_b_tvalid = 0;
//            node_count_adder_result_tready = 0;
            //$display("node count %d %h", node_count, node_count_ieee754);
        end
    end
end

always @(posedge clk) begin

    // check if node should be added
    if (grow_nodes_en && !up && (is_active_in_map(up_i, up_j) == 0) && !up_new_node_in_middle_en && !up_new_node_on_one_side_en) begin
        // new node up to the winner
        if (is_active_in_map(up_i+1, up_j) != 0) begin
            up_new_node_in_middle_en = 1;
            up_new_node_in_middle_reset = 0;
            up_new_node_next_node = weights[up_i+1][up_j];
            // $display("up 1 %d %d %h %h", up_i, up_j, up_new_node_next_node, winner);

        end else if ( is_active_in_map(bmu[1]-1, bmu[0])  != 0) begin
            up_new_node_on_one_side_en = 1;
            up_new_node_on_one_side_reset = 0;
            up_new_node_next_node = weights[bmu[1]-1][bmu[0]];
            // $display("up 1 %d %d %h %h", up_i, up_j, up_new_node_next_node, winner);

        end else if (is_active_in_map(bmu[1], bmu[0]+1)  != 0) begin
            up_new_node_on_one_side_en = 1;
            up_new_node_on_one_side_reset = 0;
            up_new_node_next_node = weights[bmu[1]][bmu[0]+1];
            // $display("up 1 %d %d %h %h", up_i, up_j, up_new_node_next_node, winner);

        end else if (is_active_in_map(bmu[1], bmu[0]-1)  != 0) begin
            up_new_node_on_one_side_en = 1;
            up_new_node_on_one_side_reset = 0;
            up_new_node_next_node = weights[bmu[1]][bmu[0]-1];
            // $display("up 1 %d %d %h %h", up_i, up_j, up_new_node_next_node, winner);

        end
    // check if node adding enabled -> check job done?
    end else if (up_new_node_in_middle_en) begin
        if (up_new_node_in_middle_is_done == {DIM {1'b1}}) begin
            up_new_node_in_middle_en = 0;
            up_new_node_in_middle_reset = 1;
            up_weight = up_new_node_in_middle_weight;
            up = 1;
            // $display("up addeded %d %d", up_i, up_j);
        end
    // check if node adding enabled -> check job done?
    end else if (up_new_node_on_one_side_en) begin
        if (up_new_node_on_one_side_is_done == {DIM {1'b1}}) begin
            up_new_node_on_one_side_en = 0;
            up_new_node_on_one_side_reset = 1;
            up_weight = up_new_node_on_one_side_weight;
            up = 1;
            // $display("up addeded %d %d", up_i, up_j);
        end
    // if node adding no need
    end else begin
        up = 1;
    end
    
    if (!grow_nodes_en) up = 0;
end

always @(posedge clk) begin
    if (grow_nodes_en && !right && (is_active_in_map(right_i, right_j) == 0) && !right_new_node_in_middle_en && !right_new_node_on_one_side_en) begin
        // new node right to the winner
        if (is_active_in_map(right_i, right_j+1) != 0) begin
            right_new_node_in_middle_en = 1;
            right_new_node_in_middle_reset = 0;
            right_new_node_next_node = weights[right_i][right_j+1];
            // $display("right 1 %d %d", right_i, right_j);

        end else if (is_active_in_map(bmu[1], bmu[0]-1) != 0) begin
            right_new_node_on_one_side_en = 1;
            right_new_node_on_one_side_reset = 0;
            right_new_node_next_node = weights[bmu[1]][bmu[0]-1];
            // $display("right 2 %d %d", right_i, right_j);

        end else if (is_active_in_map(bmu[1]+1, bmu[0]) != 0) begin
            right_new_node_on_one_side_en = 1;
            right_new_node_on_one_side_reset = 0;
            right_new_node_next_node = weights[bmu[1]+1][bmu[0]];
            // $display("right 3 %d %d", right_i, right_j);

        end else if (is_active_in_map(bmu[1]-1, bmu[0]) != 0) begin
            right_new_node_on_one_side_en = 1;
            right_new_node_on_one_side_reset = 0;
            right_new_node_next_node = weights[bmu[1]-1][bmu[0]];
            // $display("right 4 %d %d", right_i, right_j);
            
        end
    // check if node adding enabled -> check job done?
    end else if (right_new_node_in_middle_en) begin
        if (right_new_node_in_middle_is_done == {DIM {1'b1}}) begin
            right_new_node_in_middle_en = 0;
            right_new_node_in_middle_reset = 1;
            right_weight = right_new_node_in_middle_weight;
            right = 1;
            // $display("right addeded %d %d", right_i, right_j);
        end
    // check if node adding enabled -> check job done?
    end else if (right_new_node_on_one_side_en) begin
        if (right_new_node_on_one_side_is_done == {DIM {1'b1}}) begin
            right_new_node_on_one_side_en = 0;
            right_new_node_on_one_side_reset = 1;
            right_weight = right_new_node_on_one_side_weight;
            right = 1;
            // $display("right addeded %d %d", right_i, right_j);
        end
    // if node adding no need
    end else begin
        right = 1;
    end
    
    if (!grow_nodes_en) right = 0;
end

always @(posedge clk) begin
    if (grow_nodes_en && !bottom && is_active_in_map(bottom_i, bottom_j)==0 && !bottom_new_node_in_middle_en && !bottom_new_node_on_one_side_en) begin
        // new node bottom to the winner
        if (is_active_in_map(bottom_i-1, bottom_j) != 0) begin
            bottom_new_node_in_middle_en = 1;
            bottom_new_node_in_middle_reset = 0;
            bottom_new_node_next_node = weights[bottom_i-1][bottom_j];
            // $display("bottom in middle %d %d %b", bottom_i, bottom_j, is_active[bottom_i-1][bottom_j]);

        end else if (is_active_in_map(bmu[1]+1, bmu[0]) != 0) begin
            bottom_new_node_on_one_side_en = 1;
            bottom_new_node_on_one_side_reset = 0;
            bottom_new_node_next_node = weights[bmu[1]+1][bmu[0]];
            // $display("bottom on one side %d %d %d %d", bottom_i, bottom_j, bmu[1]+1, bmu[0]);

        end else if (is_active_in_map(bmu[1], bmu[0]+1) != 0) begin
            bottom_new_node_on_one_side_en = 1;
            bottom_new_node_on_one_side_reset = 0;
            bottom_new_node_next_node = weights[bmu[1]][bmu[0]+1];
            // $display("bottom on one side %d %d %d %d", bottom_i, bottom_j, bmu[1], bmu[0]+1);

        end else if (is_active_in_map(bmu[1], bmu[0]-1) != 0) begin
            bottom_new_node_on_one_side_en = 1;
            bottom_new_node_on_one_side_reset = 0;
            bottom_new_node_next_node = weights[bmu[1]][bmu[0]-1];
            // $display("bottom on one side %d %d %d %d", bottom_i, bottom_j, bmu[1], bmu[0]-1);

        end
    // check if node adding enabled -> check job done?
    end else if (bottom_new_node_in_middle_en) begin
        if (bottom_new_node_in_middle_is_done == {DIM {1'b1}}) begin
            bottom_new_node_in_middle_en = 0;
            bottom_new_node_in_middle_reset = 1;
            bottom_weight = bottom_new_node_in_middle_weight;
            bottom = 1;
            // $display("bottom addeded %d %d", bottom_i, bottom_j);
        end
    // check if node adding enabled -> check job done?
    end else if (bottom_new_node_on_one_side_en) begin
        if (bottom_new_node_on_one_side_is_done == {DIM {1'b1}}) begin
            bottom_new_node_on_one_side_en = 0;
            bottom_new_node_on_one_side_reset = 1;
            bottom_weight = bottom_new_node_on_one_side_weight;
            bottom = 1;
            // $display("bottom addeded %d %d", bottom_i, bottom_j);
        end
    // if node adding no need
    end else begin
        bottom = 1;
    end
    
    if (!grow_nodes_en) bottom = 0;
end


always @(posedge clk) begin
    if (grow_nodes_en && !left && is_active_in_map(left_i, left_j)==0 && !left_new_node_in_middle_en && !left_new_node_on_one_side_en) begin
        // new node left to the winner
        if (is_active_in_map(left_i, left_j-1) != 0) begin
            left_new_node_in_middle_en = 1;
            left_new_node_in_middle_reset = 0;
            left_new_node_next_node = weights[left_i][left_j-1];
            $display("left %d %d", left_i, left_j);

        end else if (is_active_in_map(bmu[1], bmu[0]+1) != 0) begin
            left_new_node_on_one_side_en = 1;
            left_new_node_on_one_side_reset = 0;
            left_new_node_next_node = weights[bmu[1]][bmu[0]+1];
            $display("left %d %d", left_i, left_j);

        end else if (is_active_in_map(bmu[1]+1, bmu[0]) != 0) begin
            left_new_node_on_one_side_en = 1;
            left_new_node_on_one_side_reset = 0;
            left_new_node_next_node = weights[bmu[1]+1][bmu[0]];
            $display("left %d %d", left_i, left_j);

        end else if (is_active_in_map(bmu[1]-1, bmu[0]) != 0) begin
            left_new_node_on_one_side_en = 1;
            left_new_node_on_one_side_reset = 0;
            left_new_node_next_node = weights[bmu[1]-1][bmu[0]];
            $display("left %d %d", left_i, left_j);
        end
    // check if node adding enabled -> check job done?
    end else if (left_new_node_in_middle_en) begin
        if (left_new_node_in_middle_is_done == {DIM {1'b1}}) begin
            left_new_node_in_middle_en = 0;
            left_new_node_in_middle_reset = 1;
            left_weight = left_new_node_in_middle_weight;
            left = 1;
            $display("left addeded %d %d", left_i, left_j);
        end
    // check if node adding enabled -> check job done?
    end else if (left_new_node_on_one_side_en) begin
        if (left_new_node_on_one_side_is_done == {DIM {1'b1}}) begin
            left_new_node_on_one_side_en = 0;
            left_new_node_on_one_side_reset = 1;
            left_weight = left_new_node_on_one_side_weight;
            left = 1;
            $display("left addeded %d %d", left_i, left_j);
        end
    // if node adding no need
    end else begin
        left = 1;
    end
    
    if (!grow_nodes_en) left = 0;
end

///////////////////////////////////////////**************************write_weights**************************/////////////////////////////////////////////////////
//integer file_dir, file_i, file_j, item_bit;    
//always @(posedge clk) begin
//    if (write_en) begin
//        file_dir = $fopen("/home/aari/Projects/Vivado/gsom/weight_out.data", "w");
//        for (file_i=0; file_i<=MAX_NODE_SIZE; file_i=file_i+1) begin
            
//            if (file_i <= node_count) begin
//                for (item_bit = 0; item_bit < LOG2_NODE_SIZE; item_bit = item_bit + 1) begin
//                    $fwriteb(file_dir, coordinate_map[file_i][1][item_bit]);
//                end
//                $fwrite(file_dir, " ");
//                for (item_bit = 0; item_bit < LOG2_NODE_SIZE; item_bit = item_bit + 1) begin
//                    $fwriteb(file_dir, coordinate_map[file_i][0][item_bit]);
//                end
//                $fwrite(file_dir, " ");
//                for (item_bit=DIM*DIGIT_DIM-1; item_bit>=0; item_bit=item_bit-1) begin
//                    $fwriteb(file_dir, weights[file_i][item_bit]);
//                end
//            end

//            $fwrite(file_dir, "\n");
//        end
        
//        #10 $fclose(file_dir);            
//        is_completed = 1;   
//        $finish;
//    end
//end

reg [DIGIT_DIM*DIM-1:0]weight_out_reg = 0;
always @(posedge clk) begin
    weight_out_reg = weights[weight_out_index];
end

assign done_training = is_completed;
assign get_next_x = dist_enable;
assign weight_out = weight_out_reg;

endmodule
