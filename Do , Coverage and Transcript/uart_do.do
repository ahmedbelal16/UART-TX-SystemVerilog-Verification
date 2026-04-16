transcript file transcript.log

vlib work

vlog uart_tx.sv enum_pkg.sv uart_packet.sv Uart_tb.sv uart_interface.sv UART_TOP.sv +cover -covercells

vsim -voptargs=+acc work.UART_TOP -cover

add wave -position insertpoint \
sim:/UART_TOP/UART_I/clk \
sim:/UART_TOP/TB/counter \
sim:/UART_TOP/TB/data_in_r \
sim:/UART_TOP/TB/parity_en_r \
sim:/UART_TOP/TB/even_parity_r \
sim:/UART_TOP/TB/mode \
sim:/UART_TOP/TB/U \
sim:/UART_TOP/UART_I/rst_n \
sim:/UART_TOP/UART_I/tx_start \
sim:/UART_TOP/UART_I/data_in \
sim:/UART_TOP/UART_I/parity_en \
sim:/UART_TOP/UART_I/even_parity \
sim:/UART_TOP/UART_I/tx \
sim:/UART_TOP/UART_I/tx_busy

coverage save -onexit cov.ucdb

run -all

coverage report -details -output Uart_Cov.txt

transcript close
quit -f