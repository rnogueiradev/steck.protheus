#INCLUDE  "rwmake.ch"
#INCLUDE  "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCIAP01  บ Autor ณ Cristiano Pereira   บ Data ณ 29/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO APROPRIACAO CIAP                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function STCIAP01()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString    
Private cPerg  := "STCIAP01"+Space(02)
/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
DbSelectArea("SX1")

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Da Data "
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Data "
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
EndIf

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Totaliza por "
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := "Por Nota"
	SX1->X1_DEF02   := "Geral   "
EndIf
*/


// Solicita paramentros para impressao do relatorio
If !Pergunte(cPerg,.T.)
	Return
Else
	Processa( {|| STCIAP01A()} ,"Selecionando Registros..................." )
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออหออออออออออออออออออออออออออออหออออออออออออออออออออปฑฑ
ฑฑบFuno    ณ STCIAP01Aบ Autor ณ Cristiano Pereira  บ Data ณ  12/07/04   บฑฑ
ฑฑฬอออออออออออออออออออออสออออออออออออออออออออออออออออสออออออออออออออออออออนฑฑ
ฑฑบDescrio ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function  STCIAP01A

Local nTamLin, cLin, cCpo

// Fecha arquivo temporario
If Select("TSFA") > 0
	DbSelectArea("TSFA")
	dbclosearea()
Endif



// Selecionar notas  fiscais de entrada
_cQrySFA := "SELECT FA_CODIGO,FA_VALOR,F9_DTENTNE,F9_DOCNFE "
_cQrySFA += " FROM "+RetSqlName("SFA")+" SFA, "+RetSqlName("SF9")+" SF9 "
_cQrySFA += " WHERE FA_FILIAL = '"+xFilial("SFA")+"' AND SFA.FA_FILIAL = SF9.F9_FILIAL AND SFA.D_E_L_E_T_ <> '*' AND FA_MOTIVO = ' ' AND FA_DATA >= '"+Dtos(MV_PAR01)+ "' AND FA_DATA <= '"+Dtos(MV_PAR02)+ "' AND FA_CODIGO = F9_CODIGO AND SF9.D_E_L_E_T_ <> '*' "
_cQrySFA += " ORDER BY F9_DTENTNE,F9_DOCNFE "
TCQUERY _cQrySFA NEW ALIAS "TSFA "

