#INCLUDE "FINX490.CH"
#include "PROTHEUS.ch"

Static lFWCodFil := FindFunction("FWCodFil")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINR490	� Autor � Paulo Boschetti	    � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � C�pia de Cheques											  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FINR490(void)						 					  ���
�������������������������������������������������������������������������Ĵ��
���	 Uso	 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Finx490()
//����������������������������������������������������������������
//� Define Variaveis 										     �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL cDesc1 := STR0001  //"Este programa ir� imprimir as copias dos cheques emitidos."
LOCAL cDesc2 := STR0002  //"Ser� impresso 1 ou 2 cheques for folha."
LOCAL cDesc3 :=""
LOCAL cString:="SEF"

PRIVATE titulo  :=OemToAnsi(STR0003)  //"Copias de Cheques"
PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 4, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey:=0
PRIVATE nomeprog:="FINx490"
PRIVATE cPerg	 :="FIN490"
PRIVATE li		 :=1

//��������������������������������������������������������������Ŀ
//� Efetua o ajuste do dicionario para as novas perguntas        �
//����������������������������������������������������������������
FR490AjSx1()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 					       	  �
//����������������������������������������������������������������
pergunte("FIN490",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros							     �
//� mv_par01			// Codigo Do Banco							     �
//� mv_par02			// Da Agencia						     			  �
//� mv_par03			// Da Conta 									     �
//� mv_par04			// Do Cheque										  �
//� mv_par05			// Ate o Cheque									  �
//� mv_par06			// Imprime composicao do cheque				  �
//� mv_par07			// Copias p/ pagina (1/2)						  �
//� mv_par08			// Imprime Numeracao Sequencial				  �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT 						 �
//����������������������������������������������������������������
wnrel := "FINR490"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"P")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa490Imp(@lEnd,wnRel,cString)},titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA490Imp � Autor � Wagner Xavier 	     � Data � 13.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Copia de cheques								 						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA490Imp(lEnd,wnRel,cString)										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do CodeBlock										  ���
���			 � wnRel   - T�tulo do relat�rio 									  ���
���Parametros� cString - Mensagem													  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA490Imp(lEnd,wnRel,cString)

LOCAL j,nTipo:=18,nRec,nContador:=0,cDocto
Local lComprime := .T. //Configura compactacao na impressao
Local nCtrSaida := MV_PAR07

// Retirada a comparacao abaixo uma vez que o Protheus nao mais trabalha com normal e comprimido,
// mas com retradoe paisagem.
//nTipo   :=IIF(aReturn[4]==1,15,18)
mv_par01:= Left(Alltrim(mv_par01)+Space(TamSx3("A6_COD")[1]),TamSx3("A6_COD")[1])
mv_par02:= Left(Alltrim(mv_par02)+Space(TamSx3("A6_AGENCIA")[1]),TamSx3("A6_AGENCIA")[1])
mv_par03:= Left(Alltrim(mv_par03)+Space(TamSx3("A6_NUMCON")[1]),TamSx3("A6_NUMCON")[1]) 
mv_par04:= Left(Alltrim(mv_par04)+Space(TamSx3("EF_NUM")[1]),TamSx3("EF_NUM")[1])

