//a)Gerar
//b)Programar as colunas
//c)Totalizar o Pre�o de Venda
//d)Perguntas SX1

//PASSO 00 - trocar o include
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFATR01  � Autor � Joao Victor        � Data �  02/01/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Lista de Preco.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Joao Victor                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//PASSO 01 - dar um nome para a User Function
User Function STFATR01()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

//PASSO 02 - Preencher as vari�veis abaixo
//Descri��o, T�tulo, ...
Local cDesc1         := "RELATORIO DE LISTA DE PRECO"
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "TABELA DE PRECOS GERAL"
Local nLin           := 132
Local cDesc          := ""
Local nQtde          := 0
Local cCpoFil        := ""
Local cFilAlias      := ""

//PASSO 03 - Montas as vari�veis Cabec1 e Cabec2
//Basear-se no Layout fornecido pelo Cliente (MIT044)
//                     0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3  
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local Cabec1       := "Codigo Produto   Descricao Produto                                   Embalagem  IVA  ClasFiscal  %IPI  Preco Base  % ST  R$ ST    Preco Final" 
Local Cabec2       := "================ =================================================== ========== ==== =========== ===== ==========  ===== =======  ==========="
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
      

//PASSO 04 - Definir o tamanho (PMG) alterando limite X Tamanho e a vari�vel nomeprog
//P=80
//M=132
//G=232
Private limite           := 232
Private tamanho          := "G"
Private nomeprog         := "STFATR01" // Coloque aqui o nome do programa para impressao no cabecalho

Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0

// PASSO 05 - Parte 'a'
// Definir o nome do Grupo de Perguntas SX1
Private cPerg       := "STFATR01"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01

//PASSO 06 - Alterar o conte�do da vari�vel wnrel - ser� o nome do arquivo gravado em SPOOL
Private wnrel      := "NREL_"+Dtos(dDataBase) // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "DA1"

// PASSO 05 - parte 'b'
// Criar uma fun��o que grave essas pergunta automaticamente
GravaSX1(cPerg)

