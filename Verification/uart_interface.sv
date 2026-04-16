interface uart_interface(input bit clk);

logic        rst_n ;
logic        tx_start ;
logic [7:0]  data_in ;
logic        parity_en ;     // 1 = enable parity
logic        even_parity ;   // 1 = even, 0 = odd
logic        tx ;
logic        tx_busy ;

endinterface