//��������������������������������������������������������������Ŀ
//� Verifica se existe o Banco							         �
//����������������������������������������������������������������
DbSelectArea("SA6")
DbSeek(xFilial("SA6")+mv_par01+mv_par02+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

//��������������������������������������������������������������Ŀ
//� Localiza o 1.Cheque a ser impresso 								  �
//����������������������������������������������������������������
dbSelectArea("SEF")
dbSeek(cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T.)

SetRegua(RecCount())

While !Eof() .And. ;
   EF_FILIAL + EF_BANCO = xFilial("SEF") + mv_par01 .And. ;
	EF_AGENCIA = mv_par02 .And. ;
	EF_CONTA = mv_par03 .And. ;
	EF_NUM <= mv_par05 .And. nCtrSaida > 0

	// Nao imprimir cheques que serao aglutinados.
	If Empty(EF_NUM)
		dbSkip()
		Loop
	EndIf
	
	If lEnd
		@Prow()+1,1 PSAY OemToAnsi(STR0006)  //"Cancelado pelo operador"
		Exit
	EndIF
	
	IncRegua()
	
	If !Empty(mv_par09)
		If DToS(EF_DATA) < DToS(mv_par09)
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If !Empty(mv_par10)
		If DToS(EF_DATA) > DToS(mv_par10)
			dbSkip()
			Loop
		EndIf
	EndIf

	IF EF_IMPRESS $ "AC" .or. SubStr(EF_TIPO,1,2) == "TB"
		dbSkip()
		Loop
	EndIF
	
	//���������������������Ŀ
	//�Validacao da carteira�
	//�����������������������
	
	If EF_CART = "R"
		DbSkip()
		Loop
	EndIf
	
	IF mv_par07 == 1		//uma copia por folha
		li:=1
	Elseif li > 32 		//so coube uma copia
		li:=1
	Else				//2 copias por folha
		IF nContador == 0
			li:=1
		Else
			li:=33
		EndIF
	EndIF

   // Envia comando para comprimir impressao
   If lComprime
     fa490Cabec( nTipo )
     lComprime := .F. // Necessario apenas no primeiro registro
   EndIf
	
	nContador++
	IF nContador>2;nContador:=1;li:=1;EndIF
	__LogPages()
	@li, 1 PSAY Alltrim(SM0->M0_NOMECOM) + " - " + Alltrim(SM0->M0_FILIAL) + OemToAnsi(STR0007)  //"  -  COPIA DE CHEQUE"
	li++
	@li, 0 PSAY Replicate("-",80)
	li++
	@li, 0 PSAY OemToAnsi(STR0008)  +EF_NUM  //"|  Numero Cheque "
	@li,35 PSAY OemToAnsi(STR0009)  +Dtoc(EF_DATA)  //"Data da Emissao "
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY OemToAnsi(STR0010)+EF_BANCO + " " + SUBSTR(SA6->A6_NREDUZ,1,20)  //"|  Banco "
	@li,35 PSAY OemToAnsi(STR0011)+" "+EF_AGENCIA+OemToAnsi(STR0012)+EF_CONTA  //"Agencia###"   Conta "
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY OemToAnsi(STR0013)+Transform(EF_VALOR,"@E 9999,999,999.99")  //"|  Valor Cheque "
	@li,35 PSAY OemToAnsi(STR0014)+Dtoc(EF_DATA)  //"Data do Cheque  "
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY OemToAnsi(STR0015)+EF_BENEF  //"|  Favorecido "
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|"
	@li,79 PSAY "|"
//	@li, 0 PSAY OemToAnsi(STR0016)+EF_HIST  //"|  Historico  "
//	@li,79 PSAY "|"
	li++
	If mv_par08 == 1
		
		//����������������������������������������������������������Ŀ
		//� Pegar e gravar o proximo numero da Copia do Cheque 	    �
		//� Posicionar no sx6 utilizando GetMv. N�o Utilize Seek !!! �
		//������������������������������������������������������������
		cDocto := STRZERO(VAL(Getmv("MV_NUMCOP"))+1,6)
		dbSelectArea("SX6")
		GetMv("MV_NUMCOP")
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With cDocto
		MsUnlock()
		dbSelectArea("SEF")
		
		@li, 0 PSAY OemToAnsi(STR0017)+cDocto  //"|  Copia de Cheque No. "
		@li,79 PSAY "|"
	Else
		@li, 0 PSAY "|"
		@li,79 PSAY "|"
	End
	li++
	@li, 0 PSAY OemToAnsi(STR0018)  //"|  Vistos"
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|"+Replicate("-",78)+"|"
	li++
	@li, 0 PSAY OemToAnsi(STR0019)  //"|Observacoes      |Contas a Pagar|Gerente Financ|Contabilidade |Assinado por   |"
	li++
	@li, 0 PSAY "|-----------------|--------------|--------------|--------------|---------------|"
	li++
	For j:=1 to 3
		@li, 0 PSAY "|"
		@li,18 PSAY "|"
		@li,33 PSAY "|"
		@li,48 PSAY "|"
		@li,63 PSAY "|"
		@li,79 PSAY "|"
		li++
	Next j
	@li, 0 PSAY Replicate("-",80)
	nRec:=RecNo()
	IF mv_par06 == 1
		fr490Cpos(SEF->EF_NUM)
	EndIF
	nCtrSaida--
	dbGoTo(nRec)
	dbSkip()
	If nCtrSaida < 1
		nCtrSaida := MV_PAR07
	Endif	
End

Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � fr490Cpos� Autor � Wagner Xavier 		  � Data � 13.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Copia de cheques								  		   	        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR490(void)							  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 											                 			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     �Generico 										           			  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function fr490Cpos(cCheque)
LOCAL nFirst:=0,lAglut:=.F.
Local aColu	:= {}
Local aTam := TamSX3("E2_FORNECE")
Local aTam2 := TamSX3("EF_TITULO")
Local cCabeca := ""
Local cCabecb := ""
Local aFiliais := {}
Local nRegEmp	:= SM0->(Recno())
Local nRegAtu	:= SM0->(Recno())
Local lExclusivo := !Empty(xFilial("SEF"))
Local cEmpAnt	:= SM0->M0_CODIGO
Local nI := 0
Local aAreaAtual := GetArea()  //Guarda area atual
Local cFilOrig := ""
Local lModImp := .F.  //Imprime linha unica. 
Local Hist := ""


	lModImp := .F.

DbSelectArea("SEF")
dbSeek (xFilial("SEF")+mv_par01+mv_par02+mv_par03+cCheque)
//��������������������������������������������������������������Ŀ
//� Definicao das colunas de impressao                           �
//� aTam[1] = Tamanho do codigo do fornecedor (6 ou 20)          �
//� aTam2[1]= Tamanho do nro de titulo (6 ou 12)                 �
//����������������������������������������������������������������

If aTam[1] > 6
	aColu := {001,025,057,008,012,026,030,052,001}
	cCabeca	:= OemToAnsi(STR0025)  //"|Fornec                  Nome Fornecedor                 Natureza              |"
	cCabecb	:= OemToAnsi(STR0024)  //"|       Prf Numero        P   Vencto                  Valor do Titulo          |"
ElseIf aTam2[1] > 6 .AND. lModImp == .F.
	aColu := {001,011,043,008,012,026,030,052,001}
	cCabeca	:= OemToAnsi(STR0023)  //"|Fornec    Nome Fornecedor                 Natureza                            |"
	cCabecb	:= OemToAnsi(STR0024)  //"|       Prf Numero        P   Vencto                  Valor do Titulo          |"
Else
	aColu := {001,008,027,038,042,052,056,063,001}
	cCabeca	:= OemToAnsi(STR0026) // "|Fornec   Nome Fornecedor   Prf Numero    P| Natureza   Vencto     Valor Titulo|"
	cCabecb	:= ""
Endif

If Alltrim(SEF->EF_ORIGEM) $ "FINA090#FINA091"
	dbSelectArea("SM0")
	dbSeek(cEmpAnt,.T.)
	nRegAtu := SM0->(RECNO())
	While !Eof() .and. SM0->M0_CODIGO == cEmpAnt
		AADD(aFiliais,IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ))
		DbSkip()
	Enddo
	SM0->(dbGoto(nRegAtu))
