`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 11:10:14
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


module Digi_ATT(
    output reg ATT_LE,
    output reg ATT_DATA,
    input ATT_CLK,
    input [5:0] ATT_Gain,
    input ATT_EN
    );
    


reg [3:0]                         current_state;
localparam                       S_IDLE       = 1; // idle state
localparam                       S_D16      = 2;//write 1st byte
localparam                       S_D8      = 3;//write 2nd byte
localparam                       S_D4      = 4;//write 3rd byte
localparam                       S_D2      = 5;//write 4th byte
localparam                       S_D1      = 6;//wait for write to finish
localparam                       S_D0_5      = 7;//wait for write to finish    
localparam                       S_DC1      = 8;//wait for write to finish
localparam                       S_DC2      = 9;//wait for write to finish
localparam                       S_LATCH      = 10;//wait for write to finish


reg ATT_en_prev;

 always@(posedge ATT_CLK)
 begin
    case(current_state)
		S_IDLE:
	    begin
            ATT_LE<=1'b0;
            ATT_DATA<=1'b0;
            ATT_en_prev <= ATT_EN;
            if(ATT_EN ==1'b1)
            begin
               current_state<=S_D16;        
            end
        end     
        S_D16:
        begin
               ATT_DATA<=  ATT_Gain[5];
               current_state<=S_D8;
        end    
        S_D8:
        begin
             ATT_DATA<=  ATT_Gain[4];
               current_state<=S_D4;
        end    
        S_D4:
        begin
            ATT_DATA<=  ATT_Gain[3];
               current_state<=S_D2;
        end    
          
        S_D2:
        begin
             ATT_DATA<=  ATT_Gain[2];
               current_state<=S_D1;
        end    
        S_D1:
        begin
           ATT_DATA<=  ATT_Gain[1];
               current_state<=S_D0_5;             
        end  
        
        S_D0_5:
        begin
            ATT_DATA<= ATT_Gain[0];
               current_state<=S_DC1;     
             
        end  
        S_DC1:
        begin
            ATT_DATA<=  1'b0;
               current_state<=S_DC2;  
             
        end  
        S_DC2:
        begin
            ATT_DATA<=  1'b0;
               current_state<=S_LATCH;              
        end  
        S_LATCH:
        begin
            ATT_LE<=1'b1;
               current_state<=S_IDLE;     
        end    
        default:
        begin
             ATT_LE<=1'b0; 
             ATT_DATA<=1'b0;
			current_state <= S_IDLE;
        end
       endcase
 end;
    
    
    
    
endmodule
