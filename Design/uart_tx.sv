module uart_tx (uart_interface UART_I);

    // State machine states
    localparam IDLE   = 3'd0,
               START  = 3'd1,
               DATA   = 3'd2,
               PARITY = 3'd3,
               STOP   = 3'd4;

    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg       parity_bit;

    always @(posedge UART_I.clk or negedge UART_I.rst_n) begin
        if (!UART_I.rst_n) begin
            state     <= IDLE;
            UART_I.tx        <= 1'b1;  // idle is high
            UART_I.tx_busy   <= 1'b0;
            shift_reg <= 8'd0;
            bit_cnt   <= 4'd0;
            parity_bit <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    UART_I.tx <= 1'b1;
                    UART_I.tx_busy <= 1'b0;
                    if (UART_I.tx_start) begin
                        shift_reg <= UART_I.data_in;
                        bit_cnt <= 4'd0;
                        parity_bit <= (UART_I.even_parity) ? ~(^UART_I.data_in) : (^UART_I.data_in);
                        UART_I.tx_busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    UART_I.tx <= 1'b0; // start bit
                    state <= DATA;
                end

                DATA: begin
                    UART_I.tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_cnt <= bit_cnt + 1;  
                    if (bit_cnt == 4'd7) begin
                        if (UART_I.parity_en)
                            state <= PARITY;
                        else
                            state <= STOP;
                    end
                end

                PARITY: begin
                    UART_I.tx <= parity_bit;
                    state <= STOP;
                end

                STOP: begin
                    UART_I.tx <= 1'b1; // stop bit (always 1)
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule