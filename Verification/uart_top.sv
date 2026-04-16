module UART_TOP();
    
bit clk ;

//-------------------- Clock Generation --------------------//
initial begin
    clk = 0;
    forever #5ns clk = ~clk;
end

uart_interface UART_I (clk) ;
uart_tx DUT (UART_I) ;
uart_tb TB (UART_I) ;

endmodule