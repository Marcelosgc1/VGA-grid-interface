<h1>VGA-grid-interface</h1>

<h2>O que é isso?</h2>
<p>
  É uma interface simples para utilizar um monitor VGA, sendo capaz de desenhar quadrados coloridos em posições previamente estabelecidas.
</p>

<p align="center">
  <img src="images/linhas.png" alt="linhas" width="45%" />
  <img src="images/colunas.png" alt="colunas" width="45%" />
  <img src="images/diagonal.png" alt="diagonal" width="45%" />
  <img src="images/diagonal_inversa.png" alt="diagonal inversa" width="45%" />
</p>

<h2>Como funciona?</h2>
<p>
  Existem 64 registradores, cada um para quadrado [58 x 58] no monitor. Para visualizar melhor cada quadrado de forma individual, foi adicionada uma grade cinza para ocupar o espaço entre os polígonos.
</p>

<p>
  Em <code>address</code>, os bits [2:0] são usados para identificar a coluna e os bits [5:3] são utilizados para identificar a linha que o programador pretende editar.
</p>

<p>As cores possíveis são quatro:</p>
<ul>
  <li><b>00</b> - Vermelho</li>
  <li><b>01</b> - Azul</li>
  <li><b>10</b> - Amarelo</li>
  <li><b>11</b> - Branco</li>
</ul>

<p>
  Para obter essas cores é preciso enviar o valor correspondente na entrada <code>data</code>.
</p>
<p>
  Ao fim, para confirmar a escrita é necessário ativar o sinal <code>write_enable</code>, para escrever os valores no registrador.
</p>

<h2>Exemplo:</h2>
<p>
  Para desenhar um quadrado azul na posicão [1][2], isso seria nas colunas de 8 - 15 e linhas 16 - 23 basta fazer:
</p>

<pre><code>col = 8/8 = 1;
lin = 16/8 = 2;
address = {{2},{1}} ou {3'b010,3'b001};

azul = 01;
data = 2'b01;

write_enable = 1'b1; (por 1 ciclo já basta).
</code></pre>

<h2>Como usar em meu projeto?</h2>
<p>
  Copie os arquivos <em>VGA_driver.v</em> e <em>VGA_interface.v</em> para seu projeto e instancie o módulo <code>VGA_interface</code>.
</p>

<pre><code class="language-verilog">VGA_interface 
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
</code></pre>
