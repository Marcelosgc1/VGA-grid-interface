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
  Para desenhar um quadrado azul na posicão [2][1] da grade basta fazer:
</p>

<pre><code>address = {{2},{1}} ou {3'b010,3'b001};

azul = 01;
data = 2'b01;

write_enable = 1'b1; (por 1 ciclo já basta).
</code></pre>

<h2>Como usar em meu projeto?</h2>
<p>
  Copie os arquivos <em>VGA_driver.v</em> e <em>VGA_interface.v</em> para seu projeto e instancie o módulo <code>VGA_interface</code>.
</p>

<pre><code class="verilog">VGA_interface 
	u1(
		//INPUT
		.clk_25mhz(), 
		.reset(), 
		.write_enable(),
		.data(),
		.address(),
	
		//OUTPUT
		.v_sync(), 
		.h_sync(),
		.R(),
		.G(),
		.B()
	);
</code></pre>

<h3>Como pinar o VGA?</h3>
<p>
  O controlador de vídeo é responsável por gerar os sinais de sincronismo (<code>h_sync</code> e <code>v_sync</code>) e as saídas de dados para cada <em>pixel</em> de forma serial. Os dados são as cores dos <em>pixels</em>, são 3 valores de cor <code>R</code>, <code>G</code> e <code>B</code>, mas cada um tem 4 bits de informação. Segue uma tabela indicando como pinar cada valor.
</p>
<table>
  <caption><b>Tabela 1:</b> Pinagem da FPGA referente à interface VGA</caption>
  <thead>
    <tr style="background-color: #f2f2f2;">
      <th style="border: 1px solid #ddd; padding: 8px; text-align: center;">Nome do Sinal</th>
      <th style="border: 1px solid #ddd; padding: 8px; text-align: center;">Pinos</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">R[0]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_AA1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">R[1]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_V1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">R[2]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_Y2</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">R[3]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_Y1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">G[0]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_W1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">G[1]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_T2</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">G[2]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_R2</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">G[3]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_R1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">B[0]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_P1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">B[1]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_T1</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">B[2]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_P4</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">B[3]</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_N2</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">h_sync</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_N3</td>
    </tr>
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">v_sync</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">PIN_N1</td>
    </tr>
  </tbody>
</table>
