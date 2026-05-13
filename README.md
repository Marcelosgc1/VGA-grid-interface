# VGA-grid-interface

## O que é isso?
É uma interface simples para utilizar um monitor VGA, sendo capaz de desenhar quadrados coloridos em posições previamente estabelecidas.

## Como funciona?
Existem 64 registradores, cada um para quadrado [(2^N)-2 x (2^N)-2] no monitor.

"N" é um parâmetro que pode ser definido na hora de instanciar o módulo. Se você quiser mostrar um quadrado [30x30] por exemplo, basta passar como parâmetro 5, pois 2^5 = 32, 32 - 2 = 30. O valor padrão é 3. (2^3-2 = 6). É recomendado usar apenas valores de N no intervalo [3,5].


Em "address", os bits [2:0] são usados para identificar a coluna e os bits [5:3] são utilizados para identificar a linha.

As cores possíveis são quatro:
*	00 - Preto
*	01 - Azul
*	10 - Amarelo
*	11 - Branco

Para obter essas cores é preciso enviar o valor correspondente 
na entrada "data".

Ao fim, para confirmar a escrita é necessário ativar o sinal
"write_enable", para escrever os valores no registrador.


## Exemplo:
Para desenhar um quadrado azul na posicão [1][2], isso seria
nas colunas de 8 - 15 e linhas 16 - 23 basta fazer:

```text
col = 8/8 = 1;
lin = 16/8 = 2;
address = {{2},{1}} ou {3'b010,3'b001};

azul = 01;
data = 2'b01;

write_enable = 1'b1; (por 1 ciclo já basta).
```

## Como usar em meu projeto?
Copie os arquivos *VGA_driver.v* e *VGA_interface.v* para seu projeto e instancie o módulo VGA_interface.

```verilog
VGA_interface 
	#(3) //Parâmetro do tamanho do quadrado, nesse exemplo o quadrado é: 2^3 - 2 = 6.
	u1(
		.clk_25mhz(), 
		.reset(), 
		.write_enable(),
		.data(),
		.address(),
		.v_sync(), 
		.h_sync(),
		.R(),
		.G(),
		.B()
	);
```
