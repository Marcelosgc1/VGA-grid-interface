//made by Marcelo Tavares @ 2026

module VGA_interface
#(
	parameter SIZE = 3 //deve estar no intervalo [3,5]
)
(
	input clk_25mhz, reset, write_enable,
	input [1:0] data,
	input [5:0] address,
	output v_sync, h_sync,
	output [3:0] R, G, B
);

	wire [9:0] x_coord, y_coord;
	reg in_scope;
	reg [1:0] color;
	reg [1:0] register [63:0];

	integer i;
	always @(posedge clk_25mhz or posedge reset) begin
		if (reset) begin
			for (i = 0; i < 64; i = i + 1) begin
				register[i] <= 0;
			end
		end
		else begin
			if (write_enable)
				register[address] <= data;
		end
	end
	
	
	always @(*) begin	
		in_scope = !((|y_coord[9:SIZE+3]) | (|x_coord[9:SIZE+3])); //verifica se os contadores estao fora do intervalo 0-63, nas linhas e colunas.
	
		if (in_scope)
			color = register[{y_coord[SIZE+2:SIZE], x_coord[SIZE+2:SIZE]}];
		else
			color = 0; //talvez pôr cinza aq?
	end
		
	VGA_driver driver(
		clk_25mhz,
		reset,
		color,
		x_coord, 
		y_coord,
		h_sync,
		v_sync,
		R,
		G,
		B
	);
	
endmodule