Else
	AADD(aFiliais,IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ))
Endif

For nI := 1 to Len(aFiliais)
	
	cFilAtu := aFiliais[nI]
	cEmpAnt := SM0->M0_CODIGO
	While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) == cFilAtu
		
		cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		
		DbSelectArea("SEF")
		If MsSeek (xFilial("SEF")+mv_par01+mv_par02+mv_par03+cCheque)
			While !Eof() .And. EF_FILIAL+EF_BANCO == xFilial("SEF")+mv_par01 .And. ;
				EF_AGENCIA == mv_par02 .And. EF_CONTA == mv_par03 .And. ;
				EF_NUM == cCheque
				
				//���������������������Ŀ
				//�Validacao da carteira�
				//�����������������������
				
				If EF_CART = "R"
					DbSkip()
					Loop
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Verifica se nao � principal o cancelado					 	 	  �
				//����������������������������������������������������������������
				IF EF_IMPRESS == "C"
					dbSkip()
					Loop
				EndiF
				
				IF li > 58
					li:=1
					@li,0 PSAY OemToAnsi(STR0020)+ cCheque + OemToAnsi(STR0021)  //"COPIA DO CHEQUE : "###" - Continuacao"
					li++
				EndIF
				
				IF nFirst == 0
					IF EF_IMPRESS = "A"
						lAglut:=.T.
					EndIF
					IF !lAglut .and. Empty(SEF->EF_TITULO)
						dbSkip()
						Loop
					End
					li++
					@li,0 PSAY OemToAnsi(STR0022)+Replicate("-",55)+"|"  //"|- Composicao do Cheque "
					li++
					@li,0 PSAY cCabeca
					//����������������������������������������������������������������Ŀ
					//� Verifica se sera necess�rio imprimir em duas linhas os detalhes�
					//� Isso ocorre qdo E2_FORNECE > 6 pos ou EF_TITULO > 6 pos.       �
					//������������������������������������������������������������������
					IF aTam[1] > 6 .OR. (aTam2[1] > 6 .AND. lModImp == .F.)
						li++
						@li,0 PSAY cCabecb
					Endif
					li++
					@li,0 PSAY Replicate("-",80)
				EndIF
				IF Empty(SEF->EF_TITULO)
					dbSkip()
					Loop
				End
				If aTam[1] == 6 .and. (aTam2[1] == 6 .OR. lModImp == .T.)
					nTam := 18
				Else
					nTam := 30
				Endif
				nFirst++
				li++
				
				If SEF->EF_TIPO $ MVRECANT+"/"+MV_CRNEG
					dbSelectArea("SA1")
					MsSeek(cFilial+SEF->EF_FORNECE+SEF->EF_LOJA)
					
					dbSelectArea("SE1")
					MsSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
	  				Hist := E1_HIST				
					@li, 0 PSAY "|"
					@li, aColu[1] PSAY E1_CLIENTE
					
					If SuperGetMV("MV_COPCHQF",,"1") == "1"
						@li, aColu[2] PSAY SubStr(E1_NOMCLI	   ,1,nTam)
					Else
						@li, aColu[2] PSAY SubStr(SA1->A1_NOME,1,nTam)
					EndIf
					
					@li, aColu[3] PSAY SE1->E1_NATUREZ
					
				Else
					
					dbSelectArea("SA2")
					MsSeek(cFilial+SEF->EF_FORNECE+SEF->EF_LOJA)
					
					//Faz a busca pelo campo FILORIG caso seja multifiliais
					If SEF->( FieldPos( "EF_FILORIG" ) ) > 0 .AND. ( !Empty( SEF->EF_FILORIG ) .AND. !Empty(xFilial("SEF")) )
						cFilOrig := SEF->EF_FILORIG
					else
						cFilOrig := xFilial("SE2")
					EndIf
	
					dbSelectArea("SE2")
					MsSeek(cFilOrig+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
					@li, 0 PSAY "|"
					@li, aColu[1] PSAY SE2->E2_FORNECE
					If SuperGetMV("MV_COPCHQF",,"1") == "1"
						@li, aColu[2] PSAY SubStr(SE2->E2_NOMFOR	   ,1,nTam)
					Else
						@li, aColu[2] PSAY SubStr(SA2->A2_NOME,1,nTam)
					EndIf
					
					@li, aColu[3] PSAY SE2->E2_NATUREZ 
					
					IF !EMPTY(E2_HIST)
					ENDIF		
						Hist_1 := Substr(E2_HIST,1,65)
						Hist_2 := Substr(E2_HIST,66,75)
						Hist_3 := Substr(E2_HIST,141,75)
						Hist_4 := Substr(E2_HIST,216,35)

				EndIf
				
				dbSelectArea("SEF")
				//��������������������������������������������������������������Ŀ
				//� Verifica se sera necess�rio imprimir em duas linhas os deta- �
				//� lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos  �
			   //� e lModImp == .F.	                                            �
				//����������������������������������������������������������������
				IF aTam[1] > 6 .or. (aTam2[1] > 6 .AND. lModImp == .F.) 
					@li,79 PSAY "|"
					li++
					@li, 0 PSAY "|"
				Endif
				@li, aColu[4] PSAY EF_PREFIXO
				@li, aColu[5] PSAY EF_TITULO
				@li, aColu[6] PSAY EF_PARCELA
				
				@li, aColu[7] PSAY Iif(SEF->EF_TIPO $ MVRECANT+"/"+MV_CRNEG,SE1->E1_VENCREA, SE2->E2_VENCREA)
				
 				@li, aColu[8] PSAY EF_VALOR PicTure tm(EF_VALOR,15) 
 				
					IF aTam[1] > 6 .or. (aTam2[1] > 6 .AND. lModImp == .F.) 
						@li,79 PSAY "|"
						li++
						@li, 0 PSAY "|"
					Endif
					IF !EMPTY(HIST_1) 				
					@li, aColu[9] PSAY "Historico :"+HIST_1   
					@li, 79 PSAY "|"
					li++
					@li, 0 PSAY "|"
										
						IF !EMPTY(HIST_2) 
						@li, aColu[9] PSAY HIST_2
						@li, 79 PSAY "|"
						li++
						@li, 0 PSAY "|"

							IF !EMPTY(HIST_3) 
							@li, aColu[9] PSAY HIST_3							
							@li, 79 PSAY "|"
							li++
							@li, 0 PSAY "|"
								
								IF !EMPTY(HIST_4) 
								@li, aColu[9] PSAY HIST_4 
								@li,79 PSAY "|"
								li++   
								@li, 0 PSAY "|"  
								ENDIF
//							ELSE
//							@li, 0 PSAY "|"  							
							ENDIF
						ENDIF									
					ENDIF										        			 				
				If lModImp == .T.
					@li,78 PSAY "|"
				Else
					@li,79 PSAY "|"	  

				
				EndIf	
				dbSkip()
			EndDO
		Endif
		//Se o SEF for compartilhado eu leio apenas uma vez.
		If !lExclusivo
			Exit
		Else
			dbSelectArea("SM0")
			dbSkip()
		Endif
	Enddo
	//Se o SEF for compartilhado eu leio apenas uma vez.
	If !lExclusivo
		Exit
	Endif
Next
SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

IF nFirst>0
	li++
	@li, 0 PSAY Replicate("-",80)
EndIF 

RestArea( aAreaAtual ) //Restaura a area do chamador.

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa490Cabec� Autor � Alessandro B. Freire  � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de leitura do driver correto de impressao		     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA490cabec(nchar) 										  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nChar . 15-Comprimido , 18-Normal				 		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     �Finr490													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa490cabec(nChar)

LOCAL cTamanho := "P"
LOCAL aDriver := ReadDriver()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
if nChar == NIL
	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
	if nChar == 15
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
	endif
endif
Return(.T.)


Static FUNCTION FR490AjSx1()
Local aPergs	:= {}
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

/*
	Aadd(aHelpPor,'Selecione a op��o "SIM" para que os')
	Aadd(aHelpPor,"resultados sejam apresentados em linha")
	Aadd(aHelpPor,'�nica, ou "N�O" para serem apresentados')
	Aadd(aHelpPor,"com quebra de linha.")
	Aadd(aHelpPor,"Obs.: Este par�metro ser� desconsiderado")
	Aadd(aHelpPor,'caso o campo "Cod.Fornecedor" seja maior')
	Aadd(aHelpPor,'que 6 posi��es ou o campo "No.Titulo"')	
	Aadd(aHelpPor,"seja maior que 9 posi��es.")
			
	Aadd(aHelpEng,"Select YES if you want the results to")
	Aadd(aHelpEng,"be shown in a single row or NO to be")
	Aadd(aHelpEng,"shown with line break.")
	Aadd(aHelpEng,"Note: This parameter will be considered")
	Aadd(aHelpEng,'if the field "Supplier Code" has more')
	Aadd(aHelpEng,'that 6 characters or if "Bill Number"')	
	Aadd(aHelpEng,"has more than 9.")

	Aadd(aHelpSpa,'Seleccione la opcion "SI" para que los')
	Aadd(aHelpSpa,"resultados se muestren en linea unica,")
	Aadd(aHelpSpa,'o "NO" para que se muestren con salto')
	Aadd(aHelpSpa,"de linea.")
	Aadd(aHelpSpa,"Obs.: Este parametro no se considerara")
	Aadd(aHelpSpa,'si el campo "Cod.Proveedor" tiene mas')
	Aadd(aHelpSpa,'de 6 espacios o si el campo "No.Titulo"')	
	Aadd(aHelpSpa,"tiene mas de 9 espacios.")	
	
	aAdd(aPergs,{"Imprime linha unica?","�Imprime linea unica?","Prints single row?","MV_CHB","N",1,0,2,"C","","mv_par11","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

AjustaSx1( "FIN490" , aPergs )
*/
Return
