//made by Marcelo Tavares @ 2026

/* 
O que é isso?
É uma interface simples para utilizar um monitor VGA, sendo
capaz de desenhar quadrados [8x8] de quatro cores diferentes
em posições previamente estabelecidas.

Como funciona?
Existem 64 registradores, cada um para quadrado [8x8] no monitor.

Em "address", os bits [2:0] são usados para identificar a coluna
e os bits [5:3] são utilizados para identificar as linhas.

As cores possíveis são quatro:
	00 - Preto
	01 - Azul
	10 - Amarelo
	11 - Branco

Para obter essas cores é preciso enviar o valor correspondente 
na entrada "data".

Ao fim, para confirmar a escrita é necessário ativar o sinal
"write_enable", para escrever os valores no registrador.


EXEMPLO:
para desenhar um quadrado azul na posicão [1][2], isso seria
nas colunas de 8 - 15 e linhas 16 - 23 basta fazer:

col = 8/8 = 1;
lin = 16/8 = 2;
address = {{2},{1}} ou {3'b010,3'b001};

azul = 01
data = 2'b01;

write_enable = 1'b1; (por 1 ciclo já basta).
*/

module VGA_interface(
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
		in_scope = !((|y_coord[9:6]) | (|x_coord[9:6])); //verifica se os contadores estao fora do intervalo 0-63, nas linhas e colunas.
	
		if (in_scope)
			color = register[{y_coord[5:3], x_coord[5:3]}];
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