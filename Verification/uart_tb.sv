import enum_pkg::* ;
`include "uart_packet.sv"

module uart_tb(uart_interface UART_I);

//-------------------- Defining Signals --------------------//
bit         golden_model [$] ;
bit         actual_queue [$] ;
int         counter ;       // Is calculated during generating stimulus and used in storing the Actual Data from DUT

logic [7:0] data_in_r ;     // The randomized data from the class 
logic       parity_en_r ;     
logic       even_parity_r ;
int         mode ;


uart_packet U ;             // Defining the class


//-------------------- Generate Stimulus Function --------------------//
task automatic generate_stimulus(ref bit golden_model [$] , ref bit actual_queue [$] , int mode);
    @(negedge UART_I.clk) ;

    golden_model.delete() ;
    actual_queue.delete() ;
    U = new() ;

    // This case difine the parity condition we are using randomizing on
    case (mode)
        ODD: begin 
            U.Odd_parity.constraint_mode(1) ;
            U.Even_parity.constraint_mode(0) ;
            U.No_parity.constraint_mode(0) ;
            $display("Testing ODD Parity Mode");
        end

        EVEN: begin 
            U.Odd_parity.constraint_mode(0) ;
            U.Even_parity.constraint_mode(1) ;
            U.No_parity.constraint_mode(0) ;
            $display("Testing EVEN Parity Mode");
        end

        NO_PARITY: begin 
            U.Odd_parity.constraint_mode(0) ;
            U.Even_parity.constraint_mode(0) ;
            U.No_parity.constraint_mode(1) ;
            $display("Testing NO Parity Mode");
        end
    endcase

    assert (U.randomize()) else $stop ;
    U.U_cg.sample() ;

    data_in_r = U.data_in ;
    
    // This case difine the parity condition we are using
    case (U.enum_r)
        NO_PARITY: begin
           parity_en_r  = 0;
           even_parity_r = 0; // don't care
        end

        EVEN: begin
           parity_en_r  = 1;
           even_parity_r = 1;
        end

        ODD: begin
           parity_en_r  = 1;
           even_parity_r = 0;
        end
    endcase
endtask


//-------------------- Golden Model Task --------------------//
task automatic golden_model_task (ref bit golden_model [$] , ref int counter );
    @(negedge UART_I.clk) ;

    counter = 0 ;
    golden_model [counter] = 0 ;
    
    for ( counter = 1 ; counter < 9 ; counter++ ) begin
        golden_model[counter] = data_in_r[counter - 1] ;
    end

    if (parity_en_r) begin
        if (even_parity_r) begin
            golden_model [counter] = ~(^data_in_r) ;
            counter = counter + 1 ;
        end
        else begin
            golden_model [counter] = (^data_in_r) ;
            counter = counter + 1 ;
        end
    end

    golden_model [counter] = 1 ;

endtask


//-------------------- Drive Stimulus Task --------------------//
task automatic drive_stim ();
    @(negedge UART_I.clk) ;

    if(!UART_I.tx_busy) begin
        UART_I.data_in = data_in_r ; 
        UART_I.parity_en = parity_en_r ;
        UART_I.even_parity = even_parity_r ;

        UART_I.tx_start = 1 ;
        @(negedge UART_I.clk) ;
        UART_I.tx_start = 0 ;
    end
    else begin
        $error("The Uart is Busy") ;
        return ;
    end

endtask


//-------------------- Collect Output Data Task --------------------//
task automatic collect_output_data (ref bit actual_queue [$] );
    wait (UART_I.tx == 0);

    for ( int i = 0 ; i < counter + 1 ; i++ ) begin
        @(negedge UART_I.clk) ;
        actual_queue[i] = UART_I.tx ;
    end
endtask


//-------------------- Check Results Task --------------------//
task automatic results_check( const ref bit golden_model [$] , const ref bit actual_queue [$] );
    @(negedge UART_I.clk) ;

    $display("Golden queue = %p", golden_model);
    $display("Actual queue = %p", actual_queue);

    foreach(golden_model[i]) begin
        assert (golden_model[i] == actual_queue[i])
        else begin 
            $error("DUT Data = %b , Expected Data = %b" , actual_queue[i] ,  golden_model [i] );
            $stop ;
        end
    end

    // foreach(golden_model[i]) begin
    //     if ( golden_model [i] == actual_queue[i] ) begin

    //         $display("DUT Data = %b , Expected Data = %b" , actual_queue[i] ,  golden_model[i]) ;

    //     end else begin

    //         $error("DUT Data = %b , Expected Data = %b" , actual_queue[i] ,  golden_model [i] ) ;
    //         $stop ;

    //     end
    // end
endtask




initial begin

UART_I.rst_n = 0 ;
@(negedge UART_I.clk) ;
UART_I.rst_n = 1 ;
@(negedge UART_I.clk) ;

counter = 0 ;

//-------------------- Test all data_in values on ODD PARITY --------------------//
repeat(350) begin
mode = ODD ;
generate_stimulus (golden_model , actual_queue , mode);
golden_model_task (golden_model , counter);
drive_stim ();
collect_output_data (actual_queue);
results_check (golden_model,actual_queue);
$display("=================================================================================================");
end
$display("");
$display("Test for ODD Data passed");
$display("");
$display("=================================================================================================");


//-------------------- Test all data_in values on EVEN PARITY --------------------//
repeat(400) begin
mode = EVEN ;
generate_stimulus (golden_model , actual_queue , mode);
golden_model_task (golden_model , counter);
drive_stim ();
collect_output_data (actual_queue);
results_check (golden_model,actual_queue);
$display("=================================================================================================");
end

$display("");
$display("Test for EVEN Data passed");
$display("");
$display("=================================================================================================");

//-------------------- Test all data_in values on NO PARITY --------------------//
repeat(330) begin
mode = NO_PARITY ;
generate_stimulus (golden_model , actual_queue , mode);
golden_model_task (golden_model , counter);
drive_stim ();
collect_output_data (actual_queue);
results_check (golden_model,actual_queue);
$display("=================================================================================================");
end

$display("");
$display("Test for NO PARITY Data passed");
$display("");
$display("=================================================================================================");
$display("");
$display("The design is functioning correctly") ;
$display("");
$display("=================================================================================================");
$display("");


$stop ;
end 
endmodule