//PASSO 07 - trocar o conte�do abaixo por cString
dbSelectArea(cString)
dbSetOrder(1) //DA0_FILIAL+DA0_CODTAB


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
RptStatus({|| GeraRel(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � Joao Victor        � Data �  02/02/2013 ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Static Function GeraRel(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

If ValType(cString) <> "C"
	Return nQtde  // retorna zero
EndIf

If Empty(cString)  // Se vazio
	Return nQtde  // retorna zero
EndIf

If Len(cString) > 3
	Return nQtde  // retorna zero
EndIf

dbSelectArea(cString)
If Substr(cString,1,1) == "S"   // pegar a partir da 2, 2 caracteres
	cCpoFil := Substr(cString,2,2) + "_FILIAL"
Else // pegar tudo
	cCpoFil := cString + "_FILIAL"
EndIf
cFilAlias := FieldGet(FieldPos(cCpoFil)) // &(cCpoFil)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

dbGoTop()
//PASSO 08 - Acrescentar DbsetOrder e DbSeek conforme a necessidade
DbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
DbSeek(xFilial("DA1"))

nTotal  := 0
nQtde   := 0
nTotal2 := 0

//PASSO 09 - Colocar as condi��es de sa�da
While !(cString)->(EOF()) .And. xFilial(cString) == cFilAlias 
	
	DbSelectArea("SB1")
	cDesc1 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_DESC")
	cDesc2 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_QE")	
	cDesc3 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_QE")	
	cDesc4 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_POSIPI")		
	cDesc5 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_IPI")		
	cDesc6 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_PRV1")		
	cDesc7 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_IPI")		
	cDesc8 := POSICIONE("SB1", 1, xFilial("SB1") + DA1->DA1_CODPRO, "B1_IPI")					
		
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//PASSO 13 - Acr�scimo das Perguntas para Filtrar os registros
	
	If SBM->BM_GRUPO >= MV_PAR01 .And. SBM->BM_GRUPO <= MV_PAR03
		
		If SB1->B1_COD >= MV_PAR02 .And. SB1->B1_COD <= MV_PAR04
			
	
				//���������������������������������������������������������������������Ŀ
				//� Impressao do cabecalho do relatorio. . .                            �
				//�����������������������������������������������������������������������
				
				If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					
					//PASSO 10 - ajustar o nLin de 8 para 9
					nLin := 9
				Endif
				
				// Coloque aqui a logica da impressao do seu programa...
				// Utilize PSAY para saida na impressora. Por exemplo:
				// @nLin,00 PSAY SA1->A1_COD
				//PASSO 12 - Colocar os campos e as posi��es de Impress�o
				//nLin � a Linha e o pr�ximo dado � a coluna
				//Comece sempre na 00
				@nLin,00  PSAY (cString)->DA1_CODPRO Picture "@!"
				@nLin,18  PSAY (cDesc1)              Picture "@!"
				@nLin,70  PSAY (cDesc2)              Picture "@!"
				@nLin,81  PSAY (cDesc3)              Picture "@!"
				@nLin,86  PSAY (cDesc4)              Picture "@!"
				@nLin,98  PSAY (cDesc5)              Picture "@!"
				@nLin,104 PSAY (cDesc6)              Picture "@!"
				@nLin,116 PSAY (cString)->DA1_CODPRO Picture "@!"
				@nLin,122 PSAY (cString)->DA1_CODPRO Picture "@!"
				@nLin,131 PSAY (cString)->DA1_CODPRO Picture "@!"
//				@nLin,98  PSAY QPedido(SA1->(A1_COD + A1_LOJA))      Picture "@E 999,999"			

				
				nTotal := nTotal + (cString)->DA1_CODPRO
				nQtde++
			   //	nTotal2 := nTotal2 + QPedido(SA1->(A1_COD + A1_LOJA))
				
				nLin := nLin + 1 // Avanca a linha de impressao
		Endif
	Endif
	
	//PASSO 11 - Acrescentar o Alias (cString) no DbSkip()
	(cString)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

cTXT01 := "===================== ================== ========== ============================== ==================== ======="
cTXT02 := "                                                                                                               "
cTXT03 := "                                                                                                               "
cTXT04 := "===================== ================== ========== ============================== ==================== ======="

@nLin,00 PSAY cTXT01
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT02
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT03
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT04
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif

@nLin,00 PSAY "Qtde Clientes: "+Alltrim(Str(nQtde))
@nLin,83 PSAY nTotal Picture "@E 9,999,999,999,999.99"
@nLin,104 PSAY nTotal2 Picture "@E 999,999"

nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif

nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif

cTxt05 := "LEGENDA:"
cTxt06 := "'Nome Fantasia' � o Nome Comercial do Cliente."
cTxt07 := "'CNPJ/CPF' � o C�digo de Registro do Cliente Pessoa F�sica ou Pessoa Jur�dica junto a Receita Federal."
cTxt08 := "'Natureza F' � o c�digo da Natureza Financeira selecionada no cadastro do Cliente."
cTxt09 := "'Descri��o da Natureza Financeira' � a descri��o da Natureza Financeira selecionada no cadastro do Cliente."
cTxt10 := "'Saldo' � o Saldo de Duplicatas do Cliente."
cTxt11 := "'Qtde PV' � a quantidade de Pedidos de Vendas emitidos para o cliente, onde os mesmos podem estar em abertos ou faturados."
@nLin,00 PSAY cTXT05
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT06
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT07
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT08
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT09
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT10
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif
@nLin,00 PSAY cTXT11
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif

nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif

SET DATE BRITISH
cTXT12 := "RELAT�RIO EMITIDO PELO USU�RIO: " + Upper(cUserName) + " " + "EM: " + Dtoc(dDataBase) + " " + "�S: " + Time(dDataBase)
@nLin,05 PSAY cTXT12
nLin++
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	//PASSO 10 - ajustar o nLin de 8 para 9
	nLin := 9
Endif


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


*---------------------------------
Static Function GravaSX1(cPerg)
// PASSO 05 - Definir o nome do Grupo de Perguntas SX1
// Criar uma fun��o que grave essas pergunta automaticamente
Local nJ:= 0
Local nI:= 0  
Local aPerguntas := {}
Local aSX1Cpos   := {}

DbSelectArea("SX1")
DbGoTop()

cPerg := PadR(cPerg, Len(SX1->X1_GRUPO), " ")

// Nao alterar aSX1Cpos
aSX1Cpos := {"X1_GRUPO","X1_ORDEM","X1_PERGUNT"            ,"X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VAR01","X1_DEF01"         ,"X1_CNT01"       ,"X1_DEF02"              ,"X1_DEF03"      ,"X1_DEF04"       ,"X1_F3","X1_HELP"}

// Deve ter uma linha pra cada pergunta
Aadd(aPerguntas,{cPerg ,"01"      ,"Grupo de Produtos de:" ,"mv_ch1"    ,"C"      ,04          ,0           ,1          ,"G"     ,"MV_PAR01",""                 ,Space(4)         ,""                      ,""              ,""               ,"SBM"  ,""       })
Aadd(aPerguntas,{cPerg ,"02"      ,"Grupo de Produtos ate:","mv_ch2"    ,"C"      ,04          ,0           ,1          ,"G"     ,"MV_PAR02",""                 ,Replicate("Z",4) ,""                      ,""              ,""               ,"SBM"  ,""       })
Aadd(aPerguntas,{cPerg ,"03"      ,"Produtos de:"          ,"mv_ch3"    ,"C"      ,15          ,0           ,1          ,"G"     ,"MV_PAR03",""                 ,Space(15)        ,""                      ,""              ,""               ,"SB1"  ,""       })
Aadd(aPerguntas,{cPerg ,"04"      ,"Produtos ate:"         ,"mv_ch4"    ,"C"      ,15          ,0           ,1          ,"G"     ,"MV_PAR04",""                 ,Replicate("Z",15),""                      ,""              ,""               ,"SB1"  ,""       })
Aadd(aPerguntas,{cPerg ,"05"      ,"Estado: "              ,"mv_ch5"    ,"C"      ,02          ,0           ,1          ,"G"     ,"MV_PAR05",""                 ,Space(2)         ,""                      ,""              ,""               ,"   "  ,""       })
Aadd(aPerguntas,{cPerg ,"06"      ,"Tipo de Cliente: "     ,"mv_ch6"    ,"C"      ,06          ,0           ,1          ,"G"     ,"MV_PAR06",""                 ,Space(6)         ,""                      ,""              ,""               ,"ACY"  ,""       })
Aadd(aPerguntas,{cPerg ,"07"      ,"Condicao de Pagamento:","mv_ch7"    ,"C"      ,03          ,0           ,1          ,"G"     ,"MV_PAR07",""                 ,Space(3)         ,""                      ,""              ,""               ,"SE4"  ,""       })  
Aadd(aPerguntas,{cPerg ,"08"      ,"Tabela de Preco:"      ,"mv_ch8"    ,"C"      ,03          ,0           ,1          ,"G"     ,"MV_PAR08",""                 ,Space(3)         ,""                      ,""              ,""               ,"DA0"  ,""       })  

For nI:=1 to Len(aPerguntas)
	If DbSeek( aPerguntas[nI,1] + aPerguntas[nI,2] )
		RecLock("SX1",.F.)
	Else
		RecLock("SX1",.T.)
	EndIf
	
	For nJ:=1 to Len( aPerguntas[nI] )
		FieldPut( FieldPos( aSX1Cpos[nJ]) , aPerguntas[nI,nJ] )
	Next
	
	SX1->( MsUnLock() )
	
Next nI

Return

*---------------------------------
Static Function QPedido(cPedido)

Local nPedido        :=0
Local cString	     :="SA1"
Local cString2       :="SC5"

DbSelectArea("SC5")
DbGoTop()
DbSetOrder(3)//C5_FILIAL+C5_CLIENTE+C5_LOJACLI+C5_NUM
DbSeek( xFilial("SC5")+SC5->( cPedido ) )

While !(cString2)->(EOF()) .And. xFilial(cString2) == (cString2)->C5_FILIAL.And.;
	(cString2)->C5_CLIENTE == (cString)->A1_COD .And.;
	(cString2)->C5_LOJACLI == (cString)->A1_LOJA
	nPedido++
	
	(cString2)->( DbSkip() )
EndDo

Return nPedido
