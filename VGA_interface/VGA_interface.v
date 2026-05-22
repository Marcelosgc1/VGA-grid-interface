//made by Marcelo Tavares @ 2026

module VGA_interface
#(
	parameter GRID = 3
)
(
	input clk_25mhz, reset, write_enable,
	input [1:0] data,
	input [(2*GRID)-1:0] address,
	output v_sync, h_sync,
	output [3:0] R, G, B
);
	
	parameter GRID_SIZE = 2**GRID;
	parameter SIZE = 480/GRID_SIZE;
	
	wire [9:0] x_count, y_count;
	reg in_scope, is_edge;
	reg [1:0] curr_reg;
	reg [1:0] register [((GRID_SIZE**2)-1):0];
	reg [GRID-1:0] x_axis, y_axis;
	reg [10:0] x_offset;
	reg [11:0] color;
	
	integer i;
	always @(posedge clk_25mhz or posedge reset) begin
		if (reset) begin
			for (i = 0; i < ((GRID_SIZE**2)-1); i = i + 1) begin
				register[i] <= 0;
			end
		end
		else begin
			if (write_enable)
				register[address] <= data;
		end
	end
	
	
	always @(*) begin	
		x_offset = {1'b0, x_count} - 11'sd80;

		is_edge = (y_count%SIZE == 0) | (x_offset%SIZE == 0) | (y_count%SIZE == SIZE-1) | (x_offset%SIZE == SIZE-1); //verifica se algum dos contadores se encontra em uma borda (grid)
		in_scope = (x_offset < 480); //verifica se os contadores estao fora do intervalo [80,480[ , nas linhas e colunas.

		x_axis = x_offset/SIZE;
		y_axis = y_count/SIZE;
		
		curr_reg = register[{y_axis, x_axis}];

		if (is_edge & in_scope)
			color = 12'h888; //cinza 
		else if (in_scope)
			case (curr_reg)
				2'b00: color = 12'hF00; //vermelho
				2'b01: color = 12'h00F; //azul
				2'b10: color = 12'hFF0; //amarelo
				2'b11: color = 12'hFFF; //branco
			endcase
		else
			color = 12'h000; //preto
	end
		
	VGA_driver driver(
		clk_25mhz,
		reset,
		color,
		x_count, 
		y_count,
		h_sync,
		v_sync,
		R,
		G,
		B
	);
	
endmodule