#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR01   บ Autor ณ Rafael Rizzatto    บ Data ณ  04/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissao de duplicata                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso exclusivo - STECK                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFINR01()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Emissao de duplicatas STECK "
Local cPict          := ""
Local titulo         := "Emissao de duplicatas"
Local nLin           := 2
Local Cabec1         := "Este programa ira emitir duplicatas conforme"
Local Cabec2         := "os parametros selecionados"
Local imprime        := .T.
Local aOrd := {}
Private _cChave 		 := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RFINR01"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFINR01"
Private cPerg      := "FINR01"
Private xPAGTO     := ""
Private xVENC_DUP  := {}
Private xTIP_COND  := ""
Private xDESC_PAG  := ""
Private nParc      := 0

AjustaSX1()

Pergunte (cPerg,.F.)               // Pergunta no SX1

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)


//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*


ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  26/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)
_cChave := xFilial("SE1")+MV_PAR01+MV_PAR02+MV_PAR03
//                PREFIXO+NUMERO+PARCELA
If !dbSeek(_cChave)
	MsgAlert('Nao existem dados com esses parametros')
	Return	
Else

	SetRegua(RecCount())
	                              
	nParc := 1
	@ nLin,000 PSAY CHR(15)	
	While !SE1->(Eof()) .AND. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA == _cChave
		nLin := 7                                                           
	 	If lAbortPrint
	   		 @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   		 Exit
		Endif                                                  
		@ nLin,082 PSAY SE1->E1_EMISSAO	  		
		POSICIONE("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_COD")                    
		POSICIONE("SC5",1,xFilial("SC5")+SE1->E1_PEDIDO,"C5_NUM")                    		
		POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_COD")
		POSICIONE("SF2",1,xFilial("SF2")+SE1->E1_NUM,"F2_DOC")
		POSICIONE("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_TIPO")		
		//TRATAMENTO PARA IMPRESSAO DA CONDICAO DE PAGAMANTO     
		xPAGTO		:= ALLTRIM(SE4->E4_COND)
		xTIP_COND	:= SE4->E4_TIPO      
		xDESC_PAG	:= SE4->E4_DESCRI   
		
		If xPAGTO == "0" .AND. xTIP_COND <> "9"
			AADD(xVENC_DUP ,xDESC_PAG)         	
		ElseIf SE1->E1_VENCTO == SF2->F2_EMISSAO
			AADD(xVENC_DUP ,"A VISTA") 
		Else
			AADD(xVENC_DUP, SE1->E1_VENCTO)
		EndIf   
		
		nLin:= nLin + 4
		@ nLin,021 PSAY SE1->E1_NUM
		@ nLin,042 PSAY SE1->E1_VALOR Picture "@E@Z 999,999.99" 
		@ nLin,070 PSAY SE1->E1_NUM+"/"+SE1->E1_PARCELA
		@ nLin,090 PSAY xVENC_DUP[nParc]
		@ nLin,107 PSAY "Fone: "+SA1->A1_TEL       
		nLin:= nLin + 1
		@ nLin,107 PSAY "Contato: "+SA1->A1_CONTATO       
		nLin:= nLin + 1
//		@ nLin,107 PSAY "OD: "+SC5->C5_ORDDESP
		
		nLin:= nLin + 3                     
	    //DADOS DO CLIENTE.
		@ nLin,033 PSAY SA1->A1_NOME //"Sacado ..: "
		nLin:= nLin + 1	     
		@ nLin,033 PSAY SA1->A1_END //"Endereco.: "
		nLin:= nLin + 1        
		@ nLin,033 PSAY SA1->A1_MUN //"Municipio: "
		@ nLin,068 PSAY SUBS(SA1->A1_CEP,1,5) + "-" + SUBS(SA1->A1_CEP,5,3) //"CEP: "
		@ nLin,094 PSAY SA1->A1_EST

		nLin := nLin + 1      
        If !Empty(SA1->A1_ENDCOB)
		   @ nLin,033 PSAY SA1->A1_ENDCOB // "End. Cobranca: "
		Else
		   @ nLin,033 PSAY "O MESMO"
		EndIf   
		@ nLin,114 PSAY	SC5->C5_NUM	   // "Pedido"
		nLin := nLin + 2     
        If Len(Alltrim(SA1->A1_CGC)) > 11
		   @ nLin,033 PSAY SA1->A1_CGC PICTURE "@R 99.999.999/9999-99"
		Else
		   @ nLin,033 PSAY SA1->A1_CGC PICTURE "@R 999.999.999-99"
		EndIf   
		   
        If !Empty(SA1->A1_INSCR)
		   @ nLin,075 PSAY SA1->A1_INSCR //"Inscr.: "
		Else
		   @ nLin,075 PSAY "ISENTO"
		EndIf   
		@ nLin,111 PSAY SUBSTR(SA3->A3_NOME,1,15) //"Vendedor.: "
		nLin := nLin + 1		
	
		@ nLin,036 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),1,69)) + REPLICATE("*",69),1,69)
		nLin:= nLin + 1
	   	@ nLin,036 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),70,69)) + REPLICATE("*",69),1,69) 
		nLin:= nLin + 1      
//		@ nLin,030 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),140,69)) + REPLICATE("*",69),1,69)
//		nLin:= nLin + 1
		SE1->(DbSkip())
		nParc ++	
		nLin := nLin+55  	// PARA POSICIONAR A PROXIMA DUPLICATA NO CENTRO DA FOLHA	
		EndDO
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บ Autor ณ MP8 IDE            บ Data ณ  30/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rafael Pacitti Rizzatto                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1()

Local aRegs := {}

//Estrutura {Grupo	/Ordem	/Pergunta	    	        /Pergunta Espanhol	         	/Pergunta Ingles	    /Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid	/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
Aadd(aRegs,{cPerg	,"01"	,"Prefixo ?"                ,"Prefixo ?"                    ,"Prefixo ?"           ,"mv_ch1"    ,"C"	, 3			,0			,0		,"G"	,""		,"mv_par01"	,""		    ,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""	    ,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"02"	,"Numero da Nota?"      	,"Numero da Nota?"	  		    ,"Numero da Nota?"		,"mv_ch2"	 ,"C"	, 6			,0			,0		,"G"	,""		,"mv_par02"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""	    ,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"03"	,"Parcela?"              	,"Parcela?"	  	        	    ,"Parcela?"		        ,"mv_ch3"	 ,"C"	, 1			,0			,0		,"G"	,""		,"mv_par03"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""	    ,"S"	,""		,""		})
lValidPerg( aRegs )

Return                           