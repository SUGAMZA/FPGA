

`define SYSCLK				50000000
`define UART_BAUD_RATE	115200
`define UART_BAUD_DIV	`SYSCLK/`UART_BAUD_RATE  



module uart_tx (//give stm_out state and outputs that need to change their value based on the state 
	input					clk,
	input					reset_n,//mapping to SW
	
	input 	[7:0]		wr_data,
	input 				wr_n,
	
	output 	 		  	oUart_tx
);

	//parameter 			stop=0, start=1, D0=2, D1=3, D2=4, D3=5, D4=6, D5=7, D6=8, D7=9;

	localparam		idle_st	= 4'd0, 
							start_st	= 4'd1, 
							D0_st		= 4'd2, 
							D1_st		= 4'd3, 
							D2_st		= 4'd4, 
							D3_st		= 4'd5, 
							D4_st		= 4'd6,
							D5_st		= 4'd7,
							D6_st		= 4'd8,
							D7_st		= 4'd9, 
							stop_st	= 4'd10;
							

	reg		[7:0] 				tx_reg;
	reg	[3:0]		cur_st;
	reg	[3:0]		nxt_st;

	wire	[7:0]		tx_in;
	wire 				chg_st_sig;
	
	reg	[9:0]		count;
	reg	rUart_tx;



	//---------------------------	
	
	
	always @ (posedge clk or negedge reset_n) begin
		if(!reset_n) begin
			count	<= 0;
		end
		else if (count	== `UART_BAUD_DIV  ) begin//'UART_BAUD_DIV???
			count <= 0;
		end
		else begin
			count <= count+1;
		end 
		if (!reset_n) begin
			cur_st <= idle_st;
		end
		else if(chg_st_sig)begin
			cur_st <= nxt_st;//
		end
		
	end
	
	assign chg_st_sig = (count == `UART_BAUD_DIV);//use to change state every 435th count

		
	always @(posedge clk or negedge reset_n or negedge wr_n)begin
		if((!reset_n) || (!wr_n))begin
			tx_reg <= wr_data;
		end
	end
	
	assign tx_in = tx_reg;
	

	//---------------------------	
	
	
/*	
	always @(posedge clk or negedge reset_n)
	begin
		if (!reset_n) begin
			nxt_st <= idle_st;
		end
	end
	*/
	
	//---------------------------	

	always @(*) begin
			case (cur_st) 
				
				idle_st :  begin
					rUart_tx		= 1'b1;
					nxt_st		= start_st;
				end
				
				start_st : begin
					rUart_tx		= 1'b0;
					nxt_st		= D0_st;
					
						//rUart_tx		= tx_in[0];
					
				end
				D0_st : begin
					rUart_tx		= tx_in[0];
					nxt_st		= D1_st;
					
					
				end
				D1_st : begin
					rUart_tx		= tx_in[1];
					nxt_st		= D2_st;
					
					
				end
				D2_st : begin
					rUart_tx		= tx_in[2];
					nxt_st		= D3_st;
					
					
				end
				D3_st : begin
					rUart_tx		= tx_in[3];
					nxt_st		= D4_st;
					
					
				end
				D4_st : begin
					rUart_tx		= tx_in[4];
					nxt_st		= D5_st;
					
					
				end
				D5_st : begin
					rUart_tx		= tx_in[5];
					nxt_st		= D6_st;
					
					
				end
				D6_st : begin
					rUart_tx		= tx_in[6];
					nxt_st		= D7_st;
					
					
				end
				D7_st : begin
					rUart_tx		= tx_in[7];
					nxt_st		= stop_st;
					
					
				end
				stop_st : begin
					rUart_tx		= 1'b1;
					nxt_st		= idle_st;
					
					  
				end
				default : begin
						rUart_tx		=1'b1;
						
				end
			endcase
	end
	

	assign oUart_tx = rUart_tx;
		
	assign tx_in=tx_reg;
	

endmodule

