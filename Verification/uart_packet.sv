import enum_pkg::* ;

class uart_packet;
    randc logic  [7:0]   data_in ;
    rand uart_e         enum_r ;

    constraint Odd_parity { enum_r == ODD ; }
    constraint Even_parity { enum_r == EVEN ; }
    constraint No_parity { enum_r == NO_PARITY ; }


    covergroup U_cg ;
        Data:   coverpoint data_in ;
        Parity: coverpoint enum_r  ;
        Crossing: cross data_in , enum_r ;
    
    endgroup

    function new();
        U_cg = new() ;
    endfunction

    task print ();
        $display("Stimulus Values in Packed are:") ;
        $display("Data = %b , Parity = %s" , data_in , enum_r.name) ;
    endtask

endclass