TCSETFIELD("TSFA","	FA_DATA" ,"D",08,0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1     := "Este programa tem como objetivo imprimir relatorio  "
Private cDesc2     := "para das APROPRIACOES DO CIAP POR MES               "
Private cDesc3     := "   "
Private cPict      := ""
Private nLin       := 66
Private imprime    := .T.
Private CbTxt      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 80
Private nomeprog   := "STCIAP01"
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "STCIAP01"+space(02) /* aumentando para 10 posicoes - Kelle */
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "STCIAP01"
Private cString    := "SFQ"

private titulo     := "APROPRIACAO CIAP MES "
Private Cabec1     := "BEM      DESCRICAO                       NOTA/SERIE     FORNECEDOR                  ENTRADA   EMISSAO     VALOR ICMS   NR.PARC  PARC RES     APROP.MES      SLD TRANSF.     SLD APROPRIADO     SLD A APROPRIAR "
Private Cabec2     :=  " "
Private tamanho    := "G"



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

titulo       := "APROPRIACAO CIAP MES - " + Dtoc(MV_PAR01)+" A " + Dtoc(MV_PAR02)

Pergunte(cPerg,.F.)


SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| DURFIS42B(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


// Emite relatorio do arquivo temporario
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บ Autor ณ Damiao Braz        บ Data ณ  06/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ Especifico DURA                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function DURFIS42B(Cabec1,Cabec2,Titulo,nLin)

_tTotEnt := 0       // Total Pedidos


// Nota de entrada
_nTotalPIs := 0
_nTotalCof := 0
_nTotalBru := 0
_nTotalBas := 0


DbSelectArea("TSFA")
_nRec := 0
DbEval({|| _nRec++  })
SetRegua(_nRec)
DbSelectArea("TSFA")
Dbgotop()

_nTotalicm  := 0
_nTotalapro := 0
_nTotalp    := 0
_nSldaApr   := 0
_nSldApro   := 0

// Totaliza geral

If MV_PAR03 == 2
	
	While !Eof()
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		DbSelectArea("SF9")
		DbSetOrder(1)
		DbSeek(xfilial("SF9")+TSFA->FA_CODIGO)
		
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xfilial("SA2")+SF9->F9_FORNECE+SF9->F9_LOJAFOR)
		
		
		@ nLin,001 PSAY TSFA->FA_CODIGO
		@ nLin,010 PSAY SubStr(SF9->F9_DESCRI,1,30)
		@ nLin,042 PSAY ALLTRIM(SF9->F9_DOCNFE)+"-"+SF9->F9_SERNFE
		@ nLin,057 PSAY ALLTRIM(SF9->F9_FORNECE)+"-"+SF9->F9_LOJAFOR
		@ nLin,067 PSAY SUBSTR(SA2->A2_NREDUZ,1,15)
		@ nLin,082 PSAY SF9->F9_DTENTNE
		@ nLin,095 PSAY SF9->F9_DTEMINE
		@ nLin,103 PSAY SF9->F9_VALICMS PICTURE "@E 999,999,999.99"
		@ nLin,122 PSAY SF9->F9_QTDPARC PICTURE "@E 999"
		@ nLin,131 PSAY SF9->F9_SLDPARC PICTURE "@E 999"
		@ nLin,138 PSAY TSFA->FA_VALOR  PICTURE "@E 999,999,999.99"
		@ nLin,156 PSAY SF9->F9_VALICMP PICTURE "@E 999,999,999.99"
		@ nLin,173 PSAY SF9->F9_VLESTOR PICTURE "@E 999,999,999.99"
		@ nLin,187 PSAY SF9->F9_VALICMS-SF9->F9_VLESTOR PICTURE "@E 999,999,999.99"
		
		
		
		nLin := nLin + 1
        
		_nTotalicm  := _nTotalicm  + SF9->F9_VALICMS
		_nTotalp    := _nTotalp    + SF9->F9_VALICMP
		_nTotalapro := _nTotalapro + TSFA->FA_VALOR
		_nSldaApr   := _nSldaApr+(SF9->F9_VALICMS-SF9->F9_VLESTOR) 
        _nSldApro   := _nSldApro+SF9->F9_VLESTOR

		DbSelectArea("TSFA")
		dbSkip()
		
		
		
	Enddo
Endif

// Totaliza por notal

If MV_PAR03 == 1
	
	While !Eof()
		
		_cChave := TSFA->F9_DTENTNE +TSFA->F9_DOCNFE
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_nNFicm  := 0
		_nNFicmp := 0
		_nNFapro := 0
		
		While  TSFA->F9_DTENTNE +TSFA->F9_DOCNFE == _cChave
			
			IncRegua()
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			
			DbSelectArea("SF9")
			DbSetOrder(1)
			DbSeek(xfilial("SF9")+TSFA->FA_CODIGO)
			
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xfilial("SA2")+SF9->F9_FORNECE+SF9->F9_LOJAFOR)
			
			
			@ nLin,001 PSAY TSFA->FA_CODIGO
			@ nLin,010 PSAY SubStr(SF9->F9_DESCRI,1,30)
			@ nLin,042 PSAY ALLTRIM(SF9->F9_DOCNFE)+"-"+SF9->F9_SERNFE
			@ nLin,057 PSAY ALLTRIM(SF9->F9_FORNECE)+"-"+SF9->F9_LOJAFOR
			@ nLin,067 PSAY SUBSTR(SA2->A2_NREDUZ,1,15)
			@ nLin,085 PSAY SF9->F9_DTENTNE
			@ nLin,095 PSAY SF9->F9_DTEMINE
			@ nLin,103 PSAY SF9->F9_VALICMS PICTURE "@E 999,999,999.99"
			@ nLin,122 PSAY SF9->F9_QTDPARC PICTURE "@E 999"
			@ nLin,131 PSAY SF9->F9_SLDPARC PICTURE "@E 999"
			@ nLin,138 PSAY TSFA->FA_VALOR  PICTURE "@E 999,999,999.99"
	    	@ nLin,156 PSAY SF9->F9_VALICMP PICTURE "@E 999,999,999.99"
			
			nLin := nLin + 1
			_nTotalicm  := _nTotalicm  + SF9->F9_VALICMS
			_nTotalp    := _nTotalp    + SF9->F9_VALICMP
			_nTotalapro := _nTotalapro + TSFA->FA_VALOR
			_nNFicm     := _nNFicm     + SF9->F9_VALICMS
			_nNFicmp    := _nNFicmp    + SF9->F9_VALICMP
			_nNFapro    := _nNFapro    + TSFA->FA_VALOR
			
			DbSelectArea("TSFA")
			dbSkip()
			
		Enddo
		
		@ nLin,102 PSAY _nNFicm  PICTURE "@E 999,999,999.99"
		@ nLin,137 PSAY _nNFapro PICTURE "@E 999,999,999.99"
		@ nLin,160 PSAY _nNFicmp PICTURE "@E 999,999,999.99"
		
		nLin := nLin + 2
		
	Enddo

Endif




nLin := nLin + 2
@ nLin,102 PSAY _nTotalicm  PICTURE "@E 999,999,999.99"
@ nLin,137 PSAY _nTotalapro PICTURE "@E 999,999,999.99"
@ nLin,161 PSAY _nTotalp    PICTURE "@E 999,999,999.99"
@ nLin,173 PSAY _nSldApro PICTURE "@E 999,999,999.99"
@ nLin,187 PSAY _nSldaApr PICTURE "@E 999,999,999.99"


//------------------------------------------------------------------------------------------------------------------

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//BEM      DESCRICAO                       NOTA/SERIE     FORNECEDOR                  EMISSAO   ENTRADA     VALOR ICMS   NR.PARC  PARC RES     APROP.MES      SALDO DE TRANSFERENCIA
//
//999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999999-999  999999-99  XXXXXXXXXXXXXXX  99/99/99  99/99/99  999,999,999.99   999      999      999,999,999.99       999,999,999.99
//1        10                              42             57         68               85        95        105              122      131      140
