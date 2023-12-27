`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 11:30:20
// Design Name: 
// Module Name: pll_config_mcu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pll_config_mcu(
    input clk_20Mz_i,
    input rstn_i,
    input spi_busy_i,
    output reg [15:0] spi_tx_data,
    output reg spi_en
    );

reg [5:0] tx_cnt;

always @ (posedge clk_20Mz_i or negedge rstn_i)
begin
    if(~rstn_i)begin
        tx_cnt <= 'd0;
        spi_en <= 'd0; end
    else if(spi_busy_i == 'd0 && tx_cnt <= 'd19) begin
        spi_en <= 'd1;
        tx_cnt <= tx_cnt + 'd1;end
    else if(tx_cnt == 'd18)begin
        tx_cnt <= 'd0;
        spi_en <= 'd0;
        end
end

always @ (posedge clk_20Mz_i or negedge rstn_i)
begin
   if(~rstn_i)
        spi_tx_data <= 'd0;
        
end
endmodule
