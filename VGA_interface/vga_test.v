//modulo criado p/ demonstrar funcionamento.

module vga_test(input [5:0] addr, input [1:0]color, output [3:0] r,g,b, output hs,vs, input rst, en, clk);

	reg clk_vga;

	always @(posedge clk) begin
		clk_vga <= !clk_vga;
	end
	
	
	VGA_interface #(5) u1(
		clk_vga, 
		!rst, 
		!en,
		color,
		addr,
		vs, hs,
		r,g,b
	);


endmodule