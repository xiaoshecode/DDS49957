`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 10:54:53
// Design Name: 
// Module Name: Digi_ATT
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


module profile_sync(
    input profile_switch,
    output wire [2:0] ch0_profile,
    output wire [2:0] ch1_profile,    
    output wire [2:0] ch2_profile,
    output wire [2:0] ch3_profile,
    
    input [2:0] ch0_profile_int,
    input [2:0] ch1_profile_int,
    input [2:0] ch2_profile_int,
    input [2:0] ch3_profile_int,
    
    input [2:0] ch0_profile_ext,
    input [2:0] ch1_profile_ext,
    input [2:0] ch2_profile_ext,
    input [2:0] ch3_profile_ext,
    
    input [3:0] sync_clk
    );
   
reg [3:0] ch0_profile_buf = 0;
reg [3:0] ch0_profile_buf0 = 0;
reg [3:0] ch0_profile_buf1 = 0;
reg [3:0] ch0_profile_buf2 = 0;
reg [3:0] ch0_profile_buf3 = 0;

reg [3:0] ch1_profile_buf = 0;
reg [3:0] ch1_profile_buf0 = 0;
reg [3:0] ch1_profile_buf1 = 0;
reg [3:0] ch1_profile_buf2 = 0;
reg [3:0] ch1_profile_buf3 = 0;

reg [3:0] ch2_profile_buf = 0;
reg [3:0] ch2_profile_buf0 = 0;
reg [3:0] ch2_profile_buf1 = 0;
reg [3:0] ch2_profile_buf2 = 0;

reg [3:0] ch3_profile_buf = 0;
reg [3:0] ch3_profile_buf0 = 0;
reg [3:0] ch3_profile_buf1 = 0;
reg [3:0] ch3_profile_buf2 = 0;


assign ch0_profile = ch0_profile_buf;
assign ch1_profile = ch1_profile_buf;
assign ch2_profile = ch2_profile_buf;
assign ch3_profile = ch3_profile_buf;

always@(negedge sync_clk[0])
begin     
    ch0_profile_buf1 <=  ch0_profile_ext; 
    ch0_profile_buf2 <= ch0_profile_buf1;
    if (ch0_profile_buf2 == ch0_profile_ext)
        ch0_profile_buf0 <= ch0_profile_buf2;
    ch0_profile_buf <= ch0_profile_buf0;
end
 
always@(negedge sync_clk[1])
begin     
    ch1_profile_buf1 <=  ch1_profile_ext; 
    ch1_profile_buf2 <= ch1_profile_buf1;
    if (ch1_profile_buf2 == ch1_profile_ext)
        ch1_profile_buf0 <= ch1_profile_buf2;
    ch1_profile_buf <= ch1_profile_buf0;
end 

always@(posedge sync_clk[2])
begin     
    ch2_profile_buf1 <=  ch2_profile_ext; 
    ch2_profile_buf2 <= ch2_profile_buf1;
    if (ch2_profile_buf2 == ch2_profile_ext)
        ch2_profile_buf0 <= ch2_profile_buf2;
    ch2_profile_buf <= ch2_profile_buf0;
end

always@(negedge sync_clk[3])
begin     
    ch3_profile_buf1 <=  ch3_profile_ext; 
    ch3_profile_buf2 <= ch3_profile_buf1;
    if (ch3_profile_buf2 == ch3_profile_ext)
        ch3_profile_buf0 <= ch3_profile_buf2;
    ch3_profile_buf <= ch3_profile_buf0;
end         
    
    
endmodule

