/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLMP_B2B8  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ajustar o SB2, SBF, SB8                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - MACROPLAST                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#include "Protheus.ch"
#Include "TopConn.ch"
//#include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static __lOpened := .F.

User Function STESTM01()
	
	aReturn    := {'Zebrado', 1,'Administrao', 2, 2, 1, '',1}
	cbTxt      := ''
	cDesc1     := 'O objetivo deste relatขrio  exibir detalhadamente todas as diferenas'
	cDesc2     := 'de Saldo entre os arquivos SB2 x SB8 x SBF.'
	cCabec1    := ''
	cCabec2    := ''
	cTitulo    := 'RELACAO DE DIFERENCAS SB2xSB8xSBF'
	cString    := 'SB1'
	cRodaTxt   := ''
	cNomePrg   := 'ACTSALDO'
	nTipo      := 18
	nTamanho   := 'G'
	nLastKey   := 0
	nCntImpr   := 0
	lAbortPrin := .F.
	WnRel      := 'ACTSALDO'
	cPerg		:= "DIFSLD0002"
	
	_fCriaSx1()
	
	//
	// Funcao para criacao das perguntas.
	//
	//_fCriaSx1()
	
	if  Pergunte(cPerg,.T.)
		SB2->(DbSetOrder(1))
		// B2_FILIAL+B2_COD+B2_LOCAL
		
		SBF->(DbSetOrder(2))
		// BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
		
		SB8->(DbSetOrder(1))
		//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
		
		
		
		MsgRun("Aguarde, Apurando Divergencias ",,{||MEW01MArq() })
		
		STM01Dif()
		
	endif
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณSTESTM01  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
	
Static Function STM01MArq()
	
	_acampos := {}
	AADD(_aCampos,{ "CODIGO" ,"C",15,0 } )
	AADD(_aCampos,{ "LOC"    ,"C",02,0 } )
	AADD(_aCampos,{ "DESCRI" ,"C",30,0 } )
	AADD(_aCampos,{ "QTd_SB2" ,"N",15,3 } )
	AADD(_aCampos,{ "QTd_SB8" ,"N",15,3 } )
	AADD(_aCampos,{ "QTd_SBF" ,"N",15,3 } )
	
	cNomArq := CriaTrab(_aCampos)
	dbUseArea( .T.,, cNomArq, "TRB", .T., .F. )
	IndRegua("TRB",cNomArq,"CODIGO+LOC",,,OemToAnsi("Selecionando Registros..."))
	
	SB2->(DbSetOrder(1))
	// B2_FILIAL+B2_COD+B2_LOCAL
	
	SBF->(DbSetOrder(2))
	// BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
	
	SB8->(DbSetOrder(1))
	//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	
	dbselectarea("SB2")
	
	DBSEEK(XFILIAL("SB2")+MV_PAR01,.T.)
	
	Do While SB2->b2_COD <= MV_PAR02 .AND. XFILIAL("SB2") == SB2->B2_FILIAL .AND. ! SB2->(Eof())
		
		IF SB2->B2_LOCAL # MV_PAR03 //.OR. B2_QATU < 0  // NAO FAZ SALDOS NEGATIVOS..........
			DBSKIP()
			LOOP
		ENDIF
		
		
		DBSELECTAREA("SB1")
		DBSEEK(XFILIAL("SB1")+SB2->B2_COD)
		
		IF SB1->B1_TIPO < MV_PAR05 .OR. SB1->B1_TIPO > MV_PAR06
			DBSELECTAREA("SB2")
			DBSKIP()
			LOOP
		ENDIF
		
		_lRastro := .f.
		_nsaldo_B8  := 0
		
		IF SB1->B1_RASTRO $ "SL"
			Dbselectarea("SB8")
			DBSEEK(XFILIAL("SB8")+SB2->B2_COD+SB2->B2_LOCAL,.T.)
			
			DO WHILE SB2->B2_COD + SB2->B2_LOCAL == B8_PRODUTO+B8_LOCAL .AND. !EOF()
				_nsaldo_B8 += B8_SALDO
				DbSkip()
			EndDo
			if sb2->b2_qatu # _nSaldo_B8 .or. mv_par04 = 2
				_lRastro := .t.
			endif
			
		ENDIF
		
		_lLocaliz := .f.
		_nSaldo_Bf := 0
		
		IF SB1->B1_LOCALIZ = "S"
			
			DbSelectArea("SBF")
			SBF->(DbSetOrder(2))
			dbseek(xfilial("SBF")+SB2->B2_COD + SB2->B2_LOCAL)
			
			Do while SB2->B2_COD + SB2->B2_LOCAL == BF_PRODUTO+BF_LOCAL .and. !eof()
				_nSaldo_Bf +=  BF_QUANT
				dbskip()
			Enddo
			
			Dbselectarea("SDA")
			dbSetOrder(1)
			DBSEEK(XFILIAL("SDA")+SB2->B2_COD + SB2->B2_LOCAL,.T.)
			
			DO WHILE SB2->B2_COD + SB2->B2_LOCAL == DA_PRODUTO+DA_LOCAL .AND. !EOF()
				_nSaldo_Bf += da_saldo
				DbSkip()
			EndDo
			
			if sb2->b2_qatu # _nSaldo_Bf .or. mv_par04 = 2
				_lLocaliz := .t.
			endif
			
		ENDIF
		
		if 	_lLocaliz .or. _lRastro
			
			dbselectarea("TRB")
			RECLOCK("TRB",.T.)
			CODIGO  := SB2->B2_COD
			LOC  	:= SB2->B2_LOCAL
			DESCRI  := SB1->B1_DESC
			QTd_SB2  := SB2->B2_QATU
			QTd_SB8  := _nSaldo_B8
			QTd_SBF  := _nSaldo_Bf
			MSUNLOCK()
			
		endif
		
		DBSELECTAREA("SB2")
		DBSKIP()
		
	ENDDO
	
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณSTESTM01  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
Static Function STM01Dif()
	
	Private cCadastro := "Cadastro de Divergencias de Estoques"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta um aRotina proprio                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Private aRotina := { 	{"Alterar"      ,"u__act_est",0,4} ,;
		{"Relatorio"    ,"u__act_rel",0,4} }
	
	Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	
	Private cString := "TRB"
	
	dbSelectArea("TRB")
	//dbsetorder(1)
	_aCampos	:= 		{ 	{"Codigo"	   			, 	"CODIGO"			, 	'C',15,00, "@!"	},;
		{"local" 	  			, 	"LOC"				, 	'C',02,00, "@!"},;
		{"Descricao do Produto" , 	"Descri"	   		, 	'C',35,00, "@!"},;
		{"Saldo em estoque"		, 	"qtd_sb2"	   		, 	'N',15,02, "@e 999,999,999.999"},;
		{"Saldo em Lotes" 		, 	"qtd_sb8"	   		, 	'N',15,02, "@e 999,999,999.999"},;
		{"Saldo em Enderecos"	, 	"qtd_sbf"			, 	'N',15,02, "@e 999,999,999.999"},;
		{"Tipo"				    , 	"tipo"				, 	'C',02,00, "@!"},;
		{"Grupo"				, 	"Grupo"				, 	'C',04,00, "@!"}}
	
	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString,_aCampos )
	
	
	dbSelectArea("TRB")
	dbCloseArea()
	
Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLMP_B2B8  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _fCriaSx1()
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If ! DbSeek(cPerg+"01",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "01"
		SX1->X1_PERGUNT := "Do Produto"
		SX1->X1_VARIAVL := "mv_ch1"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par01"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"02",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "02"
		SX1->X1_PERGUNT := "Ate Produto"
		SX1->X1_VARIAVL := "mv_ch2"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 15
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par02"
		SX1->X1_DEF01   := ""
		SX1->X1_F3		 := "SB1"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"03",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "03"
		SX1->X1_PERGUNT := "Local"
		SX1->X1_VARIAVL := "mv_ch3"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par03"
		SX1->X1_DEF01   := ""
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"04",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "04"
		SX1->X1_PERGUNT := "So c/ Diferenca ??"
		SX1->X1_VARIAVL := "mv_ch4"
		SX1->X1_TIPO    := "N"
		SX1->X1_TAMANHO := 1
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "C"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par04"
		SX1->X1_DEF01   := "Sim"
		SX1->X1_DEF02   := "Nao"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"05",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "05"
		SX1->X1_PERGUNT := "Tipo de"
		SX1->X1_VARIAVL := "mv_ch5"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par05"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"06",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "06"
		SX1->X1_PERGUNT := "Tipo ate"
		SX1->X1_VARIAVL := "mv_ch6"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 2
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par06"
		MsUnLock()
	EndIf
	
	
	If ! DbSeek(cPerg+"07",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "07"
		SX1->X1_PERGUNT := "Grupo de"
		SX1->X1_VARIAVL := "mv_ch7"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_F3      := "SBM"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par07"
		MsUnLock()
	EndIf
	
	If ! DbSeek(cPerg+"08",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "08"
		SX1->X1_PERGUNT := "Grupo Ate"
		SX1->X1_VARIAVL := "mv_ch8"
		SX1->X1_TIPO    := "C"
		SX1->X1_TAMANHO := 4
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_F3      := "SBM"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par08"
		MsUnLock()
	EndIf
	
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_check_endบAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _act_est
	
	_aTab_B8 := {}
	
	dbselectarea("SB1")
	DBSEEK(XFILIAL("SB1")+TRB->CODIGO)
	
	IF SB1->B1_RASTRO $ "SL"
		
		Dbselectarea("SB8")
		DBSEEK(XFILIAL("SB8")+TRB->CODIGO+TRB->LOC,.T.)
		
		DO WHILE TRB->CODIGO+TRB->LOC == B8_PRODUTO+B8_LOCAL .AND. !EOF()
			aadd(_aTab_B8,{B8_DTVALID,B8_LOTECTL,B8_NUMLOTE,B8_SALDO,B8_QTDORI,DTOS(B8_DATA),B8_SALDO,recno()})
			DbSkip()
			
		EndDo
		aadd(_aTab_B8,{,"TOTAL",,trb->qtd_Sb8,,,})
		
	else
		
		aadd(_aTab_B8,{,"-----",,,,,})
		
	Endif
	
	_aTab_Bf := {}
	
	_naEnder := 0
	
	IF SB1->B1_LOCALIZ = "S"
		
		Dbselectarea("SBF")
		DBSEEK(XFILIAL("SBF")+TRB->CODIGO+TRB->LOC,.T.)
		
		DO WHILE TRB->CODIGO+TRB->LOC == BF_PRODUTO+BF_LOCAL .AND. !EOF()
			aadd(_aTab_Bf,{bf_localiz,BF_LOTECTL,BF_NUMLOTE,BF_QUANT,BF_QUANT,recno(),BF_NUMSERI})
			DbSkip()
		EndDo
		
		aadd(_aTab_Bf,{"TOTAL",,,trb->qtd_Sbf,,,,})
		
		Dbselectarea("SDA")
		dbSetOrder(1)
		DBSEEK(XFILIAL("SDA")+TRB->CODIGO+TRB->LOC,.T.)
		
		DO WHILE TRB->CODIGO+TRB->LOC == DA_PRODUTO+DA_LOCAL .AND. !EOF()
			_naEnder += da_saldo
			DbSkip()
		EndDo
		
	else
		
		aadd(_aTab_Bf,{"-----",,,,,})
		
	Endif
	
	_nTot_Lots := trb->qtd_Sb8
	_nTot_Ends := trb->qtd_Sbf
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 450,800 TITLE OemToAnsi("Posicao de Estoque") Of oMainWnd PIXEL
	
	@ 002,002 SAY Alltrim(SB1->B1_COD)+"-"+ALLTRIM(SB1->B1_DESC)  Of oDlg PIXEL SIZE 245,009 FONT oBold
	@ 010,002 SAY "EM ESTOQUE(B2): " + TRANSFORM(TRB->QTD_SB2,"@E 99999,999.999")  Of oDlg PIXEL SIZE 245,009 FONT oBold COLOR CLR_HRED
	@ 016,004 To 13,397 Label "" of oDlg PIXEL
	
	/// ***** BOX DE LOTES (SUPERIOR) *****
	
	_atit_cab1:= 	{"Dt.Validade","Lote","Sub-lote","Saldo","Qtd.Original","Dt.Cr.Lote","Qtd apos o Acerto","Controle"}
	_atam_cab1:= 	{45,45,45,45,45,45,45}
	@ 017,002 SAY OemToAnsi("Lotes") of oDlg PIXEL COLOR CLR_HBLUE
	oListBox2 := TWBrowse():New( 025,2,397,69,,_atit_cab1,_atam_cab1,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox2:SetArray(_aTab_B8)
	oListBox2:bLine := { || _aTab_B8[oListBox2:nAT]}
	oListBox2:blDblClick := {|| Alin_qtd(1,oListBox2:nAT,7),oListBox2:refresh() }
	
	/// ***** BOX DE ENDERECOS (INFERIOR) *****
	
	_atit_cab2:= 	{"Endereco","Lote","Sub-Lote","Quantidade","Qtd apos o Acerto","Controle","Num. Serie"}
	_atam_cab2:= 	{55,55,55,55,55,55}
	@ 117,002 SAY OemToAnsi("Enderecos") of oDlg PIXEL COLOR CLR_HBLUE
	oListBox3 := TWBrowse():New( 125,2,397,69,,_atit_cab2,_atam_cab2,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox3:SetArray(_aTab_Bf)
	oListBox3:bLine := { || _aTab_Bf[oListBox3:nAT]}
	oListBox3:blDblClick := {|| Alin_qtd(2,oListBox3:nAT,5),oListBox3:refresh() }
	@ 196,200 SAY "TOTAL A ENDERECAR "+TRANSFORM( _naEnder,"@E 999,999,999.999") of oDlg PIXEL FONT oBold COLOR CLR_HRED
	
	@ 008,250 BUTTON OemToAnsi("Novo Endereco") SIZE 045,015  FONT oDlg:oFont ACTION {|| _Cr_NewEnd(),oDlg:refresh() }  OF oDlg PIXEL
	@ 008,300 BUTTON OemToAnsi("Ajustar") SIZE 045,015  FONT oDlg:oFont ACTION {|| AJUSTA_ARQ(),oDlg:End() }  OF oDlg PIXEL
	@ 008,350 BUTTON OemToAnsi("Sair")    SIZE 045,015  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	DBSELECTAREA("SB1")
	
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTEL_B2B8BFบAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static function Alin_qtd(_ntab,_nlin,_ncol)
	Local _x
	if _ntab == 1
		if _aTab_B8[_nlin,2] = "TOTAL" .OR. _aTab_B8[_nlin,2] = "-----"
			RETURN()
		ENDIF
		_nNewQtd := _aTab_B8[_nlin,_ncol]
	else
		if _aTab_BF[_nlin,1] = "TOTAL" .OR. _aTab_BF[_nlin,1] = "-----"
			RETURN()
		ENDIF
		_nNewQtd := _aTab_Bf[_nlin,_ncol]
	endif
	
	DEFINE MSDIALOG oDlg1 FROM 000,000  TO 150,250 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL
	@ 1,1 Say "Nova Quantidade"   of odlg1
	@ 2,1 get  _nNewQtd PICTURE "@E 999,999,999.999" SIZE 50,4 of odlg1
	@ 5,15 BUTTON "Ok" SIZE 50,15 ACTION (oDlg1:End())
	ACTIVATE DIALOG oDlg1 CENTER
	
	if _ntab == 1
		_aTab_B8[_nlin,_ncol]:= _nNewQtd
		_nTot_Lots := 0
		FOR _X:=1 TO LEN(_aTab_B8)-1
			_nTot_Lots += _aTab_B8[_X,_ncol]
		NEXT _X
		_aTab_B8[LEN(_aTab_B8),4]:= _nTot_Lots
	else
		_aTab_Bf[_nlin,_ncol]:= _nNewQtd
		_nTot_Ends := 0
		FOR _X:=1 TO LEN(_aTab_BF)-1
			_nTot_Ends += _aTab_Bf[_X,_ncol]
		NEXT _X
		_aTab_BF[LEN(_aTab_BF),4]:= _nTot_Ends
	endif
	
	odlg:refresh()
	
return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTA_ARQบAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTA_ARQ
	Local a
	_llimpa :=.f.
	Begin Transaction 
		IF SB1->B1_RASTRO $ "SL"
			if 	int(_aTab_B8[len(_aTab_B8),4]) # int(TRB->QTD_SB2)
				msgstop("Saldo Dos lotes nao Batem !!!!! Verifique")
				_llimpa :=.f.
			else
				_llimpa :=.t.
				FOR A:=1 TO LEN(_aTab_B8)-1
					IF _aTab_B8[a,7] # _aTab_B8[a,4]
						DBSELECTAREA("SD5")
						RECLOCK("SD5",.T.)
						replace D5_FILIAL   WITH  XFILIAL('SD5')
						replace D5_PRODUTO  WITH  TRB->CODIGO
						replace D5_LOCAL    WITH  TRB->LOC
						replace D5_DATA     WITH  DDATABASE
						replace D5_DTVALID  WITH  _aTab_B8[a,1]
						replace D5_LOTECTL  WITH  _aTab_B8[a,2]
						replace D5_NUMLOTE  WITH  _aTab_B8[a,3]
						replace D5_DOC      WITH  "AC"+SUBSTR(DTOS(DDATABASE),5,4)
						if _aTab_B8[a,7] < _aTab_B8[a,4]
							replace D5_QUANT    WITH  _aTab_B8[a,4]-_aTab_B8[a,7]
							replace D5_ORIGLAN  WITH '999'
						else
							replace D5_QUANT    WITH  _aTab_B8[a,7]-_aTab_B8[a,4]
							replace D5_ORIGLAN  WITH '499'
						endif
						SD5->(MSUNLOCK())
						
						DBSELECTAREA("SB8")
						GOTO _aTab_B8[a,8]
						RECLOCK("SB8",.F.)
							B8_SALDO := _aTab_B8[a,7]
						SB8->(MsUnlock())
					ENDIF
					
				NEXT A
			endif
		Endif
		
		
		IF SB1->B1_LOCALIZ = "S"
			
			if 	int(_aTab_Bf[len(_aTab_Bf),4]) # int(TRB->QTD_SB2)
				msgstop("Saldo Dos Enderecos nao Batem !!!!! Verifique")
				_llimpa :=.f.
			else
				_llimpa :=.t.
				FOR A:=1 TO LEN(_aTab_Bf)-1
					IF _aTab_Bf[a,5] # _aTab_Bf[a,4]
						_cProxNum	:= SDB->(ProxNum())
						DBSELECTAREA("SDB")
						RecLock("SDB",.t.)
						DB_FILIAL 	:=	xFilial("SDB")
						DB_ITEM		:= "0001"
						DB_PRODUTO	:= TRB->CODIGO
						DB_LOCAL	:= TRB->LOC
						DB_LOCALIZ	:= _aTab_Bf[a,1]
						DB_DOC		:= "AC"+SUBSTR(DTOS(DDATABASE),5,4)
						DB_ORIGEM	:= "SD3"
						DB_DATA		:= dDataBase
						DB_LOTECTL	:= _aTab_Bf[a,2]
						DB_NUMLOTE	:= _aTab_Bf[a,3]
						DB_NUMSEQ	:= _cProxNum
						DB_NUMSERI	:= _aTab_BF[a,7]
						DB_TIPO		:= "D"
						DB_ATIVID	:= "ZZZ"
						DB_ANOMAL   := "N"
						if _aTab_Bf[a,5] < _aTab_Bf[a,4]
							DB_TM		:= "999"
							DB_SERVIC	:= "999"
							DB_QUANT	:= _aTab_Bf[a,4] - _aTab_Bf[a,5]
						else
							DB_TM		:= "499"
							DB_SERVIC	:= "499"
							DB_QUANT	:= _aTab_Bf[a,5] - _aTab_Bf[a,4]
						endif
						SDB->(MsUnLock())
						
						if _aTab_BF[a,6] # 0
							DBSELECTAREA("SBF")
							GOTO _aTab_BF[a,6]
							RecLock("SBF",.f.)
							SBF->BF_QUANT := _aTab_Bf[a,5]
							SBF->(MsUnLock())
						else
							RecLock("SBF",.t.)
							SBF->BF_FILIAL  := xFilial("SBF")
							SBF->BF_PRODUTO := TRB->CODIGO
							SBF->BF_LOCAL	 := TRB->LOC
							SBF->BF_NUMSERI  := _aTab_Bf[a,7]
							SBF->BF_LOTECTL	 := _aTab_Bf[a,2]
							SBF->BF_NUMLOTE	 := "       "
							SBF->BF_LOCALIZ	 := _aTab_Bf[a,1]
							SBF->BF_PRIOR	 := "   "
							SBF->BF_QUANT    := _aTab_Bf[a,5]
							SBF->(MsUnLock())
						endif
						
					endif
					
				next a
				
			endif
			
		Endif
		
		
		if _llimpa
			dbselectarea("TRB")
			RecLock("TRB",.f.)
			DELETE
			SBF->(MsUnLock())
		ENDIF
	End Transaction

return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ_Cr_NewEndบAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
	
Static Function _Cr_NewEnd
	
	
	DEFINE MSDIALOG oDlg1 FROM 000,000  TO 250,350 TITLE OemToAnsi("Informe a nova Quantidade") Of oMainWnd PIXEL
	
	_lcria :=.f.
	_cNewLocal := space(2)
	_cNewLote  := space(10)
	_cNewEnder := space(15)
	_cNewSerie := space(10)
	
	//@ 1,1 Say "Local"   		of odlg1
	//@ 2,1 get  _cNewLocal PICTURE "@!" SIZE 30,4 of odlg1
	
	@ 1,1 Say "Novo Endereco"  	of odlg1
	@ 2,1 get  _cNewEnder PICTURE "@!" SIZE 70,4 of odlg1
	
	@ 4,1 Say "Lote"     		of odlg1
	@ 5,1 get  _cNewLote  PICTURE "@!"  SIZE 70,4 of odlg1
	
	@ 7,1 Say "Num Serie"     		of odlg1
	@ 8,1 get  _cNewSerie  PICTURE "@!"  SIZE 70,4 of odlg1

	@ 25,92 BUTTON "Cancela" SIZE 30,15 ACTION (oDlg1:End())
	@ 45,92 BUTTON "Ok"      SIZE 30,15 ACTION (CriaLoc() , oDlg1:End())
	
	ACTIVATE DIALOG oDlg1 CENTER
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณCria_Loc  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
Static Function CriaLoc()
	Local _x
	dbselectarea("SBE")
	dbsetorder(1)
	dbseek(xfilial("SBE")+mv_par03+_cNewEnder)
	
	If eof()
		
		msgstop("Locallizacao nao existe no armazem "+ mv_par03 +" !!!   Verifoque !!!")
		
	else
		if !empty(_cNewLote)
			_npos := Ascan(_aTab_B8, {|x| Trim(x[2]) ==  Trim(_cNewLote)	})
		else
			_npos := 1
		endif
		
		if _npos == 0
			
			msgstop("Lote nao exite para este produto !!!   Verifoque !!!")
			
		else
			
			_aTab_Bf[len(_aTab_Bf),1] := _cNewEnder
			_aTab_Bf[len(_aTab_Bf),2] := _cNewLote
			_aTab_Bf[len(_aTab_Bf),4] := 0
			_aTab_Bf[len(_aTab_Bf),5] := 0
			_aTab_Bf[len(_aTab_Bf),6] := 0
			_aTab_Bf[len(_aTab_Bf),7] := _cNewSerie
			_nTot_Ends :=0
			
			FOR _X:=1 TO LEN(_aTab_BF)
				_nTot_Ends += _aTab_Bf[_X,5]
			NEXT _X
			
			aadd(_aTab_Bf,{"TOTAL",,,_nTot_Ends,,,,})
		endif
	endif
	
	
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณSTESTM01  บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
	
Static Function MEW01MArq()
	
	_acampos := {}
	AADD(_aCampos,{ "CODIGO" ,"C",15,0 } )
	AADD(_aCampos,{ "LOC"    ,"C",02,0 } )
	AADD(_aCampos,{ "DESCRI" ,"C",30,0 } )
	AADD(_aCampos,{ "QTd_SB2" ,"N",15,3 } )
	AADD(_aCampos,{ "QTd_SB8" ,"N",15,3 } )
	AADD(_aCampos,{ "QTd_SBF" ,"N",15,3 } )
	AADD(_aCampos,{ "TIPO" 	  ,"C",2,0 } )
	AADD(_aCampos,{ "GRUPO"   ,"C",4,0 } )
	
	cNomArq := CriaTrab(_aCampos)
	dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
	IndRegua("TRB",cNomArq,"CODIGO+LOC",,,OemToAnsi("Selecionando Registros..."))
	
	
	_cQuery := "SELECT  DISTINCT "
	_cQuery += "B2_FILIAL,B2_COD,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_GRUPO,B2_LOCAL,MAX(SALDO_SB2) AS SALDO_SB2,MAX(SALDO_SBF) AS SALDO_SBF,MAX(SALDO_SB8) AS SALDO_SB8 "
	_cQuery += "FROM "
	
	_cQuery += "(
	_cQuery += "SELECT B2_FILIAL,B2_COD,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_GRUPO,B2_LOCAL,SUM(B2_QATU) AS SALDO_SB2 "
	_cQuery += "        ,NVL((SELECT SUM(B8_SALDO) FROM "+ RETSQLNAME("SB8")+ " WHERE B8_FILIAL = B2_FILIAL AND   B2_COD  = B8_PRODUTO  AND B2_LOCAL =  B8_LOCAL   AND  D_E_L_E_T_ = ' '  ),0) AS SALDO_SB8
	_cQuery += "        ,NVL((SELECT SUM(BF_QUANT) FROM "+ RETSQLNAME("SBF")+ " WHERE BF_FILIAL = B2_FILIAL AND   B2_COD  = BF_PRODUTO  AND B2_LOCAL =  BF_LOCAL   AND  D_E_L_E_T_ = ' '  ),0) AS SALDO_SBF
	_cQuery += "         FROM "+ RETSQLNAME("SB2")
	_cQuery += "         LEFT JOIN "+ RETSQLNAME("SB1")+ " ON B1_FILIAL = ' ' AND  B2_COD = B1_COD AND "+ RETSQLNAME("SB1")+ ".D_E_L_E_T_ = ' '
	_cQuery += "         WHERE B1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'
	_cQuery += "                AND B2_COD   BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	_cQuery += "                AND B1_TIPO  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += "                AND B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR03+"' "
	_cQuery += "                AND "+ RETSQLNAME("SB2")+ ".D_E_L_E_T_ = ' ' "
	_cQuery += "                AND "+ RETSQLNAME("SB2")+ ".B2_FILIAL = '"+XFILIAL("SB2")+"' "
	_cQuery += "         GROUP BY B2_FILIAL,B2_COD,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_GRUPO,B2_LOCAL "
	_cQuery += " ) TEMP"
	
	If MV_PAR04 == 1
		
		if getmv("MV_RASTRO") == 'S'
			
			_cRastro := "  (B1_RASTRO <> ' '  AND SALDO_SB2 <> SALDO_SB8   ) "
			
			
		Else
			
			_cRastro := ''
			
		endif
		
		if getmv("MV_LOCALIZ") == 'S'
			
			_cLocaliz := "  (B1_LOCALIZ <> ' '  AND SALDO_SB2 <> SALDO_SBF  ) "
			
		Else
			
			cLocaliz := ''
			
		endif
		
		if !empty( _cRastro ) .and.!empty( _cLocaliz )
			
			_cQuery += " WHERE " + _cRastro + ' or ' + _cLocaliz
			
		Elseif !empty( _cRastro )
			
			_cQuery += " WHERE " + _cRastro
			
		Elseif !empty( _cLocaliz )
			
			_cQuery += " WHERE "  + _cLocaliz
			
		endif
		
		
	Endif
	
	_cQuery += " GROUP BY B2_FILIAL,B2_COD,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_GRUPO,B2_LOCAL      "
	_cQuery += " ORDER BY B2_FILIAL,B2_COD,B1_RASTRO,B1_LOCALIZ,B1_DESC,B1_TIPO,B1_GRUPO,B2_LOCAL      "
	
	
	MEMOWRITE("B2B8BF.SQL",_cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TTB", .T., .F.)
	TCSetField('TTB',"SALDO_SB2","N",18,2)
	TCSetField('TTB',"SALDO_SB8","N",18,2)
	TCSetField('TTB',"SALDO_SBF","N",18,2)
	
	
	dbSelectArea("TTB")
	dbGoTop()
	
	While !EOF()
		
		dbselectarea("TRB")
		RECLOCK("TRB",.T.)
		CODIGO  := TTB->B2_COD
		LOC  	:= TTB->B2_LOCAL
		DESCRI  := TTB->B1_DESC
		QTd_SB2  := TTB->SALDO_SB2
		QTd_SB8  := TTB->SALDO_SB8
		QTd_SBF  := TTB->SALDO_SBF
		TIPO     := TTB->B1_TIPO
		GRUPO    := TTB->B1_GRUPO
		MSUNLOCK()
		dbSelectArea("TTB")
		
		DbSkip()
		
	Enddo
	
	
	dbSelectArea("TTB")
	dbCloseArea("TTB")
	
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ _Rel_est บAutor  ณRVG                 บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _act_rel
	
	
	Local oReport
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInterface de impressao                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport:= ReportDef()
	oReport:PrintDialog()
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportDef ณ Autor ณMarcos V. Ferreira     ณ Data ณ13/06/05  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณA funcao estatica ReportDef devera ser criada para todos os ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATR350			                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef()
	
	Local aOrdem    := {}
	Local cPictQt   := PesqPict("SB2","B2_QATU")
	Local nTamQt    := TamSX3('B2_QATU')[1]
	Local oCabec
	Local oFaltas
	Private cAliasTRB := "TRB"
	
	
	oReport:= TReport():New("STPCR004","Comparacao Estoque x Lotes x Enderecos", , {|oReport| ReportPrint(oReport)},"O relatorio irแ listar saldos em estoque STECK ")
	
	oSection1 := TRSection():New(oReport,"Comparacao Estoque x Lotes x Enderecos ",{},aOrdem)
	oSection1:SetTotalInLine(.F.)
	
	TRCell():New(oSection1,'CODIGO'    	,cAliasTRB,'Produto',		/*Picture*/,15,/*lPixel*/, )
	TRCell():New(oSection1,'DESCRI' 	,cAliasTRB,'Descricao',		/*Picture*/,35,/*lPixel*/, )
	TRCell():New(oSection1,'TIPO' 		,cAliasTRB,'Tipo' ,			/*Picture*/,4,/*lPixel*/, )
	TRCell():New(oSection1,'GRUPO' 		,cAliasTRB,'Grupo',			/*Picture*/,5,/*lPixel*/, )
	TRCell():New(oSection1,'LOC'		,cAliasTRB,'Arm',			/*Picture*/,4,/*lPixel*/, )
	TRCell():New(oSection1,'QTD_SB2'	,cAliasTRB,"Saldo SB2"   	,"@E 999999,999.99",14,/*lPixel*/,,,,"LEFT")
	TRCell():New(oSection1,'QTD_SB8'	,cAliasTRB,"Saldo SB8"   	,"@E 999999,999.99",14,/*lPixel*/,,,,"LEFT")
	TRCell():New(oSection1,'QTD_SBF'	,cAliasTRB,"Saldo SBF"   	,"@E 999999,999.99",14,/*lPixel*/,,,,"LEFT")
	
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrint ณ Autor ณ RVG                 ณ Data ณ05/04/13  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณA funcao estatica ReportPrint devera ser criada para todos  ณฑฑ
ฑฑณ          ณos relatorios que poderao ser agendados pelo usuario.       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relatorio                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ       			                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)
	
	Local oSection1    := oReport:Section(1)
	Local nOrdem       := oSection1:GetOrder()
	
	
	dbSelectArea("TRB")
	__cRec :=Recno()
	
	DbGoTop()
	
	_nRec := 0
	DbEval({|| _nRec++  })
	
	DbGoTop()
	
	oSection1:Init()
	
	oReport:SetMeter(_nRec)
	
	Do While !eof()
		
		oReport:IncMeter()
		
		oSection1:PrintLine()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		dbSelectArea("TRB")
		DbSkip()
		
	Enddo
	
	oSection1:Finish()
	
	dbSelectArea("TRB")
	dbGoto(__cRec)
	
Return









User Function SDBSB2()
	Private _cProxNum	:= ' '
	
	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := 'SB2XSBF'+cHora+ cMinutos+cSegundos
	Private cAliassbf := 'SBF'+cHora+ cMinutos+cSegundos
	Private cQuery    := ' '
	Private _aSp      := {}
	Private _aAm      := {}
	Private _aSp02    := {}
	
	
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
	/*
	cQuery := " SELECT 'SP'
	cQuery += ' "EMPRESA",B2_FILIAL,B2_COD "PRODUTO",B2_CMFIM1 "CUSTO",  B2_LOCAL "ARMAZEM",nvl(B2_QATU,0) "ESTOQUE",B2_QACLASS "CLASSIFICAR", SUM (BF_QUANT) "SBF", (B2_QATU-B2_QACLASS)- SUM (BF_QUANT) AS "DIFERENCA"
	cQuery += " FROM SB2010 SB2
	cQuery += " INNER JOIN(SELECT * FROM SBF010) SBF ON SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' ' AND SUBSTR(SB2.B2_COD,1,3) <> 'MOD' AND (B2_QATU-B2_QACLASS)-  NVL((SELECT SUM (BF_QUANT)  FROM SBF010 SBF WHERE SBF.D_E_L_E_T_ = ' '  AND B2_COD = BF_PRODUTO  AND BF_FILIAL=B2_FILIAL AND BF_LOCAL=B2_LOCAL),0) <> 0
	cQuery += "       GROUP BY B2_FILIAL,B2_COD,B2_CMFIM1,B2_LOCAL,B2_QATU,B2_QACLASS
	
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			
			If (cAliasLif)->ESTOQUE = 0 .And. (cAliasLif)->B2_FILIAL = '01' .And. (cAliasLif)->SBF > 0
				*/
				
				cQuery := " 	SELECT * FROM SBF010 SBF
				cQuery += " 	WHERE SBF.D_E_L_E_T_ = ' '
				cQuery += " 	AND SBF.BF_FILIAL = '01' and SBF.BF_QUANT <> 0
				//	cQuery += " 	AND SBF.BF_PRODUTO = '"+(cAliasLif)->PRODUTO+"' AND SBF.BF_LOCAL =  '"+(cAliasLif)->ARMAZEM+"'
				
				
				
				If Select(cAliassbf) > 0
					(cAliassbf)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliassbf)
				dbSelectArea(cAliassbf)
				If  Select(cAliassbf) > 0
					
					(cAliassbf)->(dbgotop())
					Begin Transaction 
						While !(cAliassbf)->(Eof())
							
							_cProxNum	:= SDB->(ProxNum())
							DBSELECTAREA("SDB")
							RecLock("SDB",.t.)
							DB_FILIAL 	:=	'01'
							DB_ITEM		:= "0001"
							DB_PRODUTO	:= (cAliassbf)->BF_PRODUTO
							DB_LOCAL	:= (cAliassbf)->BF_LOCAL
							DB_LOCALIZ	:= (cAliassbf)->BF_LOCALIZ
							DB_DOC		:= "AJ"+SUBSTR(DTOS(DDATABASE),5,4)
							DB_ORIGEM	:= "SD3"
							DB_DATA		:= dDataBase
							DB_LOTECTL	:= (cAliassbf)->BF_LOTECTL
							DB_NUMLOTE	:= (cAliassbf)->BF_NUMLOTE
							DB_NUMSEQ	:= _cProxNum
							DB_NUMSERI	:= (cAliassbf)->BF_NUMSERI
							DB_TIPO		:= "D"
							DB_ATIVID	:= "ZZZ"
							DB_ANOMAL   := "N"
							If (cAliassbf)->BF_QUANT < 0
								DB_TM		:= "499"
								DB_SERVIC	:= "499"
								DB_QUANT	:= ((cAliassbf)->BF_QUANT * -1)
							Else
								DB_TM		:= "999"
								DB_SERVIC	:= "999"
								DB_QUANT	:= ((cAliassbf)->BF_QUANT * 1)
							EndIf
							SDB->(MsUnLock())
							
							
							DBSELECTAREA("SBF")
							GOTO (cAliassbf)->R_E_C_N_O_
							RecLock("SBF",.f.)
								SBF->BF_QUANT := 0
							SBF->(MsUnLock())
							
							(cAliassbf)->(dbSkip())
						End
					End Transaction 
					(cAliassbf)->(dbCloseArea())
					
				EndIf
				
				/*
			EndIf
			
			(cAliasLif)->(dbSkip())
		End
		
	EndIf
	(cAliasLif)->(dbCloseArea())
	*/
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpSB1XLS บAutor  ณRenato Nogueira     บ Data ณ  28/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma utilizado para importar dados para a SB1 atraves deบฑฑ
ฑฑบ          ณum arquivo excel                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ImpSB1MRP()

Local cArq    := "mrpprevest_ok.csv"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local cDir	  := "C:\"
Local n		  := 0   
Local i		  := 0 
Local aNeg		:={}

_cLog:= "RELATำRIO DE ESTOQUES NEGATIVOS "+CHR(13) +CHR(10)

Private aErro := {}

If !File(cDir+cArq)
	MsgStop("O arquivo " +cDir+cArq + " nใo foi encontrado. A importa็ใo serแ abortada!","[AEST901] - ATENCAO")
	Return
EndIf

FT_FUSE(cDir+cArq)                   // abrir arquivo
ProcRegua(FT_FLASTREC())             // quantos registros ler
FT_FGOTOP()                          // ir para o topo do arquivo
While !FT_FEOF()                     // fa็a enquanto nใo for fim do arquivo
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()           // lendo a linha
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

//Begin Transaction             //inicia transa็ใo
ProcRegua(Len(aDados))   //incrementa regua
For i:=1 to Len(aDados)  //ler linhas da array
	
	IncProc("Importando SB1...")
	
	DbSelectArea("SB1")
	SB1->(DbGoTop())
	SB1->(dbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+aDados[i,1]))
	
	DbSelectArea("SC4")
	SC4->(DbSetOrder(1))
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140315"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,2])       
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160414"
		SC4->C4_DATA	:=  CTOD("15/03/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,2])
		SC4->(MsUnlock())
	EndIf
	
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140401"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,3])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("01/04/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,3])       
		SC4->(MsUnlock())
	EndIf
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140415"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,4])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("15/04/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,4])       
		SC4->(MsUnlock())
	EndIf                           
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140501"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,5])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("01/05/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,5])       
		SC4->(MsUnlock())
	EndIf  
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140515"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,6])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("15/05/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,6])       
		SC4->(MsUnlock())
	EndIf     
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140601"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,7])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("01/06/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,7])       
		SC4->(MsUnlock())
	EndIf   
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140615"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,8])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("15/06/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,8])       
		SC4->(MsUnlock())
	EndIf                                 
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140701"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,9])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("01/07/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,9])       
		SC4->(MsUnlock())
	EndIf                                 
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140715"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,10])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("15/07/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,10])       
		SC4->(MsUnlock())
	EndIf                                  
	
	SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140801"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,11])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("01/08/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,11])       
		SC4->(MsUnlock())
	EndIf                                  
	
		SC4->(DbGoTop())
	SC4->(DbSeek(xFilial("SC4")+SB1->B1_COD+"20140815"))
	
	If SC4->(!Eof())       
		SC4->(Reclock("SC4",.F.))
		SC4->C4_QUANT	:=	Val(aDados[i,12])
		SC4->(MsUnlock())
	Else
		SC4->(Reclock("SC4",.T.))
		SC4->C4_FILIAL	:=  xFilial("SC4")
		SC4->C4_PRODUTO :=  aDados[i,1]
		SC4->C4_LOCAL	:=  SB1->B1_LOCPAD
		SC4->C4_OBS		:=  "CARGA 160614"
		SC4->C4_DATA	:=  CTOD("15/08/2014")
		SC4->C4_QUANT	:=	Val(aDados[i,12])       
		SC4->(MsUnlock())
	EndIf
	
	If SB1->(Eof())
		
	_ClOG+= "C๓digo: "+aDados[i,1]+"  nใo encontrado"+CHR(13) +CHR(10)
		
	Endif
	
	
Next i
//End Transaction              // finaliza transa็ใo

FT_FUSE()

@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return










