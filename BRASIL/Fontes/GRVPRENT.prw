#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#INCLUDE "AP5MAIL.CH"
#include 'parmtype.ch'

#define _LOCK_TIMEOUT    10
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_ONLYSERVER + GETF_LOCALHARD + GETF_LOCALFLOPPY )
#DEFINE _Cr CHR(13)+CHR(10)
#Define CR chr(13)+chr(10)

Static cColorI   := "<b><FONT COLOR=RED>"
Static cColorF   := "</b></FONT>"
Static cSitSA5   := ""
Static lVld1     := .F.
Static lAtuNCM   := .F.
Static aErrorLog := {}
Static aREFNF    := {}
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅGRVPRENT	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅTela utilizada para gerar as pre-notas					  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ	    							 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function GRVPRENT()
	Private cEVFilial := cFilAnt
	Private cCadastro := "Geracao de pre-notas"
	Private cAlias := "SZ9"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" 		,  0 , 1 },;
		{ "Visualizar" 			, "AxALTERA" 	, 0 , 4 },;
		{ "Gerar pre-nota" 		, "U_EXECPREN" 	, 0 , 3 },;
		{ "Baixar XML"		 	, "U_BAIXAXM1" 	, 0 , 4 },;
		{ "Legenda"    			, "U_GRVPRELG" 	, 0 , 5 },;
		{ "Gerar com arquivo"	, "U_EXECPREA" 	, 0 , 6 },;
		{ "Exportar XML"		, "U_EXPORTXM" 	, 0 , 7 },;
		{ "Visualizar pre-nota"	, "U_VISPRENF" 	, 0 , 8 },;
		{ "Visualizar Danfe"	, "U_XVERDANFE(SZ9->Z9_CHAVE)" 	, 0 , 9 },;
		{ "Consulta Inconsistкncia", "U_INCONSIS", 0 , 10},;
		{ "Rel.Inconsistencia"	   , "U_RSTFATAR" 	, 0 , 11 }}

	cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	/*
	If !U_XCNPJAUT(cCnpj)
		MsgAlert("AtenпїЅпїЅo, este CNPJ nпїЅo estпїЅ autorizado para utilizar a rotina")
		Return()
	EndIf
	*/
	dbSelectArea(cAlias)
	dbSetOrder(3)

	aCores := { {"SZ9->Z9_STATUS == '0'", "BR_AZUL"},;
		{"AllTrim(SZ9->Z9_STATUSA)=='Confirmada Operacao' .Or. AllTrim(SZ9->Z9_STATUSA)=='Confirmada Operaзгo'", "BR_VERDE"},;
		{"SZ9->Z9_STATUS == '2'", "BR_VERMELHO"},;
		{"SZ9->Z9_STATUS == '3' .OR. Upper(Alltrim(SZ9->Z9_STATUSA)) == 'NF CANCELADA' ", "BR_PRETO"}}

	mBrowse(,,,,cAlias,,,,,,aCores)

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅGRVPRELG	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅLegendas													  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ	    							 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function GRVPRELG()

	BrwLegenda(cCadastro, "Legenda", {	{"BR_AZUL"    , "Aguardando realizar manifesto" },;
		{"BR_VERDE"   , "Aguardando gerar pre-nota" },;
		{"BR_VERMELHO", "Pre-nota gerada"},;
		{"BR_PRETO"	  , "Operacao nao realizada"}})

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅEXECPREN	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFunпїЅпїЅo utilizada para fazer a integraпїЅпїЅo do xml com a 	  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅpre-nota							 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function EXECPREN(lJOB, aErrorLog)
	Local _aCols      := {}
	Local cCnpj       := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	Local cUf         := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")
	Default lJob      := .F.
	Default aErrorLog := {}
	PRIVATE cARQLOG   := 'jobprenf' +cEmpAnt+cFilAnt+ '.txt'

	DO CASE

		//CASE AllTrim(SZ9->Z9_STATUSA)=='Confirmada Operacao' .Or. AllTrim(SZ9->Z9_STATUSA)=='Confirmada OperaпїЅпїЅo
		//MsgAlert("AtenпїЅпїЅo, realize a manifestaпїЅпїЅo do destinatпїЅrio primeiro!")
		//Return()

	CASE ALLTRIM(SZ9->Z9_STATUSA)=="Ciencia"
		aadd(_aCols,{'1',SZ9->Z9_CHAVE})

	CASE SZ9->Z9_STATUS=="2"
		Conout("Pre-nota ja gerada, verifique!")
		IF !lJOB
			MsgAlert("Pre-nota ja gerada, verifique!")
		Endif
		Return()
	CASE SZ9->Z9_STATUS=="3"
		Conout("Desconhecimento da Operacao ou Operacao nao Realizada")
		IF !lJOB
			MsgAlert("Desconhecimento da Operacao ou Operacao nao Realizada")
		Endif
		Return()
	CASE Empty(SZ9->Z9_XML)
		Conout("Atencao, utilize a funcao Baixar xml antes de gerar essa pre-nota")
		IF !lJOB
			MsgAlert("Atencao, utilize a funcao Baixar xml antes de gerar essa pre-nota")
		Endif
		Return()
	CASE SZ9->Z9_FILIAL<>cFilAnt
		Conout("Atencao, filial logada diferente da filial do XML, verifique")
		IF !lJOB
			MsgAlert("Atencao, filial logada diferente da filial do XML, verifique")
		Endif
		Return()
	CASE Upper(Alltrim(SZ9->Z9_STATUSA)) == "NF CANCELADA"
		Conout("Atencao, Nf Cancelada, verifique")
		IF !lJOB
			MsgAlert("Atencao, Nf Cancelada, verifique")
		Endif
		Return()
	ENDCASE

	PutMV("MV_PCNFE",.f.)

	lOut := .f. //Sair do programa

	cAviso := ""
	cErro  := ""

	_cXml:= Alltrim(SZ9->Z9_XML)
	_cXml:= FwCutOff(_cXml, .t.)
	oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)

	U_INSPRENF(oNfe, lJOB, @aErrorLog)

	If SZ9->Z9_STATUSA=="Ciencia                            "
		//Processa( {|lEnd| U_EXEMANIF(_aCols,cCnpj,cUf,1,@lEnd,2)}, "Aguarde...","Executando manifesto.", .T. )
	EndIf

Return()


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅBAIXAXM1	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFunпїЅпїЅo utilizada para baixar xml da sefaz				 	  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ									 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function BAIXAXM1()

	Local aArea	:= {}

	If SZ9->Z9_FILIAL<>cFilAnt
		MsgAlert("Atencao, filial logada diferente da filial do XML, verifique")
		Return()
	EndIf

	If Empty(SZ9->Z9_XML)

		aArea	:= GetArea()

		cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
		cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

		RestArea(aArea)

		U_BAIXAXML(SZ9->Z9_CHAVE,cUf,cCnpj)

	Else

		MsgAlert("Atencao, esse xml ja foi carregado")

	EndIf

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅEXECPREA	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFunпїЅпїЅo utilizada para gerar a pre-nota atravпїЅs de um arquivoпїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅxml								 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function EXECPREA()

	Local cAviso	:= ""
	Local cErro		:= ""

	_cRet := cGetFile("Arquivos XML (*.XML) |*.xml|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	_cRet := ALLTRIM(_cRet)

	nHdl    := fOpen(_cRet,0)

	If nHdl == -1
		Return
	Endif

	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)

	oNfe 	:= XmlParser(cBuffer,"_",@cAviso,@cErro)

	U_INSPRENF(oNfe,,,.t.)

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅINSPRENF	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFunпїЅпїЅo utilizada para gerar a pre-nota atravпїЅs de um arquivoпїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅxml								 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function INSPRENF(oNfe, lJob, aErrorLog, lGerArq)

	Local aTipo			:={'N','B','D'}
	Local cArquivo 		:= ""
	Local cAuxMail,lBloqueado,nX,nTipo,nIpi,lMarcou,lAchou
	Local nY			:= 0
	Local cNewDoc		:= ""
	Local cNewSerie		:= ""
	Local cNewBuffer	:= ""
	Local aAreaSF1		:= {}
	Local aArea			:= {}
	Local aItens        := {}
	Local ni 			:= 0
	Local nx 			:= 0
	Local nItem 		:= 0
	Local nLin          := 0
	Local aRet 			:= {}
	Local aParamBox 	:= {}
	Local aAreaSix		:= {}
	Local _cFatec		:= ""
	Local aGrvPcNF      := {}
	Local cMessaErro    := ""
	Local nW            := 0
	Local nREG          := 0
	Private lError      := .F.
	Private LMSGPROC    := .F.
	Private _oDlg
	Private CPERG   	:="NOTAXML"
	Private Caminho 	:= "\arquivos\NFE" //"E:\Protheus10_Teste\protheus_data\XmlNfe\  Foi alterado para \System\XmlNfe\ para funcionar de qualquer estacao Emerson Holanda 10/11/10
	Private _cMarca   	:= GetMark()
	Private aFields   	:= {}
	Private cArq,nHdl
	Private aFields2  	:= {}
	Private cArq2,cProds,cCodBar
	Private oAux,oICM,oNF,oNFChv,oEmitente,oIdent,oDestino,oTotal,oTransp,oDet,cChvNfe
	Private oFatura,cEdit1,_DESCdigit,_NCMdigit,lOut,lOk,_oPT00005
	Private lMsErroAuto,lMsHelpAuto
	Private lPcNfe		:= GETMV("MV_PCNFE")
	Private	_aRet 		:= {}
	Private	_aParamBox 	:= {}
	Private _aHeader	:= {}
	Private _aCols		:= {}
	Private aValidaN    := {}
	Private cNCM        := ""
	Private cNumNF      := ""
	Private cSerNF      := ""
	Private aSitTrib 	:= &(SuperGetMV("AF_XMLSTNO",,'{"00","10","20","30","40","41","50","51","60","70","90","PART"}'))
	Private nToleran    := SuperGetMV("ST_TOLEQUA",.F.,10)
	Private cUfSM0   	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")
	Private _cfop       := ""
	Private _lCfopPc    := .F.
	Private _lCfopNF    := .F.
	Private cREFNF      := ""					// Valdemir Rabelo 14/05/2020
	Public	_cCnpj		:= ""
	Default lJob    	:= .F.					// Valdemir Rabelo 10/03/2020
	Default lGerArq     := .F.

	aErrorLog := {}
	lVld1     := .F.

	if !lJob
		AADD(aParamBox,{3,"Tipo de nota",/*IIF(Set(_SET_DELETED),1,2)*/,{"Nota Normal","Nota Beneficiamento","Nota Devolucao"},70,"",.T.})
	Endif

	If VALType(oNFe) <> "U"
		If type("oNFe:_NfeProc") == "U"
			lJob
		Endif
		//cMsgError := ""
		//LjWriteLog( cARQLOG, cMsgError )
		IF (TYPE("oNFe:_NfeProc") != "U") //.or. (valType(oNFe:_NfeProc) = 'O')    // Adicionado valtype 10/06/2021
			If valType(oNFe:_NfeProc) = 'O'
				oNF := oNFe:_NFeProc:_NFe
			Else
				if valType(oNFe:_NFe)= 'O'
					oNF := oNFe:_NFe
				Else
					// Verifica a existencia de nota fiscal jб processada anteriormente. Se existi corrige
					if !lGerArq
						IF (SZ9->Z9_STATUS <> "2")
							SF1->( dbSetOrder(8) )
							if SF1->( dbSeek(xFilial('SF1')+SZ9->Z9_CHAVE) )
								RecLock('SF1',.f.)
								SZ9->Z9_STATUS := "2"
								SZ9->( MsUnlock() )
							endif
						ENDIF

						cMsgError := "RECNO: "+cValToChar(SZ9->(RECNO()))+" Chave: "+SZ9->Z9_CHAVE+" - Nao foi possivel abrir o arquivo XML, provavel falha em sua estrutura. Por favor substitua o arquivo"
						LjWriteLog( cARQLOG, cMsgError )
						Conout(cMsgError)
						if !lJob
							MsgAlert(cMsgError,"Atencao!")
						endif
						AddLogErr(aErrorLog, {Upper("Falha na estrutura"), upper(cMsgError),.f.})

						cMSGERROR := MntIncon(aErrorLog, 'Inconsistencias XML')    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
						SZ9->(RecLock("SZ9",.F.))
						SZ9->Z9_ERRO   := cMSGERROR
						SZ9->Z9_STATUS := "E"
						SZ9->( MsUnlock() )
					Endif
					Return()
				EndIf
			Endif
		else
			Return
		Endif
	Else
		if !lGerArq
			cMsgError := "RECNO: "+cValToChar(SZ9->(RECNO()))+" Chave: "+SZ9->Z9_CHAVE+" - Nao foi possivel abrir o arquivo XML, provavel falha em sua estrutura ou caracteres especiais. Por favor substitua o arquivo"
			Conout(cMsgError)
			if !lJob
				MsgAlert(cMsgError,"Atencao!")
			Endif
			AddLogErr(aErrorLog,{Upper("Falha na estrutura"), Upper(cMsgError),.f.})

			cMSGERROR := MntIncon(aErrorLog, 'Inconsistencias XML')    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_ERRO   := cMSGERROR
			SZ9->Z9_STATUS := "E"
			SZ9->( MsUnlock() )
		Endif
		Return()
	EndIf

	// Valdemir Rabelo 10/03/2020
	if !lJob
		If ParamBox(aParamBox,"Tipo de nota",@aRet,,,.T.,,500)

			DO CASE
			CASE aRet[1]==1
				MV_PAR01	:= 1
			CASE aRet[1]==2
				MV_PAR01	:= 2
			CASE aRet[1]==3
				MV_PAR01	:= 3
			ENDCASE

		Else

			Return()

		EndIf
	else
		If AllTrim(oNF:_InfNfe:_Ide:_finNFe:Text) == "1"
			//cTipoNF := "N"
			MV_PAR01	:= 1
		ElseIf AllTrim(oNF:_InfNfe:_Ide:_finNFe:Text) == "2"
			//cTipoNF := "D"
			MV_PAR01	:= 3
		Else
			//cTipoNF := "B"
			MV_PAR01	:= 2
		EndIf
	Endif

	aArea	:= GetArea()
	cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	RestArea(aArea)

	IF Type("oNfe:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ") != "U"
		If AllTrim(oNfe:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT) <> AllTrim(cCnpj)
			cMsgError := "Atencao, o CNPJ XML e diferente do CNPJ da filial logada, verifique!"
			conout(cMsgError)
			if !lJob
				MsgAlert(cMsgError)
			else
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
				AddLogErr(aErrorLog, {Upper("CNPJ XML"), Upper(cColorI+AllTrim(oNfe:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT) + " Diferente do CNPJ destino " + cCnpj + "  da filial logada"+cColorF),.f.})
			endif
			cMsgError := "Erro na estrutura / " + cMsgError
			if !lGerArq
				SZ9->(RecLock("SZ9",.F.))
				SZ9->Z9_ERRO := cMSGERROR
				SZ9->Z9_STATUS := "E"
				SZ9->( MsUnlock() )
			Endif
			Return()
		EndIf
	else
		if ValType(oNfe:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT) != NIL
			// Verificar como tratar em caso de pessoa fнsica
			Return
		endif
	Endif

	oNFChv := oNFe:_NFeProc:_protNFe

	oEmitente  := oNF:_InfNfe:_Emit
	oIdent     := oNF:_InfNfe:_IDE
	oDestino   := oNF:_InfNfe:_Dest
	oTotal     := oNF:_InfNfe:_Total
	oTransp    := oNF:_InfNfe:_Transp
	oDet       := oNF:_InfNfe:_Det
	cChvNfe    := oNFChv:_INFPROT:_CHNFE:TEXT

	Memowrite("PROCNFE.TXT",'Processando Chave: '+cChvNfe)     // Valdemir Rabelo 15/01/2021

	//	<chNFe>41101108365527000121550050000014611623309134</chNFe>
	If Type("oNF:_InfNfe:_ICMS")<> "U"
		oICM := oNF:_InfNfe:_ICMS
	Else
		oICM := nil
	Endif

	oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
	cEdit1	   := Space(15)
	_DESCdigit :=space(55)
	_NCMdigit  :=space(8)

	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	// ValidaпїЅпїЅes -------------------------------
	// -- CNPJ da NOTA = CNPJ do CLIENTE ? oEmitente:_CNPJ
	If MV_PAR01 = 1
		cTipo := "N"
	ElseIF MV_PAR01 = 2
		cTipo := "B"
	ElseIF MV_PAR01 = 3
		cTipo := "D"
		if !lJob
			If MsgYesNo("Nota fiscal de fatec?")

				_cCnpj		:= oNF:_InfNfe:_Emit:_Cnpj:Text

				AADD(_aParamBox,{1,"FATEC" ,Space(6),"","U_STFILPC1()","PC1FIL","",0,.T.})

				If ParamBox(_aParamBox,"Fatecs",@_aRet,,,.T.,,500)

					_cFatec	:= _aRet[1]

				EndIf

			EndIf
		else
			// Valdemir Rabelo 16/12/2020 - Ticket: 20201118010751
			_cCnpj	:= oNF:_InfNfe:_Emit:_Cnpj:Text
			_cFatec	:= getPC2(SZ9->Z9_NFEORI, SZ9->Z9_SERORI)
		Endif
		MV_PAR01 := 3
	Endif

	// CNPJ ou CPF
	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_CNPJ:TEXT)),ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))
	cIe  := AllTrim(IIf(Type("oEmitente:_CPF")=="U",ALLTRIM(AJUSTSTR(oEmitente:_IE:TEXT)),ALLTRIM(AJUSTSTR(oEmitente:_CPF:TEXT))))

	lAchou := .f.
	// Considerar situaпїЅпїЅo em que registro estпїЅ bloqueado
	If MV_PAR01 = 1 // Nota Normal Fornecedor
		cMsgError := "CNPJ ou IE Origem FORNECEDOR nao localizado - Verifique " + cCgc
		dbselectarea("SA2")
		//dbSetOrder(3)
		SA2->(DbOrderNickName("CGCINSCR2"))
		SA2->(dbSeek(xFilial("SA2")+cCgc))
		do while !lAchou .and. SA2->( !eof() ) .and. (xFilial("SA2") = SA2->A2_FILIAL) .AND. (TRIM(SA2->A2_CGC) == cCgc) .AND. (TRIM(SA2->A2_INSCR) == cIe)
			IF SA2->( FieldPos("A2_MSBLQL")) > 0
				IF !(SA2->A2_MSBLQL == "1")
					cMsgError := ""
					lAchou := .t.
					EXIT
				Else
					cMsgError := "Fornecedor estб bloqueado. Por favor, Verifique."
					lAchou    := .F.
					Exit
				endif
			else
				cMsgError := ""
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA2')
			dbskip()
		enddo
	Else
		cMsgError := "CNPJ ou IE Origem CLIENTE nao localizado - Verifique " + cCgc
		dbselectarea("SA1")
		//dbSetOrder(3)
		SA1->(DbOrderNickName("CGCINSCR1"))
		SA1->(dbSeek(xFilial("SA1")+cCgc+cIe))
		do while !lAchou .and. SA1->( !eof() ) .and. (xFilial("SA1") = SA1->A1_FILIAL) .AND. (TRIM(SA1->A1_CGC) == cCgc) .AND. (TRIM(SA1->A1_INSCR) == cIe)
			IF SA1->(FieldPos("A1_MSBLQL")) > 0
				IF !(SA1->A1_MSBLQL == "1")
					cMsgError := ""
					lAchou := .t.
					EXIT
				Else
					cMsgError := "Cliente estб bloqueado. Por favor, Verifique."
					lAchou    := .F.
					Exit
				endif
			else
				cMsgError := ""
				lAchou := .t.
				EXIT
			endif
			dbselectarea('SA1')
			dbskip()
		enddo
	Endif
	If !lAchou
		if !lJob
			MsgAlert(cMsgError)
		else
			cColorI := "<b><FONT COLOR=RED>"
			cColorF := "</b></FONT>"
			AddLogErr(aErrorLog, {Upper("CNPJ"), Upper(cColorI+cMsgError+cColorF),.f.})
			Conout(cMsgError)				// Valdemir Rabelo 10/03/2020
		endif
		lError := .t.
		PutMV("MV_PCNFE",lPcNfe)
		cMsgError := "Nгo localizado / " + cMsgError
		if !lGerArq
			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_ERRO := cMSGERROR
			SZ9->Z9_STATUS := "E"
			SZ9->( MsUnlock() )
		Endif
		//Return
	Endif

	OIdent:_nNF:TEXT	:= PADL(OIdent:_nNF:TEXT,9,"0")
	OIdent:_serie:TEXT	:= PADL(OIdent:_serie:TEXT,3,"0")
	//
	aREFNF := {}
	cREFNF := ""
	if Type("OIdent:_NFref:TEXT") != "U"
		cREFNF := OIdent:_NFref:_RefNFE:TEXT					// Valdemir Rabelo 14/05/2020
		aAdd(aREFNF,{'',cREFNF,0,'',''})
	else
		if Type("OIdent:_NFREF") =="A"
			For nX := 1 to Len(OIdent:_NFREF)
				if Type("OIdent:_NFref["+cvaltochar(nX)+"]:_REFNFE:TEXT") != "U"
					cREFNF	:= OIdent:_NFref[nX]:_REFNFE:TEXT
					aAdd(aREFNF,{'',cREFNF,0,'',''})
				else
					// Ticket: 20210506007450 - Valdemir Rabelo 13/05/2021
					if Type("OIdent:_NFref["+cvaltochar(nX)+"]:_REFNFP:TEXT") != "U"
						cREFNF	:= OIdent:_NFref[nX]:_REFNFP:TEXT
						aAdd(aREFNF,{'',cREFNF,0,'',''})
					else
						// Ticket: 20210506007450 - Valdemir Rabelo 13/05/2021
						Conout("Chave: "+cChvNfe+" nгo encontrou no Type('OIdent:_NFREF[nX]:_REFNFE:TEXT')")
						AddLogErr(aErrorLog,  {Upper("Referencia"), upper(cColorI+" Nao estб encontrando a Referкncia dentro do vetor"+cColorF),.f.})
						lError := .t.
					endif
				endif
			Next
		Endif
	Endif

	// -- Nota Fiscal jб existe na base ?
	If SF1->(DbSeek(XFilial("SF1")+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+Padr(AJUSTSTR(OIdent:_serie:TEXT),3)+SA2->A2_COD+SA2->A2_LOJA))
		cColorI := "<b><FONT COLOR=RED>"
		cColorF := "</b></FONT>"
		IF MV_PAR01 = 1
			Conout(Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida")
			if !lGerArq
				if !lJob			// Valdemir Rabelo 10/03/2020
					if !EMPTY(SZ9->Z9_GEROU)
						MsgAlert("Nota No.: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida")
					else
						MsgAlert("Nota No.: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja gerada por outro processo. A Importacao sera interrompida")
					Endif
				else
					if !EMPTY(SZ9->Z9_GEROU)
						AddLogErr(aErrorLog,  {Upper("Nota"), upper(cColorI+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida"+cColorF),.f.})
					else
						AddLogErr(aErrorLog,  {Upper("Nota"), upper(cColorI+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja gerada por outro processo"+cColorF),.f.})
					endif
				endif
			Endif
			cMSGERROR := MntIncon(aErrorLog, 'NOTA JБ GERADA')    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
			if !lGerArq
				RecLock("SZ9",.F.)
				if EMPTY(SZ9->Z9_GEROU)
					if Empty(SZ9->Z9_DOC)
						SZ9->Z9_DOC  := Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)
					Endif
					SZ9->Z9_ERRO := cMSGERROR
				ENDIF
				SZ9->( MsUnlock() )
				Return
			Else
				MsgAlert("Nota No.: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida")
			Endif
		Else
			Conout("Nota No.: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" Ja Existe. A Importacao sera interrompida")
			if !lJob
				MsgAlert("Nota No.: "+cColorI+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+"/"+AJUSTSTR(OIdent:_serie:TEXT)+" do Cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" Ja Existe. A Importacao sera interrompida"+cColorF)
			endif
		Endif
		lError := .t.
		PutMV("MV_PCNFE",lPcNfe)
		Return Nil
	EndIf
	aCabec   := {}
	aItens   := {}
	aValidaN := {}
	aadd(aCabec,{"F1_TIPO"   ,If(MV_PAR01==1,"N",If(MV_PAR01==2,'B','D')),Nil,Nil})
	aadd(aCabec,{"F1_XFATEC" ,IIf(!Empty(_cFatec),"S","")	,Nil,Nil})
	aadd(aCabec,{"F1_FORMUL" ,"N",Nil,Nil})
	aadd(aCabec,{"F1_DOC"    ,Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9),Nil,Nil})
	//If OIdent:_serie:TEXT ='0'
	//	aadd(aCabec,{"F1_SERIE"  ,"   ",Nil,Nil})
	//Else
	aadd(aCabec,{"F1_SERIE"  ,AJUSTSTR(OIdent:_serie:TEXT),Nil,Nil})
	//Endif

	///If oNFChv:_VERSAO:TEXT=="3.10"
	cData:=Alltrim(AJUSTSTR(OIdent:_dhEmi:TEXT))
	dData:=CTOD(SubStr(cData,9,2)+"/"+SubStr(cData,6,2)+"/"+SubStr(cData,1,4))
	//	Else
	//		cData:=Alltrim(AJUSTSTR(OIdent:_dhEmi:TEXT))
	//		dData:=CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
	//	EndIf
	SA2->( DBRUnlock( Recno() ) )    // Valdemir Rabelo 28/01/2021
	aadd(aCabec,{"F1_EMISSAO" ,dData,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE" ,If(MV_PAR01=1,SA2->A2_COD,SA1->A1_COD),Nil,Nil})
	aadd(aCabec,{"F1_LOJA"    ,If(MV_PAR01=1,SA2->A2_LOJA,SA1->A1_LOJA),Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE" ,"SPED ",Nil,Nil})
	aadd(aCabec,{"F1_CHVNFE"  ,cChvNfe,Nil,Nil})
	//If cTipo == "N"
	//	aadd(aCabec,{"F1_COND" ,If(Empty(SA2->A2_COND),'007',SA2->A2_COND),Nil,Nil})
	//Else
	//	aadd(aCabec,{"F1_COND" ,If(Empty(SA1->A1_COND),'007',SA1->A1_COND),Nil,Nil})
	//Endif

	// Primeiro Processamento
	// Busca de InformaпїЅпїЅes para Pedidos de Compras

	cProds := ''
	aPedIte:={}

	For nX := 1 To Len(oDet)
		cEdit1      := Space(15)
		_DESCdigit  :=space(55)
		_NCMdigit   :=space(8)
		aSize       := MsAdvSize(, .F., 400)
		aInfo 	    := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
		aObjects    := {{100, 100,.T.,.T. }}
		aPosObj     := MsObjSize( aInfo, aObjects,.T. )
		nStyle      := 0//GD_DELETE
		oProduto    := oDet[nX]:_Prod				//Valdemir Rabelo 11/03/2020
		cNumPC      := ""
		cITPEDC     := ""
		_cSeparador := ""
		_cfop       := oDet[nX]:_Prod:_CFOP:TEXT
		lAtuNCM     := .F.
		cNumNF      := OIdent:_nNF:TEXT
		cSerNF      := OIdent:_serie:TEXT

		If Left(Alltrim(_cfop),1)="5"
			_cfop:=Stuff(_cfop,1,1,"1")
		Elseif Left(Alltrim(_cfop),1)="6"
			_cfop:=Stuff(_cfop,1,1,"2")
		Elseif Left(Alltrim(_cfop),1)="7"
			_cfop:=Stuff(_cfop,1,1,"3")
		Endif
		_lCfopPc := getCFOPCPC(_cfop)
		_lCfopNF := getCFOPNFO(_cfop)

		if (!_lCfopPc) .and. (!_lCfopNF)
			AddLogErr(aErrorLog,  {Upper(cColorI+"Atenзгo! (CFOP)"),upper("CFOP NГO FAZ PARTE DA REGRA. GERAR MANUAL"+cColorF),.f.})
			lError := .t.
		endif

		//Valdemir Rabelo 11/03/2020
		If TYPE("oProduto:_xPed:TEXT") == "C"
			If Empty(cNumPC)

				cNumPC := PadL(oDet[nX]:_Prod:_xPed:TEXT,TamSX3("C7_NUM")[1],"0")
				if Empty(cNumPC) .or. (cNumPC=='000000')
					cColorI := "<b><FONT COLOR=RED>"
					cColorF := "</b></FONT>"
					cMessaErro += "Nao existe pedido no xml de nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
					AddLogErr(aErrorLog,  {upper(cColorI+"Pedido"),upper("Nao existe pedido no xml de nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+cColorF),.f.})
					lError := .t.
					//Loop
				Else
					If TYPE("oProduto:_nItemPed:TEXT") == "C"
						cITPEDC	:= StrZero(val(oDet[nX]:_Prod:_nItemPed:TEXT),4)
						if (Empty(cITPEDC) .or. cITPEDC="0000")
							cColorI := "<b><FONT COLOR=RED>"
							cColorF := "</b></FONT>"
							AddLogErr(aErrorLog,  {Upper("Item"),upper(cColorI+"Item do pedido de compra XML, nгo pode ser em branco ou '0000'"+cColorF),.f.})
							lError := .t.
						endif
					Else
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {Upper("Item"),upper(cColorI+"Item do pedido de compra XML, nгo consta no arquivo XML"+cColorF),.f.})
						lError := .t.
					EndIf
				endif
			Else
				cNumPC := PadL(oDet[nX]:_Prod:_xPed:TEXT,TamSX3("C7_NUM")[1],"0")
				if Empty(cNumPC) .or. (cNumPC=='000000')
					cColorI := "<b><FONT COLOR=RED>"
					cColorF := "</b></FONT>"
					cMessaErro += "Nao existe pedido no xml de nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
					AddLogErr(aErrorLog,  {Upper(cColorI+"Pedido"),upper("Nao existe pedido no xml de nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+cColorF),.f.})
					lError := .t.
				endif
				If TYPE("oProduto:_nItemPed") == "C"
					cITPEDC	:= StrZero(val(oDet[nX]:_Prod:_nItemPed:TEXT),4)       //StrZero(Val(oProduto:_nItemPed:TEXT),4)
					if (Empty(cITPEDC) .or. cITPEDC="0000")
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {Upper("Item"),upper(cColorI+"Item do pedido de compra XML, nгo pode ser em branco ou '0000'"+cColorF),.f.})
						lError := .t.
						Loop
					endif
				EndIf
			EndIf
		Else
			//if _cfop != "1902"
			if !_lCfopPc     // Conforme regra passada por Verфnica
				if !_lCfopNF
					cMessaErro += "tag pedido Compra/Ref.NFE nao encontrado no xml Nota Fiscal: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
					Conout(cMessaErro)
					if aScan(aErrorLog, { |X| alltrim(X[1])=="tag pedido" })==0
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {Upper("tag pedido"),upper(cColorI+" Pedido Compra nao encontrado no xml Nota Fiscal: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+cColorF),.f.})
					endif
					lError := .t.
					if lJOB
						Loop
					Endif
				endif
			endif
		Endif

		// Adicionado para pegar o valor do IPI para casos de substituiзгo (Manual) - Valdemir 01/06/2021
		nPIPI   := 0
		nValIPI := 0
		oImposto 	:= oDet[nX]
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
			EndIf
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
				nPIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf
		EndIf
		// ---------------------------------------------------

		dbSelectArea("SA5")
		DbSelectArea("SB1")
		If MV_PAR01 = 1

			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A5_CODPRF")[1])
			xProduto:=cProduto

			oAux := oDet[nX]
			cNCM :=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			Chkproc=.F.
			DbSelectArea("SA5")
			IF !getPesqA5(SA2->A2_COD,SA2->A2_LOJA,cProduto,"F")
				if !lJob
					If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. "+CR+"Digita Codigo de Substituicao?")
						PutMV("MV_PCNFE",lPcNfe)
						Return Nil
					Endif
					ST_aHeader(SA2->A2_CGC,SA2->A2_COD,SA2->A2_LOJA)
					DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(629),C(709) PIXEL OF _oDlg //>>Chamado 006873 - Everson Santana - 23.02.18

					// Cria as Groups do Sistema
					@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

					// Cria Componentes Padroes do Sistema
					@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca(nPIPI))
					@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
					oEdit1:SetFocus()
					//>>Chamado 006873 - Everson Santana - 23.02.18
					oGetDados1 := MsNewGetDados():New(100,005,280,330,nStyle   ,"AllWaysTrue" ,"AllWaysTrue","",/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg,_aHeader,_aCols)

					//oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+100,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nStyle   ,"AllWaysTrue" ,"AllWaysTrue","",/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg,_aHeader,_aCols)
					// MsNewGetDados():New(              040,        015,          255,        510, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , _aAlter,, 999, "AllwaysTrue", "", "AllwaysTrue" , _oDlg, _aHeader, _aCols)
					// 1,1,257,651
					//<<Chamado 006873
					ACTIVATE MSDIALOG _oDlg CENTERED
					If Chkproc!=.T.
						MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
						PutMV("MV_PCNFE",lPcNfe)
						lError := .t.
						Return Nil
					Else
						SA5->( dbSetOrder(1) )
						lAdic := SA5->( !dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cEdit1))
						RecLock("SA5",lAdic)
						if lAdic
							SA5->A5_FILIAL := xFilial("SA5")
							SA5->A5_FORNECE := SA2->A2_COD
							SA5->A5_LOJA 	:= SA2->A2_LOJA
							SA5->A5_NOMEFOR := SA2->A2_NOME
							SA5->A5_PRODUTO := cEdit1 //SB1->B1_COD
							SA5->A5_NOMPROD := oDet[nX]:_Prod:_xProd:TEXT
						Endif
						SA5->A5_CODPRF  := xProduto
						IF EMPTY(SA5->A5_SITU)
							SA5->A5_SITU := "C"
						ENDIF
						IF SA5->A5_TEMPLIM = 0.0
							SA5->A5_TEMPLIM :=  1
						ENDIF
						IF EMPTY(SA5->A5_FABREV)
							SA5->A5_FABREV := "F"
						ENDIF
						SA5->(MsUnlock())
					EndIf
				Else
					// ------ Valida tamanho - 19/01/2021 - Ticket: 20210111000540 ------
					if _lCfopPc

						// Verifico se o pedido compra do xml existe - Ticket: 20210111000540
						if !getVldPC(cNumPC, cITPEDC,,aErrorLog)
							Conout('Pedido Compra XML: '+cNumPC+' Item: '+cITPEDC+' Nгo encontrado Protheus')
							AddLogErr(aErrorLog,  {Upper("Atenзгo Item XML: "+cITPEDC), upper("Pedido Compra XML: "+cNumPC+" Item: "+cITPEDC+" Nгo encontrado Protheus"),.F.})
							lError := .t.
						endif

						if Len(aErrorLog) > 0
							cMsgFinal := " (PRE-NOTA NAO FOI GERADA)"
							cMSGERROR := ""
							cMSGERROR := MntIncon(aErrorLog, 'Inconsistencias XML Nota: '+AllTrim(aCabec[4,2])+cMsgFinal)    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
							if !lGerArq
								SZ9->(RecLock("SZ9",.F.))
								SZ9->Z9_ERRO := cMSGERROR
								SZ9->Z9_STATUS := "E"
								SZ9->( MsUnlock() )
							Endif
							Return
						endif

						// Tentar registrar a amarraзгo de forma automбtica - 19/01/2021 - Ticket: 20210111000540
						cTmpAlias := Alias()
						dbSelectArea("SA5")
						SA5->( dbSetOrder(1) )
						nREGSA5 := (getPesqA5(SA2->A2_COD,SA2->A2_LOJA,SC7->C7_PRODUTO,"P"))   // Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
						lAdic := (nREGSA5==0)
						IF !lAdic
							SA5->( dbGoto(nREGSA5) )
						ENDIF
						//lAdic := (Empty(SA5->A5_CODPRF) .AND. EMPTY(SA5->A5_CODPRF))
						if lAdic
							RecLock("SA5", lAdic)
							if lAdic
								SA5->A5_FILIAL  := xFilial("SA5")
								SA5->A5_FORNECE := SA2->A2_COD
								SA5->A5_LOJA 	:= SA2->A2_LOJA
								SA5->A5_NOMEFOR := SA2->A2_NOME
								SA5->A5_PRODUTO := SC7->C7_PRODUTO
								SA5->A5_NOMPROD := oDet[nX]:_Prod:_xProd:TEXT
								SA5->A5_CODPRF  := xProduto
								IF EMPTY(SA5->A5_SITU)
									SA5->A5_SITU := "C"
								ENDIF
								IF SA5->A5_TEMPLIM = 0.0
									SA5->A5_TEMPLIM :=  1
								ENDIF
								IF EMPTY(SA5->A5_FABREV)
									SA5->A5_FABREV := "F"
								ENDIF
							endif
							SA5->(MsUnlock())
						else
							if (Alltrim(xProduto) != Alltrim(SA5->A5_CODPRF))
								AddLogErr(aErrorLog, {Upper("PRODUTO X FORNECEDOR"), upper("Produto XML: "+Alltrim(xProduto))+" Protheus: "+Alltrim(SA5->A5_CODPRF)+" (SA5)",.F.})
								lError := .t.
							endif
						Endif

						dbSelectArea(cTmpAlias)
					Endif
					// -------------------------------
					//   cMessaErro += "tag pedido Compra nao encontrado no xml Nota Fiscal: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + CRLF
					//	Conout("Produto Cod.: "+cProduto+" Nao Encontrado. (SA5)")
					//   AddLogErr(aErrorLog,  {"Atenзгo", "Produto Cod.: "+cProduto+" Nao Encontrado. (SA5)",.F.})
				Endif
			endif
			if (cSitSA5=="S")
				AddLogErr(aErrorLog, {Upper("PRODUTO X FORNECEDOR"), upper("Produto: "+SA5->A5_PRODUTO+" ESTA BLOQUEADO. (SA5)"),.F.})
				lError := .t.
			endif

			SB1->(dbSetOrder(1) )
			lAchou := SB1->( dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
			if lAchou .and. (SB1->B1_MSBLQL == "1")
				AddLogErr(aErrorLog, {Upper("Atenзгo Produto Bloqueado"), upper("Produto: "+SB1->B1_COD+" ESTA BLOQUEADO. (SB1)"),.F.})
				lError := .t.
			Elseif (!lAchou) .and. Empty(SA5->A5_PRODUTO) .and. (!Empty(SA5->A5_CODPRF))
				// ------ Valida tamanho - 19/01/2021 - Ticket: 20210111000540 ------
				if _lCfopPc

					// Verifico se o pedido compra do xml existe - Ticket: 20210111000540
					if !getVldPC(cNumPC, cITPEDC,,aErrorLog)
						Conout('Pedido Compra XML: '+cNumPC+' Item: '+cITPEDC+' Nгo encontrado Protheus')
						AddLogErr(aErrorLog,  {Upper("Atenзгo Item XML: "+cITPEDC), upper("Pedido Compra XML: "+cNumPC+" Item: "+cITPEDC+" Nгo encontrado Protheus"),.F.})
						lError := .t.
					endif
					// Tentar registrar a amarraзгo de forma automбtica - 19/01/2021 - Ticket: 20210111000540
					if !lError
						SA5->( dbSetOrder(1) )
						nREGSA5 :=  getPesqA5(SA2->A2_COD,SA2->A2_LOJA,SC7->C7_PRODUTO,"P")   // Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
						lAdic := (nREGSA5==0)
						IF !lAdic
							SA5->( dbGoto(nREGSA5) )
						ENDIF
						if lAdic
							RecLock("SA5", lAdic)
							SA5->A5_FILIAL  := xFilial("SA5")
							SA5->A5_FORNECE := SA2->A2_COD
							SA5->A5_LOJA 	:= SA2->A2_LOJA
							SA5->A5_NOMEFOR := SA2->A2_NOME
							SA5->A5_PRODUTO := SC7->C7_PRODUTO
							SA5->A5_NOMPROD := oDet[nX]:_Prod:_xProd:TEXT
							IF EMPTY(SA5->A5_SITU)
								SA5->A5_SITU := "C"
							ENDIF
							IF SA5->A5_TEMPLIM = 0.0
								SA5->A5_TEMPLIM :=  1
							ENDIF
							IF EMPTY(SA5->A5_FABREV)
								SA5->A5_FABREV := "F"
							ENDIF
							SA5->A5_CODPRF  := xProduto
							SA5->(MsUnlock())
						else
							if (Alltrim(xProduto) != Alltrim(SA5->A5_CODPRF))
								AddLogErr(aErrorLog, {Upper("PRODUTO X FORNECEDOR"), upper("Produto XML: "+Alltrim(xProduto))+" Protheus: "+Alltrim(SA5->A5_CODPRF)+" (SA5)",.F.})
								lError := .t.
							endif
						endif
					Endif
				else
					if Empty(SA5->( A5_PRODUTO))
						Conout(Upper("PRODUTO X FORNECEDOR")+upper("Produto PROTHEUS")+" NГO INFORMADO. (SA5)")
						AddLogErr(aErrorLog, {Upper("PRODUTO X FORNECEDOR"), upper("Produto PROTHEUS")+" NГO INFORMADO. (SA5)",.F.})
						lError := .t.
					Endif
				endif
			Endif
		Else

			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSx3("A7_CODCLI")[1])
			xProduto:=cProduto
			oAux := oDet[nX]
			cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
			Chkproc=.F.

			//SA7->(DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			SA7->(DbSetOrder(1))
			If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
				if !lJob
					If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
						PutMV("MV_PCNFE",lPcNfe)
						Return Nil
					Endif
				Endif
				ST_aHeader(SA1->A1_CGC,SA1->A1_COD,SA1->A1_LOJA)
				if !lJob
					DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(629),C(709) PIXEL OF _oDlg //>>Chamado 006873 - Everson Santana - 23.02.18

					// Cria as Groups do Sistema
					@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

					// Cria Componentes Padroes do Sistema
					@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HRED PIXEL OF _oDlg
					@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HRED PIXEL OF _oDlg
					@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca(nPIPI))
					@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
					oEdit1:SetFocus()

					//>>Chamado 006873 - Everson Santana - 23.02.18
					oGetDados1 := MsNewGetDados():New(100,005,280,330,nStyle   ,"AllWaysTrue" ,"AllWaysTrue","",/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg,_aHeader,_aCols)

					//oGetDados1 := MsNewGetDados():New(aPosObj[1,1]+100,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nStyle,;
						//	"AllWaysTrue","AllWaysTrue","",/*acpos*/,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,_oDlg,_aHeader,_aCols)
					//<<Chamado 006873
					ACTIVATE MSDIALOG _oDlg CENTERED

					If Chkproc!=.T.
						Conout("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
						if !lJob
							MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
						endif
						PutMV("MV_PCNFE",lPcNfe)
						Return Nil
					Else
						If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cEdit1))
							RecLock("SA7",.f.)
						Else
							Reclock("SA7",.t.)
						Endif

						SA7->A7_FILIAL := xFilial("SA7")
						SA7->A7_CLIENTE := SA1->A1_COD
						SA7->A7_LOJA 	:= SA1->A1_LOJA
						SA7->A7_DESCCLI := oDet[nX]:_Prod:_xProd:TEXT
						SA7->A7_PRODUTO := cEdit1 //SB1->B1_COD
						SA7->A7_CODCLI  := xProduto
						SA7->(MsUnlock())

					EndIf
				Else
				  /*
					lAdic := SA7->(!dbSetOrder(1), dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cEdit1))
					Reclock("SA7",lAdic)
					if lAdic
						SA7->A7_FILIAL := xFilial("SA7")
						SA7->A7_CLIENTE := SA1->A1_COD
						SA7->A7_LOJA 	:= SA1->A1_LOJA
						SA7->A7_DESCCLI := oDet[nX]:_Prod:_xProd:TEXT
						SA7->A7_PRODUTO := SB1->B1_COD
					Endif
					SA7->A7_CODCLI  := xProduto
					SA7->(MsUnlock())
*/
					cMessaErro += "xml Nota Fiscal: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + CRLF
					Conout("Produto Cod.: "+cProduto+" Nao Encontrado. (SA7)")
					AddLogErr(aErrorLog, {upper("Produto Cod.: "+cProduto+" Nao Encontrado."), upper("Produto Cod.: "+cProduto+" Nao Encontrado. (SA7)"),.F.})
					lError := .t.
				Endif
			endif
			//oDet[Nx]:_PROD:_CPROD:TEXT	:= SA7->A7_PRODUTO
			IF SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
				if (SB1->B1_MSBLQL == "1")
					AddLogErr(aErrorLog, {Upper("Produto: "+SB1->B1_COD+" Bloqueado"), upper("Produto: "+SB1->B1_COD+" ESTA BLOQUEADO. (SB1)"),.F.})
					lError := .t.
				Endif
			ELSE
				Conout("Produto Cod.: "+SA7->A7_PRODUTO+" Nao Encontrado. (SB1)")
				AddLogErr(aErrorLog, {upper("Produto Cod.: "+SA7->A7_PRODUTO+" Nao Encontrado"), upper("Produto Cod.: "+SA7->A7_PRODUTO+" Nao Encontrado. (SB1)"),.F.})
				lError := .t.
			Endif
		Endif
		SB1->(dbSetOrder(1))
		/*
		IF Empty(ALLTRIM(SB1->B1_COD))
		   Loop 
		endif
		*/
		cProds += ALLTRIM(SB1->B1_COD)+'/'

		AAdd(aPedIte,{SB1->B1_COD, Val(oDet[nX]:_Prod:_qCom:TEXT), Round(Val(oDet[nX]:_Prod:_vProd:TEXT) / Val(oDet[nX]:_Prod:_qCom:TEXT),6), Val(oDet[nX]:_Prod:_vProd:TEXT)})

	Next nX

	cProds := Left(cProds,Len(cProds)-1)

	if !lJob
		aCampos := {}
		aCampos2:= {}

		AADD(aCampos,{'T9_OK'			,'#','@!','2','0'})
		AADD(aCampos,{'T9_PEDIDO'		,'Pedido','@!','6','0'})
		AADD(aCampos,{'T9_ITEM'			,'Item','@!','3','0'})
		AADD(aCampos,{'T9_PRODUTO'		,'PRODUTO','@!','15','0'})
		AADD(aCampos,{'T9_DESC'			,'Descriзгo','@!','40','0'})
		AADD(aCampos,{'T9_UM'			,'Un','@!','02','0'})
		AADD(aCampos,{'T9_QTDE'			,'Qtde','@EZ 999,999.9999','10','4'})
		AADD(aCampos,{'T9_UNIT'			,'Unitario','@EZ 9,999,999.99','12','2'})
		AADD(aCampos,{'T9_TOTAL'		,'Total','@EZ 99,999,999.99','14','2'})
		AADD(aCampos,{'T9_DTPRV'		,'Dt.Prev','','10','0'})
		AADD(aCampos,{'T9_ALMOX'		,'Alm','','2','0'})
		AADD(aCampos,{'T9_OBSERV'		,'Observaзгo','@!','30','0'})
		AADD(aCampos,{'T9_CCUSTO'		,'C.Custo','@!','6','0'})
		AADD(aCampos,{'T9_CONTA'		,'Conta','@!','20','0'})
		AADD(aCampos,{'T9_TES'			,'TES','999','3','0'})
		AADD(aCampos,{'T9_OP'			,'OP','@!','13','0'})
		AADD(aCampos,{'T9_FRETE'		,'Frete','@EZ 99,999,999.99','14','2'})
		AADD(aCampos,{'T9_VALIPI'		,'Vlr.IPI','@EZ 99,999,999.99','14','2'})
		AADD(aCampos,{'T9_ALQIPI'		,'Alq.IPI','@EZ 999.99','6','2'})
		AADD(aCampos,{'T9_VALICM'		,'Vlr.ICM','@EZ 99,999,999.99','14','2'})
		AADD(aCampos,{'T9_ALQICM'		,'Alq.ICM','@EZ 999.99','6','2'})

		AADD(aCampos2,{'T8_NOTA'		,'N.Fiscal','@!','9','0'})
		AADD(aCampos2,{'T8_SERIE'		,'Serie','@!','3','0'})
		AADD(aCampos2,{'T8_PRODUTO'		,'PRODUTO','@!','15','0'})
		AADD(aCampos2,{'T8_DESC'		,'Descriзгo','@!','40','0'})
		AADD(aCampos2,{'T8_UM'			,'Un','@!','02','0'})
		AADD(aCampos2,{'T8_QTDE'		,'Qtde','@EZ 999,999.9999','10','4'})
		AADD(aCampos2,{'T8_UNIT'		,'Unitario','@EZ 9,999,999.99','12','2'})
		AADD(aCampos2,{'T8_TOTAL'		,'Total','@EZ 99,999,999.99','14','2'})

		Cria_TC9()

		For ni := 1 To Len(aPedIte)
			RecLock("TC8",.t.)
			TC8->T8_NOTA 	:= Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)
			TC8->T8_SERIE 	:= AJUSTSTR(OIdent:_serie:TEXT)
			TC8->T8_PRODUTO := aPedIte[nI,1]
			TC8->T8_DESC	:= Posicione("SB1",1,xFilial("SB1")+aPedIte[nI,1],"B1_DESC")
			TC8->T8_UM		:= SB1->B1_UM
			TC8->T8_QTDE	:= aPedIte[nI,2]
			TC8->T8_UNIT	:= aPedIte[nI,3]
			TC8->T8_TOTAL	:= aPedIte[nI,4]
			TC8->(msUnlock())
		Next
		TC8->(dbGoTop())
	Endif

	Monta_TC9(lJob)

	if !lJob

		lOk := .f.
		lOut := .f.	//POLIESTER
		If !Empty(TC9->(RecCount())) .And. AllTrim(SA2->A2_CGC)<>"06048486000114" //Excluir Manaus

			DbSelectArea('TC9')
			@ 005,005 TO aSize[6]-100,aSize[5]-100 DIALOG oDlgPedidos TITLE "Pedidos de Compras Associados ao XML selecionado!"	//Poliester

			@ 006,005 TO 100,aSize[5]/2-50 BROWSE "TC9" MARK "T9_OK" FIELDS aCampos Object _oBrwPed

			@ 220,200 BUTTON "Marcar"         SIZE 40,15 ACTION MsAguarde({|| MarcarTudo()   },'Marcando Registros...')
			@ 220,250 BUTTON "Desmarcar"      SIZE 40,15 ACTION MsAguarde({|| DesMarcaTudo() },'Desmarcando Registros...')
			@ 220,300 BUTTON "Processar"	  SIZE 40,15 ACTION MsAguarde({|| lOk := .t. , Close(oDlgPedidos)},'Gerando e Enviando Arquivo...')
			@ 220,350 BUTTON "Sair"			  SIZE 40,15 ACTION MsAguarde({|| lOut := .t., Close(oDlgPedidos)},'Saindo do Sistema')	//POLIESTER
			//		@ 183,330 BUTTON "Sair"           SIZE 40,15 ACTION Close(oDlgPedidos)

			//		Processa({||  } ,"Selecionando Informacoes de Pedidos de Compras...")

			DbSelectArea('TC8')

			@ 100,005 TO 190,aSize[5]/2-50 BROWSE "TC8" FIELDS aCampos2 Object _oBrwPed2

			DbSelectArea('TC9')

			_oBrwPed:bMark := {|| Marcar()}

			ACTIVATE DIALOG oDlgPedidos CENTERED

		Else
			if (!_lCfopPc)
				if (!_lCfopNF)
					lError := .T.
				endif
			Endif
			/*
			Conout("Nгo existe pedidos de compras a ser carregado. Verifique os produtos da nota e suas amarraзхes")
			AddLogErr(aErrorLog, {"Atenзгo", upper("Nгo existe pedidos de compras a ser carregado. Verifique os produtos da nota e suas amarraзхes"),.F.})
			lError := .t.
			*/
		Endif

		//Verifica se o usuпїЅrio clicou no botпїЅo para sair, anteriormente se ele clicasse para sair o sistema ainda fazia a inserпїЅao dos dados, agora nпїЅo. - Poliester
		If lOut
			Return
		Endif
	else
		lOk := .t.
	Endif

	// Verifica se o usuario selecionou algum pedido de compra
	dbSelectArea("SC7")
	SC7->( dbSetOrder(2) )

	dbSelectArea("TC9")
	TC9->( dbGoTop() )

	if !lJob
		ProcRegua(Reccount())
	Endif

	lMarcou := .f.

	While TC9->(!Eof()) .And. lOk
		IncProc()
		If TC9->T9_OK  <> _cMarca
			dbSelectArea("TC9")
			TC9->(dbSkip(1));Loop
		Else
			lMarcou := .t.
			Exit
		Endif

		TC9->(dbSkip(1))
	Enddo
	lMsgProc := .F.
	oImposto := nil
	For nX := 1 To Len(oDet)

		oProduto    := oDet[nX]:_Prod				//Valdemir Rabelo 11/03/2020

		_cfop:=oDet[nX]:_Prod:_CFOP:TEXT

		If Left(Alltrim(_cfop),1)="5"
			_cfop:=Stuff(_cfop,1,1,"1")
		Elseif Left(Alltrim(_cfop),1)="6"
			_cfop:=Stuff(_cfop,1,1,"2")
		Elseif Left(Alltrim(_cfop),1)="7"
			_cfop:=Stuff(_cfop,1,1,"3")
		Endif

		_lCfopPc := getCFOPCPC(_cfop)
		_lCfopNF := getCFOPNFO(_cfop)

		//Valdemir Rabelo 11/03/2020
		//if _cfop != '1902'
		if _lCfopPc     // Conforme regra passada por Verфnica
			cNumPC  := ""
			cITPEDC := ""
			If TYPE("oProduto:_xPed:TEXT") == "C"
				If Empty(cNumPC)
					cNumPC := PADL(oProduto:_xPed:TEXT,TamSX3('C7_NUM')[1],"0")
					if Empty(cNumPC) .or. (cNumPC=='000000')
						if lJob
							cMessaErro += "Nao existe pedido no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
							AddLogErr(aErrorLog, {Upper("Pedido Nao existe no xml da nota"),upper("Nao existe pedido no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)),.f.})
							lError := .t.
							//Loop
						endif
					Endif
				Else
					cNumPC := PADL(oDet[nX]:_Prod:_xPed:Text,TamSX3('C7_NUM')[1],"0")   // oProduto:_xPed:TEXT
				EndIf

			Else
				//cMessaErro += "<TAG> Pedido de Compra nao existe no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
				//_cMsg := "<TAG> Pedido de Compra nao existe no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "
				//AddLogErr(aErrorLog, {"Atenзгo!",upper(cColorI+_cMsg+cColorF),.f.})
				if lJOB
					lError := .t.
				Endif
			Endif
			If TYPE("oProduto:_nItemPed:TEXT") == "C"
				cITPEDC := StrZero(val(oDet[nX]:_Prod:_nItemPed:TEXT), TamSX3('C7_ITEM')[1])         //oProduto:_nItemPed:TEXT
				if (Empty(cITPEDC) .or. cITPEDC="0000")
					AddLogErr(aErrorLog, {upper("Item em branco"),upper(cColorI+"Item do pedido de compra XML, nгo pode ser em branco ou '0000'"+cColorF),.f.})
					lError := .t.
				endif
				if Len(alltrim(cITPEDC)) > 4
					AddLogErr(aErrorLog, {upper("Item superior a 4"),upper(cColorI+"Item: "+cITPEDC+" pedido de compra XML com quantidade caracteres superior a 4"+cColorF),.f.})
					lError := .t.
				elseif Len(alltrim(cITPEDC)) < 4 .and. Len(alltrim(cITPEDC)) >= 1
					cITPEDC := PadL(cITPEDC,4,"0")
				endif
			Else
				cMessaErro += "<TAG> Item do Pedido de Compra nao existe no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "+CRLF
				_cMsg := "<TAG> Item do Pedido de Compra nao existe no xml da nota: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9) + " "
				AddLogErr(aErrorLog, {upper("<TAG> Item do Pedido"),upper(cColorI+_cMsg+cColorF),.f.})
				lError := .t.
			EndIf
		Endif

		oImposto 	:= oDet[nX]						// Valdemir Rabelo 10/03/2020

		// Validacao: Produto Existe no SB1 ?
		// Se nпїЅo existir, abrir janela c/ codigo da NF e descricao para digitacao do cod. substituicao.
		// Deixar opпїЅпїЅo para cancelar o processamento //  Descricao: oDet[nX]:_Prod:_xProd:TEXT

		aLinha := {}
		cProduto:=PADR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),TamSX3( "A5_CODPRF" )[1])
		xProduto:=cProduto

		oAux := oDet[nX]
		cNCM:=IIF(Type("oAux:_Prod:_NCM")=="U",space(12),oAux:_Prod:_NCM:TEXT)
		Chkproc=.F.

		If MV_PAR01 == 1

			// Verifico se o pedido compra do xml existe - Ticket: 20210111000540
			if _lCfopPc  
				if !getVldPC(cNumPC, cITPEDC,,aErrorLog)
					Conout('Pedido Compra XML: '+cNumPC+' Item: '+cITPEDC+' Nгo encontrado Protheus')
					AddLogErr(aErrorLog,  {upper("PED.: "+cNumPC+" ITEM: "+cITPEDC+" Nгo Encontrado"), upper("Pedido Compra XML: "+cNumPC+" Item: "+cITPEDC+" Nгo encontrado Protheus"),.F.})
					lError := .t.
				endif
			Endif

			if (!Empty(cNumPC) .and. (cNumPC != '000000')) .and. (!Empty(cITPEDC) .and. (cITPEDC != '0000'))
				SA5->(DbOrderNickName("FORPROD"))                             // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
				lAdic := (!getPesqA5(SA2->A2_COD,SA2->A2_LOJA,cProduto,"F"))  //(!SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto)))
				lAdic := (Empty(SA5->A5_PRODUTO) .AND. EMPTY(SA5->A5_CODPRF))
				if lAdic
					SA5->( dbSetOrder(1) )
					nREGSA5 :=  getPesqA5(SA2->A2_COD,SA2->A2_LOJA,SC7->C7_PRODUTO,"P")       // Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
					lAdic := (nREGSA5==0)
					IF !lAdic
						SA5->( dbGoto(nREGSA5) )
					ENDIF
				endif
				if lJob
					SA5->( dbSetOrder(1) )
					if lAdic
						RecLock("SA5", lAdic)
						SA5->A5_FILIAL  := xFilial("SA5")
						SA5->A5_FORNECE := SA2->A2_COD
						SA5->A5_LOJA 	:= SA2->A2_LOJA
						SA5->A5_NOMEFOR := SA2->A2_NOME
						SA5->A5_PRODUTO := SC7->C7_PRODUTO
						SA5->A5_NOMPROD := oDet[nX]:_Prod:_xProd:TEXT
						SA5->A5_SITU    := "C"
						SA5->A5_TEMPLIM :=  1
						SA5->A5_FABREV  := "F"
						SA5->A5_CODPRF  := xProduto
						SA5->(MsUnlock())
					else
						if (Alltrim(xProduto) != Alltrim(SA5->A5_CODPRF))
							AddLogErr(aErrorLog, {Upper("PRODUTO X FORNECEDOR"), upper("Produto XML: "+Alltrim(xProduto))+" Protheus: "+Alltrim(SA5->A5_CODPRF)+" (SA5)",.F.})
							lError := .t.
						endif
					endif
					SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
				else
					if lAdic
						AddLogErr(aErrorLog,  {upper("Produto: "+Alltrim(cProduto)+" Nгo Encontrado em Amarraзгo Produto x Fornecedor"), upper("Produto: "+Alltrim(cProduto)+" Fornecedor: "+SA2->A2_COD+" Loja: "+SA2->A2_LOJA),.F.})
						lError := .t.
						lVld1  := .T.
					else
						SB1->(dbSetOrder(1) , dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
					endif
				Endif
			Else
				SA5->(DbOrderNickName("FORPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
				lAdic := (!getPesqA5(SA2->A2_COD,SA2->A2_LOJA,cProduto,"F"))  //(!SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto)))
				if lAdic
					if _lCfopPc
						SC7->( dbSetOrder(14) )
						lPC := (!Empty(cNumPC+cITPEDC)) .and. SC7->( dbSeek(xFilial('SC7')+cNumPC+cITPEDC) )
						SA5->( dbSetOrder(1) )
						if lPC
							nREGSA5 :=  getPesqA5(SA2->A2_COD,SA2->A2_LOJA,SC7->C7_PRODUTO,"P")   // Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
							lAdic := (nREGSA5==0)
							IF !lAdic
								SA5->( dbGoto(nREGSA5) )
							ENDIF
						else
							if Empty(cNumPC)    // Valdemir Rabelo 02/08/2021
								AddLogErr(aErrorLog,  {Upper("tag pedido ITEM: "+StrZero(nX,3)),upper(cColorI+" Pedido Compra nao encontrado no xml Nota Fiscal: "+Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)+cColorF),.f.})
								lError := .t.
							endif
						Endif
					Endif
					SB1->( dbSetOrder(1) )
					SB1->( dbSeek(xFilial("SB1")+SA5->A5_PRODUTO) )
				endif
				if !lAdic                 // Se for falso й que existe
					SB1->( dbSetOrder(1) )
					if SB1->( dbSeek(xFilial("SB1")+SA5->A5_PRODUTO) )
						if (SB1->B1_MSBLQL == "1")
							AddLogErr(aErrorLog, {upper("Produto: "+SB1->B1_COD+" Bloqueado"), upper("Produto: "+SB1->B1_COD+" ESTA BLOQUEADO. (SB1)"),.F.})
							lError := .t.
						Endif
					else
						AddLogErr(aErrorLog, {upper("Produto: "+SA5->A5_PRODUTO+" nгo encontrado"), upper("Produto: "+SA5->A5_PRODUTO+" NГO ENCONTRADO. (SB1)"),.F.})
						lError := .t.
					endif
				else
					if !Empty(cNumPC)
						AddLogErr(aErrorLog,  {upper("Produto: "+Alltrim(cProduto)+" nгo encontrado na Amarraзгo Produto x Fornecedor"), upper("Produto: "+Alltrim(cProduto)+" Fornecedor: "+SA2->A2_COD+" Loja: "+SA2->A2_LOJA),.F.})
					endif
					lError := .t.
					lVld1  := .T.
				Endif
			Endif
		Else
			SA7->(DbSetOrder(1))
			if !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
				AddLogErr(aErrorLog,  {"Amarraзгo Produto x Cliente Nгo Encontrado",upper("Produto: "+Alltrim(cProduto)+" Cliente: "+SA1->A1_COD+" Loja: "+SA1->A1_LOJA),.f.})
			else
				SB1->(dbSetOrder(1))
				if sb1->(dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
					if  (SB1->B1_MSBLQL == "1")
						AddLogErr(aErrorLog, {upper("Produto: "+SB1->B1_COD+" BLOQUEADO"), upper("Produto: "+SB1->B1_COD+" ESTA BLOQUEADO. (SB1)"),.F.})
						lError := .t.
					Endif
				else
					AddLogErr(aErrorLog, {upper("Produto: "+SA7->A7_PRODUTO+" NГO ENCONTRADO"), upper("Produto: "+SA7->A7_PRODUTO+" NГO ENCONTRADO. (SB1)"),.F.})
					lError := .t.
				endif
			endif
		Endif

		aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil}) //Emerson Holanda
		// giovani zago desabilitei pois esta pegando a quantidade tributado 23/08/17
		/*
		If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0
		aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qTrib:TEXT),Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6),Nil,Nil})
		Else
		aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qCom:TEXT),Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6),Nil,Nil})
		Endif
		*/

		//aAdd(aLinha,{"D1_UM",  UPPER(oDet[nX]:_Prod:_uCom:TEXT), Nil, Nil})
		nQdeXML  := 0
		nUnitXML := 0

		if lJOB
			aadd(aLinha,{"D1_PEDIDO",cNumPC, Nil, Nil})
			aadd(aLinha,{"D1_ITEMPC",cITPEDC, Nil, Nil})
		Else
			aadd(aLinha,{"D1_PEDIDO",'',.f.,Nil})
			aadd(aLinha,{"D1_ITEMPC",'',.f.,Nil})
		EndIf

		cUM := UPPER(oDet[nX]:_Prod:_uCom:TEXT)
		if ((cUM == 'MIL') .OR. (cUM == 'MI') .OR. (cUM == 'TON'))
			nQdeXML  := Val(oDet[nX]:_Prod:_qCom:TEXT)*1000
			nUnitXML := Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/nQdeXML,6)
		else
			nQdeXML  := Val(oDet[nX]:_Prod:_qCom:TEXT)
			nUnitXML := Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),6)
		endif

		aadd(aLinha,{"D1_QUANT", nQdeXML , Nil, Nil})
		aadd(aLinha,{"D1_VUNIT", nUnitXML, Nil, Nil})
		aadd(aLinha,{"D1_TOTAL",Val(oDet[nX]:_Prod:_vProd:TEXT),Nil,Nil})

		//	      aadd(aLinha,{"D1_CF",_cfop,Nil,Nil})
		oAux := oDet[nX]
		If Type("oAux:_Prod:_vDesc") <> "U"
			aadd(aLinha,{"D1_VALDESC",Val(oDet[nX]:_Prod:_vDesc:TEXT),Nil,Nil})
		Else
			aadd(aLinha,{"D1_VALDESC",0,Nil,Nil})
		Endif

		Do Case
		Case Type("oAux:_Imposto:_ICMS:_ICMS00") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS00
		Case Type("oAux:_Imposto:_ICMS:_ICMS10") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS10
		Case Type("oAux:_Imposto:_ICMS:_ICMS20") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS20
		Case Type("oAux:_Imposto:_ICMS:_ICMS30") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS30
		Case Type("oAux:_Imposto:_ICMS:_ICMS40") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS40
		Case Type("oAux:_Imposto:_ICMS:_ICMS51") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS51
		Case Type("oAux:_Imposto:_ICMS:_ICMS60") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS60
		Case Type("oAux:_Imposto:_ICMS:_ICMS70") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS70
		Case Type("oAux:_Imposto:_ICMS:_ICMS90") <> "U"
			oICM:=oAux:_Imposto:_ICMS:_ICMS90
		EndCase
		CST_Aux := ""
		If (Type("oICM:_orig:TEXT") <> "U") .And. (Type("oICM:_CST:TEXT") <> "U")
			CST_Aux:=Alltrim(AJUSTSTR(oICM:_orig:TEXT))+Alltrim(AJUSTSTR(oICM:_CST:TEXT))
			aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
		ELSE
			aadd(aLinha,{"D1_CLASFIS",'',Nil,Nil})
		Endif

		aadd(aLinha,{"D1_OP"	,'',.f.,Nil})
		aadd(aLinha,{"D1_CC"	,'',.f.,Nil})
		aadd(aLinha,{"D1_UM"	,SB1->B1_UM,   .f.,Nil})
		aadd(aLinha,{"D1_CONTA"	,SB1->B1_CONTA,.f.,Nil})
		aadd(aLinha,{"D1_XFATEC",IIf(!Empty(_cFatec),_cFatec,""),Nil,Nil})
		aadd(aLinha,{"D1_VALFRE",0,.f.,Nil})

		//		If cTipo=='D' // Nota Fiscal de Devolucao
		//			aadd(aLinha,{"D1_NFORI",'',Nil,Nil})
		//			aadd(aLinha,{"D1_ITEMORI",'',Nil,Nil})
		//			aadd(aLinha,{"D1_SERIORI",'',Nil,Nil})
		//		Endif

		//	aadd(aLinha,{"D1_XOPER","01",Nil,Nil})
		//	aadd(aLinha,{"D1_TESACLA",U_XTESINTE(If(cTipo$"DB","C","F"),"01",SB1->B1_COD,IIF(MV_PAR01==1,SA2->A2_COD,SA1->A1_COD),IIF(MV_PAR01==1,SA2->A2_LOJA,SA1->A1_LOJA)),Nil,Nil})
		aadd(aItens, aLinha)

		// ------------------------------------------------------------------ Localiza Valor ICMS--------------------------------------------------- Valdemir Rabelo 10/03/2020
		If Type("oImposto:_Imposto") <> "U"
			nVALIPI := 0
			nVALICM := 0
			nPICM   := 0
			If Type("oImposto:_Imposto:_ICMS") <> "U"
				nLenSit := Len(aSitTrib)
				For nY := 1 to nLenSit
					nPrivate2 := nY
					If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT") <> "U"
						if Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_PICMS:TEXT") <> "U"
							nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_PICMS:TEXT"))
						endif
						If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT") <> "U"
							nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT"))
							nValICM := 0
							if type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMS:TEXT") <> "U"   // Adicionado 15/01/2021 - Valdemir Rabelo
								nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMS:TEXT"))
							endif
							if Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_PICMS:TEXT") <> "U"
								nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_PICMS:TEXT"))
							endif
						ElseIf Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_MOTDESICMS") <> "U" .And. Type("oImposto:_PROD:_VDESC:TEXT") <> "U"
							If oNfe:_NFEPROC:_VERSAO:TEXT >= "3.10" .and. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_CST:TEXT") <> "40"
								If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_CST:TEXT") == "30"
									nValICM  := 0
								Else
									nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMSDESON:TEXT"))
								EndIf
							ElseIf &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_CST:TEXT") <> "40"
								If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_CST:TEXT") == "30"
									nValICM  := 0
								Else
									nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMS:TEXT"))
								EndIf
							EndIf
						Endif

						cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_ORIG:TEXT")
						cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_CST:TEXT")
					else
						if (nValICM==0) .and. (cUfSM0=="AM")			// Valdemir Rabelo - 09/04/2020
							if Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMSDeson:TEXT") <> "U"
								nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_motDesICMS:TEXT"))
								nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_vICMSDeson:TEXT"))
							endif
						endif
					Endif

				Next
			Endif

			nPIPI := 0
			If Type("oImposto:_Imposto:_IPI")<>"U"
				If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
					nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
				EndIf
				If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
					nPIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
				EndIf
			EndIf
		Endif

		aadd(aLinha,{"D1_VALIPI", nVALIPI,.f.,Nil})
		aadd(aLinha,{"D1_VALICM", nVALICM,.f.,Nil})
		aadd(aLinha,{"NCM", 	  cNCM,	  .f.,Nil})
		aadd(aLinha,{"IPI", 	  nPIPI,  .f.,nil})
		aadd(aLinha,{"ICM", 	  nPICM,  .f.,nil})
		aadd(aLinha,{"CFOP", 	  _cfop,  .f.,nil})
		aAdd(aValidaN, aLinha)
		// ------------------------------------------------------------------------------------
		cNumPC := ""
		cITPEDC:= ""

	Next nX
/*
	if Len(aErrorLog) > 0
		cMsgFinal := " (PRE-NOTA NAO FOI GERADA)"
		cMSGERROR := ""
		cMSGERROR := MntIncon(aErrorLog, 'Inconsistencias XML Nota: '+AllTrim(aCabec[4,2])+cMsgFinal)    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
		if !lGerArq
			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_ERRO := cMSGERROR
			SZ9->Z9_STATUS := "E"
			MsUnlock()
			//Return
		Endif
	endif
*/
	If lMarcou

		dbSelectArea("TC9")
		TC9->( dbGoTop() )
		if !lJOB
			ProcRegua(Reccount())
		Endif
		//lError := .F.
		While TC9->( !Eof() ) .And. lOk
			IncProc()
			If TC9->T9_OK  <> _cMarca
				dbSelectArea("TC9")
				TC9->(dbSkip(1));Loop
			Endif

			For nItem := 1 To Len(aItens)
				nQtdMin := 0
				nQtdMax := 0
				If AllTrim(aItens[nItem,gPos(aItens[nItem],"D1_COD"),2]) == AllTrim(TC9->T9_PRODUTO) .And. Empty(aItens[nItem,gPos(aItens[nItem],"D1_PEDIDO"),2])
					If !Empty(TC9->T9_QTDE)
						if Empty(aItens[nItem,gPos(aItens[nItem],"D1_ITEMPC"),2])
							aItens[nItem,gPos(aItens[nItem],"D1_PEDIDO"),2] :=  TC9->T9_PEDIDO
							aItens[nItem,gPos(aItens[nItem],"D1_ITEMPC"),2] :=  TC9->T9_ITEM
						Endif
						aItens[nItem,gPos(aItens[nItem],"D1_OP"),2] 	:= TC9->T9_OP
						aItens[nItem,gPos(aItens[nItem],"D1_CC"),2] 	:= TC9->T9_CCUSTO
						aItens[nItem,gPos(aItens[nItem],"D1_CONTA"),2] 	:= TC9->T9_CONTA
						aItens[nItem,gPos(aItens[nItem],"D1_VALFRE"),2]	:= TC9->T9_FRETE

						dbselectarea("SC7")
						dbsetorder(14)

						if (SC7->( FieldPos("C7_XCST") ) > 0) .and. !empty(aItens[nItem,gPos(aItens[nItem],"D1_CLASFIS"),2])
							SC7->( dbseek(xFilial("SC7")+TC9->T9_PEDIDO+TC9->T9_ITEM) )
							if SC7->( found() )
								if !lError
									reclock("SC7",.F.)
									SC7->C7_XCST := aItens[nItem,gPos(aItens[nItem],"D1_CLASFIS"),2]
									SC7->(MsUnlock())
								Endif
							endif
						endif

						If RecLock('TC9',.f.)
							If (TC9->T9_QTDE-aItens[nItem,gPos(aItens[nItem],"D1_VUNIT"),2]) < 0
								TC9->T9_QTDE := 0
							Else
								TC9->T9_QTDE := (TC9->T9_QTDE - aItens[nItem,gPos(aItens[nItem],"D1_VUNIT"),2])
							Endif
							TC9->(MsUnlock())
						Endif
						exit                   // Adicionado devido a repetiзгo do pedido
					Endif
				Endif
			Next

			TC9->(dbSkip(1))
		Enddo
		if !lJob
			TC8->(dbCloseArea())
			oTable:Delete("TC8") //adicionado 11/05/23
		Endif
		TC9->(dbCloseArea())
		oTable:Delete("TC9") //adicionado 11/05/23
	Endif

	If Len(aItens) > 0

		lMsErroAuto := .f.
		lMsHelpAuto := .f.

		SB1->( dbSetOrder(1) )
		SA2->( dbSetOrder(1) )

		nModulo := 2  //COMPRAS

		dbselectarea("SD1")
		dbsetorder(1)
		dbselectarea("SF1")
		dbsetorder(1)

		aGrvPcNF := {}

		if GetMv("GRVPRENT1",,.T.)
			if (lVld1 := !VldGrvNF(aCabec,aItens,@aGrvPcNF,@aErrorLog,lJob,lGerArq))
				Return
			Endif
		endIf

		if lVld1
			_cMsg := "Existem problemas graves e nгo poderб ser gerado a pre nota."
			Conout(_cMsg)
			if !lJob
				apMsgInfo(_cMsg,"Atenзгo!")
			endif
			return
		endif

		//Begin Transaction
		nREG := SZ9->( RECNO() )
		lMsErroAuto := .F.

		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)

		IF lMsErroAuto
			if ("PROCESSADOS\" $ Upper(cArquivo))
				xFile := STRTRAN(Upper(cArquivo),"arquivos\XMLNFE\PROCESSADOS\", "XMLNFE\ERRO\")
			ELSE
				xFile := STRTRAN(Upper(cArquivo),"arquivos\XMLNFE\", "XMLNFE\ERRO\")
			ENDIF

			COPY FILE &cArquivo TO &xFile

			FErase(cArquivo)

			if !lJob
				MSGALERT("ERRO NO PROCESSO")
				MostraErro()
			else
				Conout("Erro no Processo. Verifique o arquivo: \PROCESSADOS\"+cArquivo)
				cMSGERROR := MostraErro("\")
			endif
			DisarmTransaction()

			// Valdemir Rabelo 18/12/2020 - Conforme reuniгo ficou alinhado que serб
			// removido o WF e gravado em campo as mensagens de inconsistкncia
			if !lGerArq
				if Len(cMSGERROR) > 0
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_ERRO   := SZ9->Z9_ERRO +" "+cMSGERROR
					SZ9->Z9_STATUS := "E"
					SZ9->( MsUnlock() )
				Endif
			Endif

		Else
			if !lGerArq
				nRecSZ9 := SZ9->( Recno() )
			Endif
			If SF1->F1_DOC == Right("000000000"+AJUSTSTR(OIdent:_nNF:TEXT),9)
				ConfirmSX8()
				// Atualiza SD1 - Valdemir Rabelo 01/10/2021
				if Len(aREFNF) > 0
				   SD1->( dbSetOrder(1) )
				   SD1->( dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE) ) )
				   While SD1->( !Eof() )
				      nPos := aScan(aREFNF, {|X| Alltrim(X[1])==ALLTRIM(SD1->D1_COD)}) // Localizo a linha
					  if nPos > 0
							RecLock("SD1",.F.)
							SD1->D1_NFORI   := aREFNF[nPos][4]
							SD1->D1_SERIORI := aREFNF[nPos][5]
							MsUnlock()
					  endif
				      SD1->( dbSkip() )
				   EndDo 
				endif 

				if !("PROCESSADOS\" $ Upper(cArquivo))
					xFile := STRTRAN(Upper(cArquivo),"arquivos\XMLNFE\", "XMLNFE\PROCESSADOS\")

					COPY FILE &cArquivo TO &xFile

					FErase(cArquivo)
				endif
				Conout(Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Pre Nota Gerada Com Sucesso!")
				if !lJob
					MSGALERT(Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Pre Nota Gerada Com Sucesso!")
				endif
				if !lGerArq
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_STATUS	:= "2"
					SZ9->Z9_DOC		:= SF1->F1_DOC
					SZ9->Z9_SERIE	:= SF1->F1_SERIE
					if SZ9->( FieldPos('Z9_GEROU')) > 0     // Valdemir Rabelo 15/01/2021 - 20210111000540
						SZ9->Z9_GEROU := if(lJOB, 'AUT','MAN')
					Endif
					SZ9->Z9_ERRO   := ""
					SZ9->(MsUnLock())

					SZ9->( dbGotop() )
					SZ9->( dbGoto(nRecSZ9) )
				Endif
				cMailResp := SuperGetMV("ST_EMLPRNF",.F.,'valdemir.rabelo@sigamat.com.br')
				PswOrder(1)
				PswSeek(__cUserId,.T.)
				aInfo := PswRet(1)
				cAssunto := 'Geracao da pre nota '+Alltrim(aCabec[3,2])+' Serie '+Alltrim(aCabec[4,2])
				cTexto   := 'A pre nota '+Alltrim(aCabec[3,2])+' Serie: '+Alltrim(aCabec[4,2]) +' do tipo '+Alltrim(aCabec[1,2]) + ' do fornecedor '+ Alltrim(aCabec[6,2])+' loja ' + Alltrim(aCabec[7,2]) + ' foi gerada com sucesso. Por gentileza Classifique a Pre-Nota na rotina DOC.ENTRADA.'
				//				cTexto   := 'A pre nota '+Alltrim(aCabec[3,2])+' Serie: '+Alltrim(aCabec[4,2]) +' do tipo '+Alltrim(aCabec[1,2]) + ' do fornecedor '+ Alltrim(aCabec[6,2])+' loja ' + Alltrim(aCabec[7,2]) + ' foi gerada com sucesso pelo usuario '+ aInfo[1,4] + ' favor classificar a pre nota em nota'	//POLIESTER
				cAuxMail := alltrim(UsrRetMail(RetCodUsr()))
				if empty(cAuxMail)
					cAuxMail := alltrim(UsrRetMail("000000"))
				endif
				cPara    := cAuxMail+","+cMailResp
				cCC      := ''
				cArquivo := ''
				if cEmpAnt <> '03'
					U_EnvMail(cAssunto,cTexto,cPara,cCC,cArquivo) //para que seja enviado um arquivo em anexo o arquivo deve estar dentro da pasta protheus_data
				endif

			Else
				MSGALERT(Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Pre Nota Nao Gerada - Tente Novamente !")
			EndIf
			SZ9->( dbGotop() )
			SZ9->( dbGoto(nREG) )

		EndIf

		//End Transaction

	Endif

	PutMV("MV_PCNFE",lPcNfe)

Return



Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
	//пїЅTratamento para tema "Flat"пїЅ
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

Static Function ValProd()
	_DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
	_NCMdigit=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")
Return(ExistCpo("SB1"))

Static Function Troca(pnIPI)
	Local lBloqueado

	Chkproc=.T.
	cProduto=cEdit1
	if SB1->( dbSeek(xFilial('SB1')+cProduto) )
		If (SB1->B1_POSIPI <> cNCM) .and. !Empty(cNCM) .and. cNCM != '00000000' //Emerson Holanda alterar o ncm se houver discrepancia
			StPutNCM(cNCM,,,.F., pnIPI)    // Valdemir Rabelo 29/03/2021
		Endif
	Else
		MsgInfo("Produto nгo encontrado","Atenзгo!")
		REturn .F.
	Endif

	_oDlg:End()
Return(.t.)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅChk_File  пїЅAutor  пїЅ                    пїЅ Data пїЅ             пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅChamado pelo grupo de perguntas EESTR1			          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅVerifica se o arquivo em &cVar_MV (MV_PAR06..NN) existe.    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅSe nпїЅo existir abre janela de busca e atribui valor a       пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅvariavel Retorna .T.										  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅSe usuпїЅrio cancelar retorna .F.							  пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametrosпїЅTexto da Janela		                                      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅVariavel entre aspas.                                       пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅEx.: Chk_File("Arquivo Destino","mv_par06")                 пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅVerificaSeExiste? Logico - Verifica se arquivo existe ou    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅnao - Indicado para utilizar quando o arquivo eh novo.      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅEx. Arqs. Saida.                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function xChk_F(cTxt, cVar_MV, lChkExiste)
	Local lExiste := File(&cVar_MV)
	Local cTipo := "Arquivos XML   (*.XML)  | *.XML | Todos os Arquivos (*.*)    | *.* "
	Local cArquivo := ""

	//Verifica se arquivo nпїЅo existe
	If lExiste == .F. .or. !lChkExiste
		cArquivo := cGetFile( cTipo,OemToAnsi(cTxt))
		If !Empty(cArquivo)
			lExiste := .T.
			&cVar_Mv := cArquivo
		Endif
	Endif
Return (lExiste .or. !lChkExiste)

	******************************************
Static Function MarcarTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := _cMarca
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
Return(.T.)

	******************************************
Static Function DesmarcaTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := ThisMark()
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
Return(.T.)

	******************************************
Static Function Marcar()
	DbSelectArea('TC9')
	RecLock('TC9',.F.)
	If Empty(TC9->T9_OK)
		TC9->T9_OK := _cMarca
	Endif
	MsUnlock()
	SysRefresh()
Return(.T.)

	******************************************************
Static FUNCTION Cria_TC9()
Local oTable  //adicionado 11/05/23
Local cAlias  //adicionado 11/05/23
Local cAlias2 //adicionado 11/05/23

	If Select("TC9") <> 0
		TC9->(dbCloseArea())
		oTable:Delete("TC9") //adicionado 11/05/23
	Endif
	If Select("TC8") <> 0
		TC8->(dbCloseArea())
		oTable:Delete("TC8") //adicionado 11/05/23
	Endif

	oTable := FWTemporaryTable():New("TC9") //adicionado 11/05/23

	aFields   := {}
	AADD(aFields,{"T9_OK"     ,"C",02,0})
	AADD(aFields,{"T9_PEDIDO" ,"C",06,0})
	AADD(aFields,{"T9_ITEM"   ,"C",04,0})
	AADD(aFields,{"T9_PRODUTO","C",15,0})
	AADD(aFields,{"T9_DESC"   ,"C",40,0})
	AADD(aFields,{"T9_UM"     ,"C",02,0})
	AADD(aFields,{"T9_QTDE"   ,"N",9,0})
	AADD(aFields,{"T9_UNIT"   ,"N",12,2})
	AADD(aFields,{"T9_TOTAL"  ,"N",14,2})
	AADD(aFields,{"T9_DTPRV"  ,"D",08,0})
	AADD(aFields,{"T9_ALMOX"  ,"C",02,0})
	AADD(aFields,{"T9_OBSERV" ,"C",30,0})
	AADD(aFields,{"T9_CCUSTO" ,"C",06,0})
	AADD(aFields,{"T9_CONTA"  ,"C",20,0})
	AADD(aFields,{"T9_TES"    ,"C",3,0})
	AADD(aFields,{"T9_OP"     ,"C",13,0})
	AADD(aFields,{"T9_FRETE"  ,"N",14,2})
	AADD(aFields,{"T9_VALIPI" ,"N",14,2})
	AADD(aFields,{"T9_ALQIPI" ,"N", 6,2})
	AADD(aFields,{"T9_VALICM" ,"N",14,2})
	AADD(aFields,{"T9_ALQICM" ,"N", 6,2})
	AADD(aFields,{"T9_REG" ,"N",10,0})
	//cArq:=Criatrab(aFields,.T.)			// Funзгo CriaTrab() descontinuada - 11/05/23
	oTable:SetFields(aFields)				//adicionado 11/05/23
	oTable:Create()							//adicionado 11/05/23
	cAlias := oTable:GetAlias()				//adicionado 11/05/23
	cArq   := oTable:GetRealName()			//adicionado 11/05/23
	//DBUSEAREA(.t.,"TOPCONN",cArq,cAlias)	//Alterado 11/05/23 - anterior: DBUSEAREA(.t.,,cArq,"TC9")

	oTable := FWTemporaryTable():New("TC8") //adicionado 11/05/23

	aFields2   := {}
	AADD(aFields2,{"T8_NOTA" ,"C",09,0})
	AADD(aFields2,{"T8_SERIE"   ,"C",03,0})
	AADD(aFields2,{"T8_PRODUTO","C",15,0})
	AADD(aFields2,{"T8_DESC"   ,"C",40,0})
	AADD(aFields2,{"T8_UM"     ,"C",02,0})
	AADD(aFields2,{"T8_QTDE"   ,"N",6,0})
	AADD(aFields2,{"T8_UNIT"   ,"N",12,2})
	AADD(aFields2,{"T8_TOTAL"  ,"N",14,2})
	//cArq2:=Criatrab(aFields2,.T.)			// Funзгo CriaTrab() descontinuada - 11/05/23
	oTable:SetFields(aFields2)				//adicionado 11/05/23
	oTable:Create()							//adicionado 11/05/23
	cAlias2 := oTable:GetAlias()			//adicionado 11/05/23
	cArq2   := oTable:GetRealName()			//adicionado 11/05/23
	//DBUSEAREA(.t.,"TOPCONN",cArq2,cAlias2)	//Alterado 11/05/23 - anterior: DBUSEAREA(.t.,,cArq2,"TC8")
Return

	********************************************
Static Function Monta_TC9(lJob)
	Local cQuery := ' '
	Local _nX := 0
	Local oTable  //adicionado 11/05/23
	Local cAlias  //adicionado 11/05/23
	Default lJob := .F.

	IF lJob

		if select("TC9") > 0      // Valdemir Rabelo 15/12/2020
			TC9->( dbCloseAre() )
			oTable:Delete("TC9") //adicionado 11/05/23
		endif

		oTable := FWTemporaryTable():New("TC9") //adicionado 11/05/23

		aFields   := {}
		AADD(aFields,{"T9_OK"     ,"C",02,0})
		AADD(aFields,{"T9_PEDIDO" ,"C",06,0})
		AADD(aFields,{"T9_ITEM"   ,"C",04,0})
		AADD(aFields,{"T9_PRODUTO","C",15,0})
		AADD(aFields,{"T9_DESC"   ,"C",40,0})
		AADD(aFields,{"T9_UM"     ,"C",02,0})
		AADD(aFields,{"T9_QTDE"   ,"N", 9,0})
		AADD(aFields,{"T9_UNIT"   ,"N",12,2})
		AADD(aFields,{"T9_TOTAL"  ,"N",14,2})
		AADD(aFields,{"T9_DTPRV"  ,"D",08,0})
		AADD(aFields,{"T9_ALMOX"  ,"C",02,0})
		AADD(aFields,{"T9_OBSERV" ,"C",30,0})
		AADD(aFields,{"T9_CCUSTO" ,"C",06,0})
		AADD(aFields,{"T9_CONTA"  ,"C",20,0})
		AADD(aFields,{"T9_TES"    ,"C", 3,0})
		AADD(aFields,{"T9_OP"     ,"C",13,0})
		AADD(aFields,{"T9_FRETE"  ,"N",14,2})
		AADD(aFields,{"T9_VALIPI" ,"N",14,2})
		AADD(aFields,{"T9_ALQIPI" ,"N", 6,2})
		AADD(aFields,{"T9_VALICM" ,"N",14,2})
		AADD(aFields,{"T9_ALQICM" ,"N", 6,2})
		AADD(aFields,{"T9_REG"    ,"N",10,0})

		//cArq:=Criatrab(aFields,.T.) 	// Funзгo CriaTrab() descontinuada - 11/05/23
		oTable:SetFields(aFields) 		//adicionado 11/05/23
		oTable:Create() 				//adicionado 11/05/23

		cAlias := oTable:GetAlias()				//adicionado 11/05/23
		cArq   := oTable:GetRealName()			//adicionado 11/05/23
		//DBUSEAREA(.t.,"TOPCONN",cArq,cAlias)	//Alterado 11/05/23 - anterior: DBUSEAREA(.t.,,cArq,"TC9")

	Endif

	// IrпїЅ efetuar a checagem de pedidos de compras
	// em aberto para este fornecedor e os itens desta nota fiscal a ser importa
	// serпїЅ demonstrado ao usuпїЅrio se o pedido de compra deverпїЅ ser associado
	// a entrada desta nota fiscal

	cQuery := ""
	cQuery += " SELECT  C7_NUM T9_PEDIDO,     "
	cQuery += " 		C7_ITEM T9_ITEM,    "
	cQuery += " 	    C7_PRODUTO T9_PRODUTO, "
	cQuery += " 		B1_DESC T9_DESC,    "
	cQuery += " 		B1_UM T9_UM,		"
	cQuery += " 		C7_QUANT T9_QTDE,   "
	cQuery += " 		C7_PRECO T9_UNIT,   "
	cQuery += " 		C7_TOTAL T9_TOTAL,   "
	cQuery += " 		C7_DATPRF T9_DTPRV,  "
	cQuery += " 		C7_LOCAL T9_ALMOX, "
	cQuery += " 		C7_OBS T9_OBSERV, "
	cQuery += " 		C7_CC T9_CCUSTO, "
	cQuery += " 		C7_CONTA T9_CONTA, "
	cQuery += " 		C7_TES T9_TES, "
	cQuery += " 		C7_OP T9_OP, "
	cQuery += " 		C7_VALFRE T9_FRETE, "
	cQuery += " 		C7_VALIPI T9_VALIPI, "
	cQuery += " 		C7_IPI T9_ALQIPI, "
	cQuery += " 		C7_VALICM T9_VALICM, "
	cQuery += " 		C7_PICM T9_ALQICM, "
	cQuery += " 		SC7.R_E_C_N_O_ T9_REG "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 " + ;
		"LEFT OUTER JOIN "+RetSqlName("SB1") + " SB1 ON (SB1.D_E_L_E_T_ <> '*') AND (SB1.B1_FILIAL = '"+xFilial("SB1")+"') AND (C7_PRODUTO = B1_COD) "
	cQuery += " WHERE (C7_FILENT = '" + xFilial("SC7") + "') "
	cQuery += " AND (SC7.D_E_L_E_T_ <> '*') "
	cQuery += " AND (C7_QUANT > C7_QUJE)  "
	cQuery += " AND (C7_RESIDUO = ' ')  "
	//	cQuery += " AND C7_TPOP <> 'P'  "
	cQuery += " AND (C7_CONAPRO <> 'B')  "
	cQuery += " AND (C7_ENCER = ' ') "
	//	cQuery += " AND C7_CONTRA = '' "
	//	cQuery += " AND C7_MEDICAO = '' "
	cQuery += " AND (C7_FORNECE = '" + SA2->A2_COD + "') "
	cQuery += " AND (C7_LOJA = '" + SA2->A2_LOJA + "') "
	cQuery += " AND C7_PRODUTO IN" + FormatIn( cProds, "/") + " "
	If MV_PAR01 <> 1
		cQuery += " AND 1 > 1 "
	Endif
	cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "
	TcQuery cQuery New alias "CAD"
	//cQuery := ChangeQuery(cQuery)
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
	TcSetField("CAD","T9_DTPRV","D",8,0)

	Dbselectarea("CAD")

	While CAD->(!EOF())
		RecLock("TC9",.T.)
		For _nX := 1 To Len(aFields)
			If !(aFields[_nX,1] $ 'T9_OK')
				If aFields[_nX,2] = 'C'
					_cX := 'TC9->'+aFields[_nX,1]+' := Alltrim(CAD->'+aFields[_nX,1]+')'
				Else
					_cX := 'TC9->'+aFields[_nX,1]+' := CAD->'+aFields[_nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		TC9->T9_OK := _cMarca //ThisMark()
		MsUnLock()

		DbSelectArea('CAD')
		CAD->(dBSkip())
	EndDo

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TC9")
	TC9->( DbGoTop() )

	_cIndex:=Criatrab(Nil,.F.)
	_cChave:="T9_PEDIDO"
	Indregua("TC9",_cIndex,_cChave,,,"Ordenando registros selecionados...")
	if !lJob
		DbSetIndex(_cIndex+ordbagext())
	Endif
	SysRefresh()
Return

Static Function GetArq(cArquivo)

	cArquivo:= cGetFile( "Arquivo NFe (*.xml) | *.xml", "Selecione o Arquivo de Nota Fiscal XML",,Caminho,.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE) ) //Exerga Unidade Mapeadas - Poliester
Return(cArquivo)

StatiC Function Fecha()
	Close(_oPT00005)
	lOut := .t.
Return

Static Function AchaFile(cArquivo)
	Local aCompl := {}
	Local cCaminho
	Local lOk := .f.
	Local nHdl,cArquivo,aFiles,nArq,nTamFile,nBtLidos,cBuffer,cChave,i

	cChave := alltrim(cCodBar)
	If Empty(cChave)
		Return(.t.)
	Endif

	if len(cChave) != 44
		MsgAlert("Tamanho da chave devera ter 44 digitos! Corrija por favor", "Atencao!")
		return(.f.)
	endif

	for i := 1 to 2
		cCaminho := alltrim(Caminho)
		if substr(cCaminho,len(cCaminho),1) != "\"
			cCaminho += "\"
		endif
		if i == 2
			cCaminho += "PROCESSADOS\"
		endif
		aFiles := Directory(cCaminho+"*.XML", "D")

		For nArq := 1 To Len(aFiles)
			cArquivo := AllTrim(cCaminho+aFiles[nArq,1])

			nHdl    := fOpen(cArquivo,0)
			If nHdl < 0
				MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser aberto! ERRO:"+StrZero(FERROR(), 1)+"!", "Atencao!")
				loop
			Endif
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
			fClose(nHdl)
			If AT(AllTrim(cChave),AllTrim(cBuffer)) > 0
				lOk := .t.
				Exit
			Endif
		Next
		if lOk
			exit
		endif
	next
	If !lOk
		cArquivo := ""
		MsgAlert("Nenhum Arquivo Encontrado, Por Favor Selecione a Opcao Arquivo e Busca na Arvore de Diretorios!")
	Endif

Return(lOk)

// Funcao de ENvio de Email de Aviso de PRe Nota

User Function EnvMail(_cSubject, _cBody, _cMailTo, _cCC, _cAnexo, _cConta, _cSenha)
	Local _cMailS		:= GetMv("MV_RELSERV")
	Local _cAccount		:= GetMV("MV_RELACNT")
	Local _cPass		:= GetMV("MV_RELFROM")
	Local _cSenha2		:= GetMV("MV_RELPSW")
	Local _cUsuario2	:= GetMV("MV_RELACNT")
	Local lAuth			:= GetMv("MV_RELAUTH",,.F.)

	Connect Smtp Server _cMailS Account _cAccount Password _cPass RESULT lResult

	If lAuth		// Autenticacao da conta de e-mail
		lResult := MailAuth(_cUsuario2, _cSenha2)
		If !lResult
			Alert("Nao foi possivel autenticar a conta - " + _cUsuario2)	//пїЅ melhor a mensagem aparecer para o usuпїЅrio do que no console ou no log.txt - Poliester
			//		ConOut("Nao foi possivel autenticar a conta - " + _cUsuario2)
			Return()
		EndIf
	EndIf

	_xx := 0

	lResult := .F.

	do while !lResult

		If !Empty(_cAnexo)
			Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody ATTACHMENT _cAnexo RESULT lResult
		Else
			Send Mail From _cAccount To _cMailTo CC _cCC Subject _cSubject Body _cBody RESULT lResult
		Endif

		_xx++
		if _xx > 2
			Exit
		Else
			Get Mail Error cErrorMsg
			ConOut(cErrorMsg)
		EndIf
	EndDo
Return

Static Function AJUSTSTR(cStr)

	Local nY		:= 0
	Local cNewStr	:= ""

	For nY:=1 To Len(cStr)

		If asc(substr(cStr,nY,1))<>10
			cNewStr		+= substr(cStr,nY,1)
		EndIf

	Next

Return(cNewStr)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅEXPORTXM	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFunпїЅпїЅo utilizada para exportar os arquivos XML da tabela    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅSZ9								 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function EXPORTXM()

	Local aRet 			:= {}
	Local aParamBox 	:= {}
	Local aArea			:= GetArea()
	Local aAreaSZ9		:= GetArea("SZ9")
	Local cPath     	:= ""
	Local cQuery	 	:= ""
	Local cAlias 		:= "QRYTEMP"

	AADD(aParamBox,{1,"Data de",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(aParamBox,{1,"Data ate",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(aParamBox,{1,"Nota de",Space(9),"@!",,,,9,.F.})
	AADD(aParamBox,{1,"Nota ate",Space(9),"@!",,,,9,.F.})

	If ParamBox(aParamBox,"Exportar XML",@aRet,,,.T.,,500)

		cPath		:= cGetFile( "Selecione o Diretorio | " , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )

		cQuery	:= " SELECT R_E_C_N_O_ REGISTRO "
		cQuery	+= " FROM " +RetSqlName("SZ9")+ " Z9 "
		cQuery  += " WHERE Z9.D_E_L_E_T_=' ' AND Z9_DTEMIS BETWEEN '"+DTOS(aRet[1])+"' AND '"+DTOS(aRet[2])+"' "
		cQuery	+= " AND Z9_NFEORI BETWEEN '"+aRet[3]+"' AND '"+aRet[4]+"' "

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())

		While (cAlias)->(!Eof())

			SZ9->(DbGoTop())
			SZ9->(DbGoTo((cAlias)->REGISTRO))

			cArquivo	:= Alltrim(SZ9->Z9_ORIGEM)+"_"+Alltrim(SZ9->Z9_CHAVE)+".xml"
			cAnexo		:= cPath+cArquivo

			If !Empty(SZ9->Z9_XML)
				If !File(cAnexo)
					nHdlXml   := FCreate(cAnexo,0)
					If nHdlXml > 0
						FWrite(nHdlXml,SZ9->Z9_XML)
						FClose(nHdlXml)
					Endif
				EndIf
			EndIf

			(cAlias)->(DbSkip())
		EndDo

		MsgInfo("Exportacao finalizada")

	EndIf

	RestArea(aArea)
	RestArea(aAreaSZ9)

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅVISPRENF	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVisualizar prпїЅ-nota									      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ									 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function VISPRENF()

	Local aArea		:= GetArea()
	Local aAreaSZ9	:= GetArea("SZ9")
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" 		,  0 , 1 },;
		{ "Visualizar" 			, "AxALTERA" 	, 0 , 4 },;
		{ "Gerar pre-nota" 		, "U_EXECPREN" 	, 0 , 3 },;
		{ "Baixar XML"		 	, "U_BAIXAXM1" 	, 0 , 4 },;
		{ "Legenda"    			, "U_GRVPRELG" 	, 0 , 5 },;
		{ "Gerar com arquivo"	, "U_EXECPREA" 	, 0 , 6 },;
		{ "Exportar XML"		, "U_EXPORTXM" 	, 0 , 7 },;
		{ "Visualizar pre-nota"	, "U_VISPRENF" 	, 0 , 8 },;
		{ "Visualizar Danfe"	, "U_XVERDANFE(SZ9->Z9_CHAVE)" 	, 0 , 9 },;
		{ "Consulta Inconsistкncia","U_INCONSIS", 0 , 10},;
		{ "Rel.Inconsistencia"	, "U_RSTFATAR" 	, 0 , 11 }}

	If Empty(SZ9->Z9_DOC)
		MsgAlert("AtenпїЅпїЅo, a pre-nota ainda nпїЅo foi gerada, verifique!")
		Return()
	EndIf

	DbSelectArea("SF1")
	SF1->(DbGoTop())
	SF1->(DbSetOrder(8)) //F1_FILIAL+F1_CHVNFE

	If SF1->(DbSeek(SZ9->(Z9_FILIAL+Z9_CHAVE)))
		A103NFiscal("SF1",SF1->(Recno()),2)
	EndIf

	RestArea(aArea)
	RestArea(aAreaSZ9)

Return()

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅXTESINTE	пїЅAutor  пїЅ				     пїЅ Data пїЅ  15/08/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅBuscar a TES correspondente (feito pois a padrпїЅo nпїЅo estava пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅretornando nada)				 	 				      	  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅAgradecimentos ao Everaldo Gallo por ceder a funпїЅпїЅo      	  пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function XTESINTE(_cTipo,_coper,_cProd,_cCliFor,_Cloja)

	Local _cLocArea := GetArea()
	Local cTes 		:= ""
	Local cQuery 	:= ""
	Local cAlias	:= "QRYTEMP"

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+_cProd))
		nRecSB1 := SB1->(Recno())
	Else
		Return nRet
	EndIf

	if _cTipo = "F"
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		If !SA2->(DbSeek(xFilial("SA2")+_cCliFor+_cLoja))
			Return nRet
		EndIf
		cQuery :=	" SELECT   NVL(FM_TE,' ') FM_TE  FROM ( "
	Else
		SA1->(DbSetOrder(1))
		cQuery :=	" SELECT   NVL(FM_TS,' ') FM_TE  FROM ( "
		If !SA1->(DbSeek(xFilial("SA2")+_cCliFor+_cLoja))
			Return nRet
		EndIf
	Endif

	cQuery +=	" SELECT * FROM "+RetSQLTab('SFM')+"   "
	cQuery +=	" WHERE FM_FILIAL = '"+xFilial("SFM")+ "' AND FM_TIPO =  '"+ _cOper+"'"
	cQuery +=	" AND (FM_PRODUTO = '"+SB1->B1_COD+    "' OR (FM_PRODUTO = ' ')) "
	cQuery +=	" AND (FM_FORNECE = '"+_cClifor+    "' OR (FM_FORNECE = ' ')) "
	cQuery +=	" AND (FM_LOJAFOR = '"+_cLoja+   "' OR (FM_LOJAFOR = ' ')) "
	cQuery +=	" AND (FM_POSIPI  = '"+SB1->B1_POSIPI+ "' OR (FM_POSIPI  = ' ')) "
	cQuery +=	" AND (FM_GRPROD  = '"+SB1->B1_GRTRIB+ "' OR (FM_GRPROD  = ' ')) "
	cQuery +=	" AND D_E_L_E_T_ = ' ' "
	cQuery +=	" ) TEMP WHERE ROWNUM = 1 "
	cQuery +=	"  ORDER BY FM_PRODUTO DESC, FM_GRPROD DESC, FM_POSIPI DESC, FM_FORNECE DESC, FM_LOJAFOR DESC, FM_GRTRIB DESC, FM_EST DESC "

	cQuery := ChangeQuery(cQuery)

	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
	//пїЅ Fecha Alias se estiver em Uso пїЅ
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	cTes := IIF(_cTipo = 'F',(cAlias)->FM_TE,(cAlias)->FM_TS)

	dbCloseArea(cAlias)

	Restarea( _cLocArea )

Return (cTes)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅSTFILPC1	пїЅAutor  пїЅ				     пїЅ Data пїЅ  03/06/14   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅFiltrar fatecs amarradas no cliente  					      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ									 	 				      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅParametro пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅRetorno   пїЅ Nenhum                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function STFILPC1()

	Local _lRet := .F.

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	SA1->(DbGoTop())
	If SA1->(DbSeek(xFilial("SA1")+oNF:_InfNfe:_Emit:_Cnpj:Text))
		DbSelectArea("PC1")
		PC1->(DbGoTop())
		PC1->(DbSetOrder(5))
		If PC1->(DbSeek(xFilial('PC1')+MV_PAR01))
			If PC1->PC1_CODCLI==SA1->A1_COD .And. PC1->PC1_LOJA==SA1->A1_LOJA .And. PC1->PC1_STATUS=="2"
				_lRet	:= .T.
			Else
				MsgAlert("Fatec incorreta")
			EndIf
		Else
			MsgAlert("Fatec nao encontrada")
		EndIf
	Else
		MsgAlert("Cliente nao encontrado")
	EndIf

Return(_lRet)

/*====================================================================================\
	|Programa  | ST_a01Header     | Autor | GIOVANI.ZAGO             | Data | 10/07/2014  |
	|=====================================================================================|
	|DescriпїЅпїЅo |                                                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ST_a01Header                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................HistпїЅrico....................................|
\====================================================================================*/
*-----------------------------*
Static Function ST_aHeader(_cCgc,_cCod,_cLoj)
	*-----------------------------*
	Local cPerg       := 'ST_aHeader'
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAlias      := cPerg+cHora+ cMinutos+cSegundos
	Local cQuery 	  := ""

	_aHeader:= {}
	//TamSx3("B1_DESC")[1]
	aAdd(_aHeader,{"Produto",		"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ","C","","","","",".T."})
	aAdd(_aHeader,{"Descricao",		"XX_DESC"	,"@!",30					,0,"","пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ","C","","","","",".T."})
	aAdd(_aHeader,{"Qtd.",	   		"XX_QTD"	,"@E 999,999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ","N","","","","",".T."})
	aAdd(_aHeader,{"Prc.",	   		"XX_PRC"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ","N","","","","",".T."})
	aAdd(_aHeader,{"Ord.Compra",	"XX_ORD"	,"@!",TamSx3("D2_COD")[1]	,0,"","пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ","C","","","","",".T."})

	_aCols:= {}

	cQuery:= " 	SELECT
	cQuery+= " SC7.C7_PRODUTO,
	cQuery+= " SC7.C7_DESCRI,
	cQuery+= " SC7.C7_QUANT-SC7.C7_QUJE
	cQuery+= ' "C7_QUANT",
	cQuery+= " SC7.C7_PRECO,
	cQuery+= " SC7.C7_NUM
	cQuery+= " FROM "+RetSqlName("SC7")+"  SC7
	cQuery+= " WHERE SC7.D_E_L_E_T_ = ' '
	cQuery+= " AND SC7.C7_FILENT = '"+cFilAnt+"'
	cQuery+= " AND SC7.C7_FORNECE =  '"+_cCod+"'
	cQuery+= " AND SC7.C7_LOJA = '"+_cLoj+"'
	cQuery+= " AND SC7.C7_RESIDUO = ' '
	cQuery+= " AND SC7.C7_QUANT   > SC7.C7_QUJE

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		Aadd(_aCols,{(cAlias)->C7_PRODUTO,;
			(cAlias)->C7_DESCRI	,;
			(cAlias)->C7_QUANT	,;
			(cAlias)->C7_PRECO	,;
			(cAlias)->C7_NUM	,;
			.f.   })

		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())

	If Len(_aCols) = 0
		Aadd(_aCols,{' ',' ',0,0,' ',.f.   })
	EndIf
Return()

//CпїЅDIGO DO ITEM, DESCRIпїЅпїЅO, QUANTIDADE, VALOR E ORDEM DE COMPRA

/*====================================================================================\
|Programa  | INCFATEC         | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|DescriпїЅпїЅo | Incluir fatec automaticamente                                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                       |
|=====================================================================================|
|........................................HistпїЅrico....................................|
\====================================================================================*/

Static Function INCFATEC()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	Local _lAchou  := .F.
	Local _nX:=1

	If !Type("oIdent:_NFREF:_REFNFE:TEXT")=="C"
		Return
	EndIf

	Begin Transaction

		_cQuery1 := " SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_CHVNFE
		_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
		_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND F2_FILIAL='"+xFilial("SF2")+"'
		_cQuery1 += " AND F2_CHVNFE='"+oIdent:_NFREF:_REFNFE:TEXT+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())

			_cNumFat := GETSX8NUM("PC1","PC1_NUMERO")

			PC1->(RecLock("PC1",.T.))
			PC1->PC1_FILIAL	:= xFilial("PC1")
			PC1->PC1_NUMERO	:= _cNumFat
			PC1->PC1_STATUS	:= "0"
			PC1->PC1_NOTAE	:=	""
			PC1->PC1_SERIEE	:=	""
			PC1->PC1_CODCLI	:= (_cAlias1)->F2_CLIENTE
			PC1->PC1_NOMCLI	:=	Posicione("SA1",1,xFilial("SA1")+(_cAlias1)->(F2_CLIENTE+F2_LOJA),"A1_NOME")
			PC1->PC1_LOJA	:=	(_cAlias1)->F2_LOJA
			PC1->PC1_CONTAT	:=	"ROTINA AUTOMATICA"
			PC1->PC1_ATENDE	:=	SUBSTR(CUSUARIO,7,15)
			PC1->PC1_MOTIVO	:=	"999"
			PC1->PC1_REPOSI	:=	"2"
			PC1->PC1_DEVMAT	:=	"1"
			PC1->PC1_DTOCOR	:=	Date()
			PC1->PC1_PEDREP	:=	""
			PC1->PC1_CODUSR	:= __cUserId
			PC1->(MsUnLock())

			DbSelectArea("PC2")

			For _nX:=1 To Len(aItens)

				_cQuery2 := " SELECT D2_ITEM, D2_QUANT
				_cQuery2 += " FROM "+RetSqlName("SD2")+" D2
				_cQuery2 += " WHERE D2.D_E_L_E_T_=' '
				_cQuery2 += " AND D2_FILIAL='"+(_cAlias1)->F2_FILIAL+"'
				_cQuery2 += " AND D2_DOC='"+(_cAlias1)->F2_DOC+"'
				_cQuery2 += " AND D2_SERIE='"+(_cAlias1)->F2_SERIE+"'
				_cQuery2 += " AND D2_COD='"+aItens[_nX][1][2]+"'

				If !Empty(Select(_cAlias2))
					DbSelectArea(_cAlias2)
					(_cAlias2)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

				dbSelectArea(_cAlias2)
				(_cAlias2)->(dbGoTop())

				If (_cAlias2)->(!Eof())

					_lAchou  := .T.

					PC2->(RecLock("PC2",.T.))
					PC2->PC2_FILIAL := xFilial("PC2")
					PC2->PC2_NFATEC := _cNumFat
					PC2->PC2_PRODUT := aItens[_nX][1][2]
					PC2->PC2_DESPRO	:= Posicione("SB1",1,xFilial("SB1")+aItens[_nX][1][2],"B1_DESC")
					PC2->PC2_NFORIG := (_cAlias1)->F2_DOC
					PC2->PC2_SERIE  := (_cAlias1)->F2_SERIE
					PC2->PC2_ITEM	:= (_cAlias2)->D2_ITEM
					PC2->PC2_QTDNFS	:= (_cAlias2)->D2_QUANT
					PC2->PC2_QTDFAT	:= aItens[_nX][2][2]
					PC2->PC2_GRPPRO	:= Posicione("SB1",1,xFilial("SB1")+aItens[_nX][1][2],"B1_GRUPO")
					PC2->PC2_DSCPRO := Posicione("SBM",1,xFilial("SBM")+Posicione("SB1",1,xFilial("SB1")+aItens[_nX][1][2],"B1_GRUPO"),"BM_DESC")
					PC2->(MsUnLock())

				EndIf

			Next

			If !_lAchou
				DisarmTransaction()
				Break
			Else

				_cEmail   := SuperGetMv("ST_EMLFAT",.F.,"marcelo.oliveira@steck.com.br")
				_cCopia	  := ""
				_cAssunto := "[PROTHEUS] - Fatec "+_cNumFat+" incluпїЅda automaticamente"
				_aAttach  := {}
				_cCaminho := ""

				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Nota fiscal origem: </b>'+Alltrim((_cAlias1)->F2_DOC)+'<br>'
				cMsg += '<b>Cliente: </b>'+(_cAlias1)->F2_CLIENTE+'<br>'
				cMsg += '<b>Loja: </b>'+(_cAlias1)->F2_LOJA+'<br>'
				cMsg += '</body></html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			EndIf

		EndIf

	End Transaction

Return()

/*{Protheus.doc} RegistPC
FunпїЅпїЅo Registrar o PC em tabela complementar
@author Valdemir Rabelo
@since 11/03/2020
@type function
*/
Static Function RegistPC()
	Local aAreaPC  := GetArea()
	Local _lCusTi  := .F.
	Local _lFatec  := .F.

	dbSelectArea("ZZ8")
	ZZ8->(dbSetOrder(1))	//ZZ8_FILIAL+ZZ8_REGIST
	SC7->(dbSetOrder(14))	//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	SD1->(dbSetOrder(1))
	If SD1->(MsSeek( cChave := xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChave
			If SC7->(dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
				RecLock("SF1",.F.)
				SF1->F1_XPLAN := SC7->C7_XPLAN
				SF1->(MsUnlock())

				If ZZ8->(dbSeek(xFilial("ZZ8")+SC7->C7_XPLAN))
					RecLock("ZZ8",.F.)
					ZZ8->ZZ8_STATUS := 'B'
					ZZ8->(MsUnlock())
				EndIf

				EXIT
			EndIf
			SD1->(dbSkip())
		EndDo
	EndIf
	If SD1->(MsSeek( cChave := xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChave
			If Alltrim(SD1->D1_CC) = '112104'
				_lCusTi := .T.
			EndIf
			If !Empty(Alltrim(SD1->D1_XFATEC))
				_lFatec := .T.
				_cNumFatec	:= Alltrim(SD1->D1_XFATEC)
			Endif
			SD1->(dbSkip())
		EndDo
	EndIf
	If _lCusTi
		MailTI()
	EndIf

	If _lFatec
		MailExp(_cNumFatec)
	EndIf

	RestArea( aAreaPC )

Return


/*
	DescriпїЅпїЅo:		Envia WF
	Data:			11/03/2020
*/
Static Function  MailTI()
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'NF DE ENTRADA COM CC DE T.I.'
	Local cFuncSent:= "MailTI"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'GIOVANI.ZAGO@STECK.COM.BR '
	Local cAttach  := ''

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := 'GIOVANI.ZAGO@STECK.COM.BR'

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))


		Aadd( _aMsg , { "NF Num: "          , SF1->F1_DOC } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Status: "    		, "inclusao" } )
		Aadd( _aMsg , { "CC: "    			, '112104' } )
		If 	SA2->(DbSeek(xFilial("SA2")+ SF1->F1_FORNECE + SF1->F1_LOJA ))
			Aadd( _aMsg , { "Forncedor: "  		, SA2->A2_COD+SA2->A2_LOJA + '-'+SA2->A2_NREDUZ } )
		EndIf
		Aadd( _aMsg , { "Usuario: " 	 	, cUserName } )


		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
		//пїЅ Definicao do cabecalho do email                                             пїЅ
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
		//пїЅ Definicao do texto/detalhe do email                                         пїЅ
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
		//пїЅ Definicao do rodape do email                                                пїЅ
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()


Static Function getQrySC7(pcProduto, pcNumPC, pcItemPC, pSepara, pNAglut)
	Local aArea       := GetArea()
	Local cQuery      := ""
	Local aRET        := {}
	Local aIMPOSTO    := {0,0,0,0,0,0,0,0,{{'','',0,0,0}},0,0,0,0,0}
	Default pcProduto := ""
	Default pcNumPC   := ""
	Default pSepara   := ""
	Default pNAglut   := .F.

	dbSelectArea("SC7")

	cQuery := ""
	cQuery += " SELECT       	" + CRLF
	cQuery += " 	    C7_PRODUTO T9_PRODUTO, 	" + CRLF
	cQuery += " 		SC7.R_E_C_N_O_ T9_REG " + CRLF
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 " + CRLF
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SB1") + " SB1 ON (SB1.D_E_L_E_T_ <> '*') AND (SB1.B1_FILIAL = '"+xFilial("SB1")+"') AND (C7_PRODUTO = B1_COD) " + CRLF
	cQuery += " WHERE (C7_FILENT = '" + xFilial("SC7") + "') " + CRLF
	cQuery += " AND (SC7.D_E_L_E_T_ <> '*') " + CRLF
	cQuery += " AND (C7_QUANT > C7_QUJE)  	" + CRLF
	cQuery += " AND (C7_RESIDUO = ' ')  		" + CRLF
	cQuery += " AND (C7_CONAPRO <> 'B')  	" + CRLF
	cQuery += " AND (C7_ENCER = ' ') " + CRLF
	cQuery += " AND (C7_FORNECE = '" + Alltrim(SA2->A2_COD) + "') " + CRLF
	cQuery += " AND (C7_LOJA = '" + SA2->A2_LOJA + "') " + CRLF
	if !Empty(pcProduto)
		cQuery += " AND C7_PRODUTO IN ('" + pcProduto + "') " + CRLF
	Endif
	if !Empty(pcNumPC)
		if At(pSepara, cNumPC) > 0
			cQuery += " AND C7_NUM IN" + FormatIn(pcNumPC, pSepara)+ " " + CRLF
		else
			cQuery += " AND C7_NUM = '" + pcNumPC + "' " + CRLF
			cQuery += " AND C7_ITEM = '" + pcItemPC + "' " + CRLF
		endif
	endif
	If MV_PAR01 <> 1
		cQuery += " AND 1 > 1 " + CRLF
	Endif
	cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO " + CRLF
	if Select("TSC7") > 0
		TSC7->( dbCloseArea( ))
	Endif

	TcQuery cQuery New Alias "TSC7"

	While TSC7->( !Eof() )
		SC7->( dbGoto(TSC7->T9_REG) )
		nPosCPO := aScan(aRET, {|X| Alltrim(X[1])==Alltrim(TSC7->T9_PRODUTO) })
		if ((nPosCPO == 0) .or. pNAglut)
			aAdd(aRET, Array(10))
			nPosCPO := Len(aRET)
			aRET[nPosCPO][01] := ""
			aRET[nPosCPO][02] := 0
			aRET[nPosCPO][03] := 0
			aRET[nPosCPO][04] := 0
			aRET[nPosCPO][05] := 0
			aRET[nPosCPO][06] := 0
			aRET[nPosCPO][07] := 0
			aRET[nPosCPO][08] := 0
			aRET[nPosCPO][09] := 0
			aRET[nPosCPO][10] := ""
		endif
		aRET[nPosCPO][01] := TSC7->T9_PRODUTO
		aRET[nPosCPO][02] += SC7->C7_QUANT
		aRET[nPosCPO][03] := SC7->C7_PRECO
		aRET[nPosCPO][04] += SC7->C7_VALIPI
		aRET[nPosCPO][05] += SC7->C7_VALICM
		aRET[nPosCPO][06] := SC7->C7_NUM
		aRET[nPosCPO][07] := SC7->(Recno())
		aRET[nPosCPO][08] := SC7->C7_IPI
		aRET[nPosCPO][09] := SC7->C7_PICM
		aRET[nPosCPO][10] := SC7->C7_UM
		//aIMPOSTO    := aClone(MaFisRet(,"NF_IMPOSTOS"))
		TSC7->( dbSkip() )
	EndDo

	if Select("TSC7") > 0
		TSC7->( dbCloseArea( ))
	Endif

	RestArea( aArea )

Return aRET


Static Function getQrySD2(pcProduto, pcNumRF)
	Local aArea		  := GetArea()
	Local cQuery      := ""
	Local aRET        := {}
	Default pcProduto := ""
	Default pcNumRF   := ""

	dbSelectArea("SD2")

	cQuery := ""
	cQuery += " SELECT       	" + CRLF
	cQuery += " 	    D2_COD T9_PRODUTO, 	" + CRLF
	cQuery += " 		SD2.R_E_C_N_O_ T9_REG " + CRLF
	cQuery += "FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += "INNER JOIN "+RETSQLNAME('SF2')+" SF2 " +  CRLF
	cQUERY += "ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND SF2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SB1") + " SB1 ON (SB1.D_E_L_E_T_ <> '*') AND (SB1.B1_FILIAL = '"+xFilial("SB1")+"') AND (D2_COD = B1_COD) " + CRLF
	cQuery += " WHERE (D2_FILIAL = '" + xFilial("SD2") + "') " + CRLF
	cQuery += " AND (SD2.D_E_L_E_T_ = ' ') " + CRLF
	cQuery += " AND (D2_QUANT > D2_QTDEDEV)  	" + CRLF
	cQuery += " AND (F2_CHVNFE ='"+pcNumRF+"') "

	if !Empty(pcProduto)
		cQuery += " AND D2_COD IN ('" + pcProduto + "') " + CRLF
	Endif
	If MV_PAR01 <> 1
		cQuery += " AND 1 > 1 " + CRLF
	Endif
	cQuery += " ORDER BY D2_DOC, D2_ITEM, D2_COD " + CRLF

	if Select("TSD2") > 0
		TSD2->( dbCloseArea( ))
	Endif

	TcQuery cQuery New Alias "TSD2"

	While TSD2->( !Eof() )
		SD2->( dbGoto(TSD2->T9_REG) )
		nPosCPO := aScan(aRET, {|X| Alltrim(X[1])==Alltrim(TSD2->T9_PRODUTO) })
		if (nPosCPO == 0) 
			aAdd(aRET, Array(10))
			nPosCPO := Len(aRET)
			aRET[nPosCPO][01] := ""
			aRET[nPosCPO][02] := 0
			aRET[nPosCPO][03] := 0
			aRET[nPosCPO][04] := 0
			aRET[nPosCPO][05] := 0
			aRET[nPosCPO][06] := 0
			aRET[nPosCPO][07] := 0
			aRET[nPosCPO][08] := 0
			aRET[nPosCPO][09] := 0
			aRET[nPosCPO][10] := ""
		endif
		aRET[nPosCPO][01] := TSD2->T9_PRODUTO
		aRET[nPosCPO][02] += SD2->D2_QUANT
		aRET[nPosCPO][03] := SD2->D2_PRCVEN
		aRET[nPosCPO][04] += SD2->D2_VALIPI
		aRET[nPosCPO][05] += SD2->D2_VALICM
		aRET[nPosCPO][06] := SD2->D2_DOC
		aRET[nPosCPO][07] := SD2->(Recno())
		aRET[nPosCPO][08] := SD2->D2_IPI
		aRET[nPosCPO][09] := SD2->D2_PICM
		aRET[nPosCPO][10] := SD2->D2_UM
		TSD2->( dbSkip() )
	EndDo

	if Select("TSD2") > 0
		TSD2->( dbCloseArea( ))
	Endif

	RestArea(aArea)

Return aRET


/*/{Protheus.doc} VldGrvNF
description
@type function
@version  
@author Valdemir Jose
@since 16/02/2021
@param aCabec, array, param_description
@param aItens, array, param_description
@param aGrvPcNF, array, param_description
@param aErrorLog, array, param_description
@param lJob, logical, param_description
@return return_type, return_description
/*/
Static Function VldGrvNF(aCabec,aItens,aGrvPcNF,aErrorLog,lJob, lGerArq)
	Local lRET := .T.
	Local nPosCol := 0
	Local nQtdMax := 0
	Local nPosCol := 0
	Local nQtdMin := 0
	Local nItem   := 0
	Local nSldTMP := 0
	Local nVlrIPI := 0
	Local nVlrICM := 0
	Local nPIPI   := 0
	Local nPICM   := 0
	Local nTotTMP := 0
	Local cProduto:= ""
	Local cPedCom := ""
	Local cItemPC := ""
	Local cUniMed := ""
	Local cAutori := SuperGetMV("ST_AUTOXML",.F.,"")
	Local lSit    := .F.
	//Local lError  := .F.
	Local cMailResp  := SuperGetMV("ST_EMLPRNF",.F., 'valdemir.rabelo@sigamat.com.br' )
	Local _cCIPICFOP := SuperGetMV("ST_XCICONS",.F.,"E,U") // Iniciais do Produto para saber se ira tratar uso e consumo
	Local _cSIPICFOP := SuperGetMV("ST_XSICONS",.F.,"")
	Local _cfopTMP   := ""
	Local nX, nW, _nRef

	Default aErrorLog := {}


	lMsgProc := .F.

	aRetTMP := {}

	For nItem := 1 to Len(aItens)

		nPosCol  := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_COD"})
		cProduto := aItens[nItem][nPosCol][2]

		nPosCol  := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_PEDIDO"})
		cPedCom  := PadL(aItens[nItem][nPosCol][2],TamSX3("C7_NUM")[1],"0")

		nPosCol  := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_ITEMPC"})
		cItemPC  := PadL(aItens[nItem][nPosCol][2],TamSX3("C7_ITEM")[1],"0")

		nColCFOP := aScan(aItens[nItem], {|X| alltrim(X[1])=="CFOP"})
		_cfopTMP := aValidaN[nItem][nColCFOP][2]

		_lCfopPc := getCFOPCPC(_cfopTMP)
		_lCfopNF := getCFOPNFO(_cfopTMP)


		if _lCfopNF   //(_cfopTMP=="1902")					// Valdemir Rabelo 14/05/2020 -1924 (Nгo existe pedido, neste caso pedimos que a Validaзгo seja feita com o documento referenciado na Tag (NFref) conforme e-mail 12/05/2020
			aItens[nItem][nPosCol][2] := ""
			aItens[nItem][nPosCol][2] := ""
			// Valdemir Rabelo - 17/09/2021
			cREFNF := ""
			if Len(aREFNF) > 0
				For _nRef := 1 to Len(aREFNF)
					cREFNF := aREFNF[_nRef][2]
					// Verificar Tag da NF se esta vazia
					if Empty(cREFNF)
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {upper("Item: "+StrZero(nItem,4)+cColorI+" - tag: Ref.Nota Fiscal"+cColorF), cColorI+" - Ref.Nota Fiscal XML: nao informado"+cColorF,.F.})
						lError := .t.
						Loop
					Endif
					// Posicionar SF2, Verificando se existe
					nCHVNFE := GetRecF2(cREFNF)
					if nCHVNFE > 0
						SF2->( dbGoto(nCHVNFE) )
						SD2->( dbSetOrder(3) )
						if SD2->( dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)+cProduto ) )						    
						   nPosCol := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_QUANT" })
						   if aItens[nItem][nPosCol][2] <= SD2->D2_QUANT
								//aadd(aItens, {"D1_NFORI"	, SF2->F2_DOC,   .f.,Nil})
								//aadd(aItens, {"D1_SERIORI",SF2->F2_SERIE, .f.,Nil})
								aREFNF[_nRef][1] := cProduto
								aREFNF[_nRef][3] := SD2->(RECNO())
								aREFNF[_nRef][4] := SF2->F2_DOC
								aREFNF[_nRef][5] := SF2->F2_SERIE
								exit
						   Else 
								cColorI := "<b><FONT COLOR=RED>"
								cColorF := "</b></FONT>"
								AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Ref.NF XML: "+cREFNF), upper("nгo contйm saldo"+cColorF),.F.})
								lError := .t.					
						   endif 
						Endif 
						
					Else 
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {upper(cColorI+"Ref.NF XML: "+cREFNF), upper("Nota Fiscal Protheus: Nao Encontrado"+cColorF),.F.})
						lError := .t.					
					Endif 
				Next
			else
				// Verificar Tag da NF se esta vazia
				if Empty(cREFNF)
					cColorI := "<b><FONT COLOR=RED>"
					cColorF := "</b></FONT>"
					AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - tag: Ref.Nota Fiscal"+cColorF), cColorI+" - Ref.Nota Fiscal XML: nao informado"+cColorF,.F.})
					lError := .t.
				Endif

			endif

			// Buscar Registro com base no Produto
			aRetTMP   := getQrySD2(cProduto, cREFNF)
			cAliasTMP := "SD2"
			cQtdTMP   := "D2_QUANT"
			cQtdEnt   := "D2_QTDEDEV"
			cPrecoTMP := "D2_PRCVEN"
			cVALFRE   := "D2_VALFRE"
			cUMTMP    := "D2_UM"
			cProdTMP  := "D2_COD"


		else

			if _lCfopPc

				if !Empty(cPedCom) .AND. (cPedCom != '000000')

					cPedCom := PADL(AllTrim(cPedCom),TamSx3("C7_NUM")[1],"0")

					SC7->( dbSetOrder(14) )
					if SC7->( !dbSeek(xFilial('SC7')+cPedCom+cItemPC ) )
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
						AddLogErr(aErrorLog,  {cColorI+"Item XML: "+cItemPC+" - Pedido XML: "+cPedCom, upper("Ped.Compra Protheus: Nao Encontrado"+cColorF),.F.})
						lError := .t.
						Loop
					else
						IF (ALLTRIM(SC7->C7_PRODUTO) != ALLTRIM(cProduto))
							// Removido pelo fato da Vanessa nгo querer essa mensagem a mais - 03/08/2021
							//cColorI := "<b><FONT COLOR=RED>"
							//cColorF := "</b></FONT>"
							//AddLogErr(aErrorLog,  {cColorI+"Item Pedido XML: "+cItemPC+" - Pedido XML: "+cPedCom, upper("Produto: "+ALLTRIM(cProduto)+" nao encontrado. Verificar Produto x Fornecedor."+cColorF),.F.})
							//lError := .t.
						Endif

						aRetTMP := getQrySC7(cProduto,cPedCom,cItemPC,',')

						if Len(aRetTMP)==0
							cColorI := "<b><FONT COLOR=RED>"
							cColorF := "</b></FONT>"
							AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Produto Protheus: "+cProduto),upper("Produto Protheus: Nao tem saldo / ou nгo encontrado"+cColorF),.F.})
							lError := .t.
						ELSE
							SC7->( dbGoto(aRetTMP[1, 7]) )            // Posiciono SC7
							SB1->( dbSeek(xFilial('SB1')+cProduto) )  // posiciono SB1
							lAchou := .T.
						Endif

					Endif


					cAliasTMP := "SC7"
					cQtdTMP   := "C7_QUANT"
					cQtdEnt   := "C7_QUJE"
					cPrecoTMP := "C7_PRECO"
					cVALFRE   := "C7_VALFRE"
					cUMTMP    := "C7_UM"
					cProdTMP  := "C7_PRODUTO"

				else
					cAliasTMP := "SD1"
					cQtdTMP   := "D1_QUANT"
					cQtdEnt   := "D1_QUANT"
					cPrecoTMP := "D1_VUNIT"
					cVALFRE   := "D1_VALFRE"
					cUMTMP    := "D1_UM"
					cProdTMP  := "D1_COD"

					if (!lMsgProc)
						lError := .t.
						if !lJob
							cColorI := "<b><FONT COLOR=RED>"
							cColorF := "</b></FONT>"
							AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+cColorF+""), cColorI+" NAO ENCONTROU PEDIDOS COM SALDO"+cColorF, .T. })
						endif
					endif

				Endif

			endif

		endif

		cColorI := ""
		cColorF := ""

		// Localiza o Min e Max Permitido
		if Len(aRetTMP) > 0
			(cAliasTMP)->( dbGoto(aRetTMP[1][7]) )
			if alltrim(cProduto) != ALLTRIM((cAliasTMP)->(&cProdTMP))
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
				lError := .t.
				//if aScan(aErrorLog, { |X| X[1]+X[2]==cColorI+upper("Item: "+StrZero(nItem,4)+" - Produto XML: "+cProduto)+cColorF})==0
				//	AddLogErr(aErrorLog,   {cColorI+upper("Item: "+StrZero(nItem,4)+" - Produto XML Convertido: "+cProduto)+cColorF, cColorI+upper("Produto Protheus: "+(cAliasTMP)->(&cProdTMP))+cColorF, .T.})
				//Endif
			Else
				AddLogErr(aErrorLog,   {upper("Item: "+StrZero(nItem,4)+cColorI+" - Produto XML: "+cProduto)+cColorF, cColorI+upper("Produto Protheus: "+(cAliasTMP)->(&cProdTMP))+cColorF, .T.})
			Endif
			nPosCol := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_QUANT" })
			nQtdMax := aRetTMP[1][2] + ((aRetTMP[1][2] * nToleran)/100)
			nPosCol := aScan(aItens[nItem], {|X| alltrim(X[1])=="D1_QUANT" })
			nQtdMin := aRetTMP[1][2] - ((aRetTMP[1][2] * nToleran)/100)
		endif
		nToler  := 0
		if (Len(aRetTMP) > 0) .and. _lCfopPc
			(cAliasTMP)->( dbGoto(aRetTMP[1][7]) )
			nToler   := ((cAliasTMP)->&(cQtdTMP) * 10) / 100
			nSldTMP  := ((cAliasTMP)->&(cQtdTMP)-(cAliasTMP)->&(cQtdEnt) )+nToler

			if ( (aItens[nItem,nPosCol, 2] > 0) .and. (aItens[nItem,nPosCol, 2] > nQtdMax) )   // Removido a Qtd.Min por solicitaзгo da Verфnica 22/02/2021
				lSit   := .F.
				lError := .t.
			Elseif ( (cAliasTMP)->&(cQtdEnt) > 0) .AND. (nSldTMP==0)
				lSit    := .F.
				lError  := .t.
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
				if aScan(aErrorLog, { |X| X[1]+X[2]=="Item: "+StrZero(nItem,4)+"Protheus:PEDIDO S/ SALDO"})==0
					AddLogErr(aErrorLog,  {upper("Item: "+StrZero(nItem,4)+cColorI+" - Qtde.XML: "+cValToChar(aItens[nItem,nPosCol, 2])), upper(cColorI+"Protheus:PEDIDO S/ SALDO"+cColorF), lSit })
				endif
			Elseif ( (cAliasTMP)->&(cQtdEnt) > 0) .AND. (aItens[nItem,nPosCol, 2] > nSldTMP )   //C7_quant -c7_quje
				lSit    := .F.
				lError  := .t.
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Qtde.XML: "+cValToChar(aItens[nItem,nPosCol, 2])+cColorF), upper(cColorI+" Protheus Saldo: "+cValToChar(nSldTMP)+" (Ultrapassou saldo)"+cColorF), lSit })
			Elseif !getVldPC(cPedCom,cItemPC, aItens[nItem,nPosCol, 2], aErrorLog, nQtdMin, nQtdMax)
				lError  := .t.
				lSit    := .F.
			Else
				cColorI := ""
				cColorF := ""
				nQtdXML := aItens[nItem,nPosCol, 2]
				lSit    := .T.
				nPIPI   := aRetTMP[1][8]
				nPICM   := aRetTMP[1][9]
				nTotTMP := ( (cAliasTMP)->&(cPrecoTMP)*nQtdXML)

				IF nPIPI > 0
					nVlrIPI := ((nTotTMP * nPIPI) / 100)
				Endif

				if nPICM > 0
					if (Left(cProduto,1) $ _cCIPICFOP)						 // Valdemir Rabelo 17/04/2020 - Iniciais do Produto para saber se ira tratar uso e consumo
						nBaseICM := nTotTMP + (cAliasTMP)->&(cVALFRE)   		 // BASE ICM
						nVlrICM  := ((nBaseICM + nVlrIPI) * nPICM) / 100
					else
						nBaseICM := nTotTMP + (cAliasTMP)->&(cVALFRE)   // BASE ICM - Conforme e-mail do Rafael 22/04/2018
						nVlrICM  := (nBaseICM  * nPICM) / 100
					endif
				endif

			endif
			AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Qtde.XML: "+cValToChar(aItens[nItem,nPosCol, 2])+cColorF), upper(cColorI+" Qtd.Max.:"+cValToChar(nQtdMax)+" Saldo: "+cValToChar(nSldTMP)+cColorF), lSit })

			cNCMPROT := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_POSIPI")
			nPosCol  := aScan(aValidaN[nItem], {|X| X[1]=="NCM" })
			nPColIPI := aScan(aValidaN[nItem], {|X| X[1]=="IPI" })		// Valdemir Rabelo 01/06/2021
			if  !Empty(alltrim(aValidaN[nItem, nPosCol, 2]) ) .and. (alltrim(aValidaN[nItem, nPosCol, 2]) != alltrim(cNCMPROT) )
				if SB1->( dbSeek(xFilial('SB1')+cProduto) )  // posiciono SB1
					aTMPErro := StPutNCM(aValidaN[nItem, nPosCol, 2], cPedCom, cItemPC, lJob,aValidaN[nItem, nPColIPI, 2])
					if (Len(aTMPErro) > 0)
						For nW := 1 to Len(aTMPErro)
							aAdd(aErrorLog, aTMPErro[nW])
						Next
						lError := .t.
					endif
				Endif
			endif

		endif

		nTmpQtd := 0
		if Len(aRetTMP) > 0
			//Tratando Unidade de Medida - Valdemir Rabelo 14/05/2020
			cColorI := ""
			cColorF := ""
			nPosCol := aScan(aItens[nItem], {|X| X[1]=="D1_UM" })
			if nPosCol>0
				if (cAliasTMP)->&(cUMTMP) != aItens[nItem][nPosCol][2]
					SB1->( dbSeek(xFilial('SB1')+cProduto) )
					if !Empty(SB1->B1_SEGUM)
						if (SB1->B1_SEGUM  != aItens[nItem][nPosCol][2])
							lError  := .t.
							lSit    := .F.
							cColorI := "<b><FONT COLOR=RED>"
							cColorF := "</b></FONT>"
						else
							nTmpQtd := ConvUM(cProduto, nQtdXML, 0,   2)
						endif
					else
						lError  := .t.
						lSit    := .F.
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
					Endif
				else
					lSit := .T.
				endif
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - UM XML: "+cValToChar(aItens[nItem,nPosCol, 2])), upper(cColorI+"UM Protheus: "+(cAliasTMP)->&(cUMTMP)+cColorF), .T. })
			endif

			cColorI := ""
			cColorF := ""
			nDifUnit:= 0
			nPosCol := aScan(aItens[nItem], {|X| X[1]=="D1_VUNIT" })
			if Round((cAliasTMP)->&(cPrecoTMP),4) != round(aItens[nItem][nPosCol][2],4)    // Colocado round 4, para seguir o pedido de compra que contem 4 casas decimais
				nDifUnit := ABS(Round((cAliasTMP)->&(cPrecoTMP),4) - round(aItens[nItem][nPosCol][2],4))
				if nDifUnit > 0.01        // Solicitaзгo feita por Vanessa 30/03/2021 - Valdemir Rabelo
					lError  := .t.
					lSit    := .F.
					cColorI := "<b><FONT COLOR=RED>"
					cColorF := "</b></FONT>"
				endif
			else
				lSit := .T.
			endif
			AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Vlr.Uni.XML: "+cValToChar(round(aItens[nItem,nPosCol, 2],4))), upper(cColorI+"Vlr.Unit.Protheus: "+cValToChar(round((cAliasTMP)->&(cPrecoTMP),4))+cColorF), .T. })

			nDifVlrIPI := 0
			nPosCol := aScan(aValidaN[nItem], {|X| X[1]=="D1_VALIPI" })
			if Len(aRetTMP) > 0
				(cAliasTMP)->( dbGoto(aRetTMP[1][7]) )
				lSit     := .T.
				cColorI  := ""
				cColorF  := ""
				if (aValidaN[nItem,nPosCol, 2] > round(nVlrIPI,2))
					nDifVlrIPI := (aValidaN[nItem,nPosCol, 2]-round(nVlrIPI,2))
					if  nDifVlrIPI > 0.01
						lError  := .t.
						lSit    := .F.
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
					Endif
				endif
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Valor IPI: "+cValToChar(aItens[nItem,nPosCol, 2])), upper("Valor IPI Protheus: "+cValToChar(round(nVlrIPI,2))+cColorF), lSit })
			Endif

			nPosCol := aScan(aValidaN[nItem], {|X| X[1]=="D1_VALICM" })
			if Len(aRetTMP) > 0
				(cAliasTMP)->( dbGoto(aRetTMP[1][7]) )
				lSit     := .T.
				cColorI  := ""
				cColorF  := ""
				if aValidaN[nItem, nPosCol, 2] > Round(nVlrICM,2)
					nDifVlrICM := (aValidaN[nItem,nPosCol, 2]-round(nVlrICM,2))    // Ticket: 20210415006109 Valdemir Rabelo - 27/04/2021
					if  nDifVlrICM > 0.01
						lError  := .t.
						lSit    := .F.
						cColorI := "<b><FONT COLOR=RED>"
						cColorF := "</b></FONT>"
					endif
				endif
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - Valor ICM: "+cValToChar(aItens[nItem,nPosCol, 2])), upper("Valor ICM Protheus: "+cValToChar(Round(nVlrICM,2))+cColorF), lSit })
			endif

			cNCMPROT := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_POSIPI")
			nPosCol  := aScan(aValidaN[nItem], {|X| X[1]=="NCM" })
			lSit     := .T.
			cColorI  := ""
			cColorF  := ""
			if  (alltrim(aValidaN[nItem, nPosCol, 2]) != alltrim(cNCMPROT) )
				lError  := .t.
				lSit    := .F.
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
			endif
			AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - NCM XML: "+Alltrim(aValidaN[nItem, nPosCol, 2])), upper("  NCM Protheus: "+Alltrim(cNCMPROT)+cColorF), lSit })

			nPosCol := aScan(aValidaN[nItem], {|X| X[1]=="IPI" })
			lSit := .T.
			cColorI := ""
			cColorF := ""
			if  (aValidaN[nItem, nPosCol, 2] != nPIPI )
				lError  := .t.
				lSit    := .F.
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
			endif
			IF !Empty(cPedCom)
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - IPI: "+cValToChar(aValidaN[nItem, nPosCol, 2])), upper("IPI Protheus: "+cValToChar(nPIPI)+cColorF), lSit })
			Endif

			nPosCol := aScan(aValidaN[nItem], {|X| X[1]=="ICM" })
			lSit := .T.
			cColorI := ""
			cColorF := ""
			if  (aValidaN[nItem, nPosCol, 2] != nPICM )
				lError  := .t.
				lSit    := .F.
				cColorI := "<b><FONT COLOR=RED>"
				cColorF := "</b></FONT>"
			endif
			IF !Empty(cPedCom)
				AddLogErr(aErrorLog,  {upper(cColorI+"Item: "+StrZero(nItem,4)+" - ICM: "+cValToChar(aValidaN[nItem, nPosCol, 2])), upper("ICM Protheus: "+cValToChar(nPICM)+cColorF), lSit })
			Endif

		Endif

		if Len(aRetTMP) > 0
			aAdd(aGrvPcNF,{aRetTMP[1][6], cProduto, aRetTMP[1][7], _cfopTMP})    // doc / produto / recno / CFOP
		endif

	Next

	// Valdemir Rabelo 10/03/2020
	if !lJob
		cMsgError := ""
		For nX := 1 to Len(aErrorLog)
			cMsgError += StrTran(StrTran(aErrorLog[nX][1],"<TAG>",""),"</TAG>","")+": "+StrTran(StrTran(aErrorLog[nX][2],"<TAG>",""),"</TAG>","") + CRLF
		Next
		if !Empty(cMsgError) .and. lError
			lError := (!MsgNoYes(cMsgError+CRLF+CRLF+;
				"Deseja continuar mesmo assim?","Atencao!"))
		Endif
		cMsgError := ""
	Endif

	//aGrvPcNF := {}    removido 14/05/2020
	lRET := (!lError)   // Se nao existe inconsistпїЅncia serпїЅ .T.
	cString := ""
	if lRET
		if lMsgProc
			cString := " - Com confirmaзгo de PC em branco"
		endif
		cMsgFinal := " (PRE-NOTA GERADA COM SUCESSO)"
	else
		cMsgFinal := " (PRE-NOTA NAO FOI GERADA)"
	endif

	IF !lRET
		if !lJob
			if __cUserID == cAutori    // Valida usuario autorizado a permitir geraпїЅпїЅo com validaпїЅпїЅo
				lRET := MsgNoYes("Autoriza a geracao do documento de entrada, mesmo com as validacoes apresentada?")
			Endif
		endif
	Endif

	if !lRET
		// Registro Inconsistкncias das Validaзхes
		cMSGERROR := ""
		//cMSGERROR := MntIncon(aErrorLog, 'Inconsistencias XML Nota: '+AllTrim(aCabec[4,2])+cMsgFinal)    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
		if !lGerArq
			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_ERRO  := MntIncon(aErrorLog, 'Inconsistencias XML Nota: '+AllTrim(aCabec[4,2])+cMsgFinal)    // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
			SZ9->Z9_STATUS:= 'E'
			SZ9->( MsUnlock() )
		Endif
	Endif

Return lRET



//-------------------------------------------------------------------
// Monta e envia e-mail conforme status do registro
// Nome: Valdemir Rabelo
// Data: 31/03/2020
// Retorno: nil
//-------------------------------------------------------------------
Static Function EnvMail(cEmail, _aMsg, _cTipo, pIncon)
	Local aArea     := Getarea()
	Local cMsgSt    := ""
	Local cMsg      := ""
	Local cCC       := ""
	Local _cAssunto := ""
	Local cSubject  := _cTipo
	Local CARQLOG   := "Errorlog_"+dtos(dDatabase)+StrTran(Time(),":","")+".log"
	Local _nLin
	Default pIncon  := ""

	_cAssunto := cSubject

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cColor := '#32CD32'
		if (!_aMsg[_nLin,3])
			cColor := '#FF0000'
		endif
		cMsg += '<TD><B><Font Color='+cColor+' Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color='+cColor+' Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsgError := _aMsg[_nLin,1]+": "+_aMsg[_nLin,2]
		LjWriteLog( cARQLOG, cMsgError )
	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	RestArea( aArea )

	if !Empty(pIncon)   // Valdemir Rabelo - 12/01/2021 - Ticket: 20210111000540
		return cMsg
	endif

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return

/*/{Protheus.doc} MntIncon
	description
	Rotina que monta o html para ser salvo no campo da SZ9
	Ticket: 20210111000540
	@type function
	@version  
	@author Valdemir Jose
	@since 12/01/2021
	@param aErrorLog, array, param_description
	@param _cTipo, param_type, param_description
	@return return_type, return_description
/*/
static function MntIncon(aErrorLog, _cTipo)
	if (ValType(aErrorLog)!="A")
		Return ""
	endif
Return EnvMail("", aErrorLog, _cTipo, 'I')


/*/{Protheus.doc} INCONSIS
description
Rotina que irб apresentar as Inconsistкncias
@type function
@version  
@author Valdemir Jose
@since 12/01/2021
@return return_type, return_description
/*/
USER FUNCTION INCONSIS()
	Local cErrorLog := SZ9->Z9_ERRO
	Local cArq      := "PRENF_"+SZ9->Z9_CHAVE+".htm"
	Local cPath     := "C:\TEMP\"

	if Empty(cErrorLog)
		FWMsgRun(,{|| sleep(3000)},"Informaзгo!","Nгo existem inconsistкncias a serem apresentadas")
		Return
	Endif

	if !("<HTML>" $ Left(upper(cErrorLog),10))
		MsgInfo("Esta inconsistкncia foi gravada por uma rotina antiga ou do padrгo."+CRLF+;
			"Por favor, utilize a opзгo de visualizar, campo: Msg.Erro","Informativo")
		Return
	Endif

	if File(cPath+cArq)
		fErase(cPath+cArq)
	endif

	// Ajustado devido a ter ocorrido problemas com Memowrite devido a quantidade
	// de caracteres - Valdemir Rabelo 31/03/2021
	nHdlHml   := FCreate(cPath+cArq,0)
	If nHdlHml > 0
		FWrite(nHdlHml,cErrorLog)
		FClose(nHdlHml)
	Endif

	if File(cPath+cArq)
		ShellExecute("OPEN", cPath+cArq, "", "", 1)
	endif

RETURN

/*/{Protheus.doc} JOBPRENF
description
Rotina de geraзгo de pre-nota automatico
Ticket: 20201118010751
@type function
@version 
@author Valdemir Jose
@since 14/12/2020
@return return_type, return_description
u_JOBPRENF
/*/
User Function JOBPRENF(pEmpresa, pFilial, pChave)
	Local aEmpFil    := {}
	Local nX         := 0
	Default pEmpresa := ""
	Default pFilial  := ""
	Default pChave   := ""

	if Empty(pEmpresa)
		//aAdd(aEmpFil, {'01','01'})          // Empresa: 01
		//---aAdd(aEmpFil, {'01','02'})
		//aAdd(aEmpFil, {'01','03'})
		//aAdd(aEmpFil, {'01','04'})
		aAdd(aEmpFil, {'01','05'})
		//---aAdd(aEmpFil, {'03','01'})          // Empresa: 03
		//aAdd(aEmpFil, {'03','02'})
	Endif

	Conout("* INICIO LEITURA - PROCURA DE REGISTROS PARA GERAЗГO PRE NOTA VIA JOB (JOBPRENF)  *")
	if Empty(pEmpresa)
		For nX := 1 to Len(aEmpFil)
			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(aEmpFil[nX][1],aEmpFil[nX][2],,,,GetEnvServer(),{ "SF1","SD1","SD3","SDA","SB2","SB1","SBF","SZ9" } )
			SetModulo("SIGACOM","COM")

			if File('jobprenf'+cEmpAnt+cFilAnt+'.txt')
				fErase('jobprenf'+cEmpAnt+cFilAnt+'.txt')
			endif

			if !LockByName("ProcesZ9",.f.,.f.,.t.)
				Conout('A rotina estб sendo executada por outro processo')
				Return()
			endif
			Conout(" (JOBPRENF) Processando Empresa: "+cEmpAnt+" Filial: "+cFilAnt)
			// Inicia Processo
			ProcesZ9()

			UnLockByName("ProcesZ9",.F.,.F.,.T.)

			RpcClearEnv()

		Next
	else
		ProcesZ9(pChave)
	Endif

	Conout("*      TERMINO LEITURA JOB (JOBPRENF)                             *")

Return



/*/{Protheus.doc} 
description
@type function
@version  
@author Valdemir Jose
@since 22/02/2021
@return return_type, return_description
/*/
User Function EXEPRENF(oBrwXml, pChave)
	Local nREG := SZ9->( RECNO() )
	Default pChave=""

	FWMsgRun(, {|| U_JOBPRENF(cEmpAnt, cFilAnt, pChave) },"Aguarde..."," Processando automatizaзгo")

	SZ9->(dbClearFilter())
	SZ9->( dbGoBottom() )
	SZ9->( dbGoTop() )
	SZ9->( dbGoto(nREG) )

	oBrwXml:Refresh()
Return


/*/{Protheus.doc} ProcesZ9
description
@type function
Rotina que gera pre nota com base na tabela SZ9
Ticket: 20201118010751
@version 
@author Valdemir Jose
@since 14/12/2020
@return return_type, return_description
/*/
Static Function ProcesZ9(pChave)
	Local cQry      := getMntQry(pChave)
	Local aAreaZ9   := GetArea()
	Local cARQLOG   := 'jobprenf'+cEmpAnt+cFilAnt+'.txt'
	Local lVldSped  := GETMV("ST_VLDSPED",.F.,.T.)   // Valdemir Rabelo 26/08/2021 Ticket: 20210817016042
	Local cMsgError := ""
	Local cUf       := ""
	Local cCNPJ     := ""
	Local nInd      := 1
	Private aErrorLog := {}
	Default pChave  := ""

	dbSelectArea("SZ9")

	if (Select('TZ9') > 0)
		TZ9->( dbCloseArea() )
	endif
	tcQuery cQry new alias "TZ9"

	While TZ9->( !Eof() )

		SZ9->( dbGoto(TZ9->REG) )
		cMsgError := "Processando SZ9 Origem: "+cValToChar(SZ9->Z9_ORIGEM)+" CNPJ: "+SZ9->Z9_CNPJ+" DOC: "+SZ9->Z9_DOC+" CHAVE: "+SZ9->Z9_CHAVE
		LjWriteLog( cARQLOG, cMsgError )
		if lVldSped			// Valdemir Rabelo 26/08/2021 Ticket: 20210817016042
			if u_STXMLVLD(SZ9->Z9_CHAVE, .t.)     // Valdemir Rabelo 12/07/2021
				U_EXECPREN(.T., aErrorLog)
			endif
		else
			U_EXECPREN(.T., aErrorLog)
		endif

		TZ9->( dbSkip() )
	EndDo

	TZ9->( dbCloseArea() )

	RestArea( aAreaZ9 )

Return



/*/{Protheus.doc} getMntQry
description
Ticket: 20201118010751
@type function
@version 
@author Valdemir Jose
@since 16/12/2020
@return return_type, return_description
/*/
Static Function getMntQry(pChave)
	Local  cRET := ""
	Default pChave := ""

	cRET += "SELECT R_E_C_N_O_ REG " + CRLF
	cRET += "FROM " + RETSQLNAME("SZ9") + " SZ9  " + CRLF
	cRET += "WHERE SZ9.D_E_L_E_T_ = ' '          " + CRLF
	cRET += " AND Z9_FILIAL='"+XFILIAL('SZ9')+"' " + CRLF
	cRET += " AND (SZ9.Z9_STATUS <> 'X'          " + CRLF
	//cRET += " AND SZ9.Z9_STATUS <> '2'           " + CRLF
	cRET += " AND SZ9.Z9_STATUS <> '3'           " + CRLF      // Ticket: 20210420006345 - Valdemir Rabelo 29/04/2021
	cRET += " AND SZ9.Z9_STATUS <> '1'           " + CRLF      // Ticket: 20210601009174 - Valdemir Rabelo 02/06/2021
	cRET += " AND SZ9.Z9_STATUS <> '8'           " + CRLF      // Ticket: 20210601009174 - Valdemir Rabelo 02/06/2021
	cRET += " AND SZ9.Z9_STATUS <> '9'           " + CRLF      // Ticket: 20210601009174 - Valdemir Rabelo 02/06/2021
	cRET += " AND SZ9.Z9_DOC=' ' )               " + CRLF
    //pChave := "35211002949991000189550010000563971875371180"
	//cRET += " OR (Trim(SZ9.Z9_ORIGEM) = 'NF-E'  " + CRLF
	//cRET += " AND SZ9.Z9_DOC=' '))              " + CRLF
	//cRET += " AND Upper(Trim(SZ9.Z9_STATUSA)) <> 'NF CANCELADA' " + CRLF
	//cRET += " OR (Trim(SZ9.Z9_ORIGEM) = 'NFS-E' " + CRLF
	//cRET += " AND SZ9.Z9_DOC=' '))              " + CRLF
	cRET += " AND SZ9.Z9_CHAVE='"+pChave+"'"   // Ticket:  Valdemir Rabelo 02/09/2021

Return cRET

/*/{Protheus.doc} getPC2
description
Ticket: 20201118010751
@type function
@version 
@author Valdemir Jose
@since 16/12/2020
@param pcNFORIG, param_type, param_description
@param pcSERIE, param_type, param_description
@return return_type, return_description
/*/
Static Function getPC2(pcNFORIG, pcSERIE)
	Local cRET := ""
	Local cQry := ""
	Local aAreaPC2 := GetArea()

	cQry := "SELECT PC2_NFATEC " + CRLF
	cQry += "FROM " + RETSQLNAME("PC2") + " PC2 " + CRLF
	cQry += "WHERE PC2.D_E_L_E_T_ = ' '" + CRLF
	cQry += " AND PC2.PC2_NFORIG='"+pcNFORIG+"' " + CRLF
	cQry += " AND PC2.PC2_SERIE='"+pcSERIE+"'   " + CRLF
	IF SELECT("TPC2") > 0
		TPC2->( dbCloseArea() )
	ENDIF
	TcQuery cQry new alias "TPC2"

	if TPC2->( !Eof() )
		cRET := TPC2->PC2_NFATEC
	Endif

	TPC2->( dbCloseArea() )

	Restarea( aAreaPC2 )

Return cRET


/*/{Protheus.doc} getVldPC
description
@type function
@version  
@author Valdemir Jose
@since 21/01/2021
@param cNumPC, character, param_description
@param cITPEDC, character, param_description
@return return_type, return_description
/*/
Static Function getVldPC(cNumPC, cITPEDC, nQtdXML, aErrorLog, nQtdMin, nQtdMax)
	Local lRET  := .T.
	Local cMsg  := ""
	Local aArea := GetArea()
	Default nQtdXML := 0
	Default nQtdMin := 0
	Default nQtdMax := 0

	if (Empty(cNumPC) .or. (cNumPC=='000000')) .or. (Empty(cITPEDC) .or. (cITPEDC=='0000'))
		return .F.
	endif

	dbSelectArea("SC7")
	SC7->( dbSetOrder(14) )
	lRET  :=  SC7->( dbSeek(xFilial('SC7')+cNumPC+cITPEDC) )
	if lRET
		if nQtdXML > 0
			nSaldoSD1 := getSldSD1(cNumPC, cITPEDC)
			lRET := (SC7->C7_QUANT > 0 .and. SC7->C7_QUANT <= nQtdMax)           // Verificar aqui
			IF lRET
				lRET := ((nSaldoSD1+nQtdXML) > 0) .and. ((nSaldoSD1+nQtdXML) <= nQtdMax)
				if !lRET
					cColorI := "<b><FONT COLOR=RED>"
					cColorF := "</b></FONT>"
					cMsg    := cMsg := "Pedido: "+cNumPC+" Item: "+cITPEDC+" Quantidade fora da tolerвncia permitida Qtde.XML: "+cValToChar(nQtdXML)+" Qtd.Max.: "+cValToChar(nQtdMax)+" Qtd.Pre Nota: "+cValToChar(nSaldoSD1)
					AddLogErr(aErrorLog,  {upper("Item: "+cITPEDC+" Fora Tolerancia"), upper(cColorI+cMsg+cColorF),.F.})
				Endif
			Endif
		endif
	Endif

	RestArea( aArea )

Return lRET

/*/{Protheus.doc} getSldSD1
description
Rotina que irб calcular a quantidade de itens jб em pre notas
@type function
@version  
@author Valdemir Jose
@since 02/02/2021
@param cNumPC, character, param_description
@param cITPEDC, character, param_description
@return return_type, return_description
/*/
Static Function getSldSD1(cNumPC, cITPEDC)
	Local nRet   := 0
	Local aAreaQ := GetArea()
	Local cQry   := ""

	cQry += "SELECT SUM(D1_QUANT) REG " + CRLF
	cQry += "FROM " + RETSQLNAME("SD1") + " D1 " + CRLF
	cQry += "WHERE D1.D_E_L_E_T_ = ' '    " + CRLF
	cQry += " AND D1_FILIAL='"+XFILIAL('SD1')+"'  " + CRLF
	cQry += " AND D1_PEDIDO='"+cNumPC+"'  " + CRLF
	cQry += " AND D1_ITEMPC='"+cITPEDC+"' " + CRLF

	IF SELECT("TD1") > 0
		TD1->( dbCloseArea() )
	Endif
	tcQuery cQry New Alias "TD1"

	if TD1->( !Eof() )
		nRet := TD1->REG
	endif

	IF SELECT("TD1") > 0
		TD1->( dbCloseArea() )
	Endif

	RestArea( aAreaQ )

Return nRet


/*/{Protheus.doc} AddLogErr
description
Rotina de tratar Erro
@type function
@version  
@author Valdemir Jose
@since 20/02/2021
@param aErrorLog, array, param_description
@param aErr, array, param_description
@return return_type, return_description
/*/
Static Function AddLogErr(aErrorLog, aErr)
	if Len(aErrorLog) <= 500  // 50
		if (aScan(aErrorLog, {|X| alltrim(X[1])=Alltrim(aErr[1])})==0)
			aAdd(aErrorLog,  aErr)
		endif
	endif
Return


/*/{Protheus.doc} getPesqA5
description
@type function
@version  
@author Valdemir Jose
@since 24/02/2021
@param pFORNEC, param_type, param_description
@param pLOJA, param_type, param_description
@param pPRODUTO, param_type, param_description
@param pTIPO, param_type, param_description
@return return_type, return_description
/*/
Static Function getPesqA5(pFORNEC,pLOJA,pPRODUTO,pTIPO)
	Local aAreaA5 := getArea()
	Local nREG    := 0
	Local cQry    := ""
	Local lRET

	cQry += "SELECT R_E_C_N_O_ REG " + CRLF
	cQry += "FROM "+RETSQLNAME("SA5")+" A    " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' '        " + CRLF
	cQry += " AND A.A5_XBLOQ <> 'S'          " + CRLF       // IN('A','B')   Removido devido a problemas que estavam ocorrendo com situaзгo C  17/03/2021
	cQry += " AND A.A5_FILIAL='"+XFILIAL('SA5')+"' " + CRLF
	cQry += " AND A.A5_FORNECE='"+pFORNEC+"' " + CRLF
	cQry += " AND A.A5_LOJA='"+pLOJA+"'      " + CRLF
	IF (pTIPO=="P")
		cQry += " AND A.A5_PRODUTO='"+pPRODUTO+"' " + CRLF
	Else
		cQry += " AND A.A5_CODPRF='"+pPRODUTO+"'  " + CRLF
	Endif
	cQry += "ORDER BY A5_SITU "         // Adicionado a Ordem sempre para pegar o primeiro que sera "A"

	if Select("TSA5") > 0
		TSA5->( dbCloseArea() )
	Endif

	tcQuery cQry New Alias "TSA5"


	IF TSA5->( !EOF() )
		lRET    := .T.
		nREG    := TSA5->REG
		cSitSA5 := ""
	Endif


	if Select("TSA5") > 0
		TSA5->( dbCloseArea() )
	Endif

	RestArea( aAreaA5 )

	if nREG > 0
		SA5->( dbGoto(nREG) )
		IF (pTIPO=="P")						// Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
			lRET := nREG
		else
			lRET := (!EMPTY(SA5->A5_PRODUTO)) .AND. (!EMPTY(SA5->A5_CODPRF))    // Valdemir Rabelo 22/06/2021 20210622010576
		endif
	else
		// Realizado ajuste Ticket: 20210802014429 - Valdemir Rabelo
		if pTIPO=="F"
			lRET := .F.
		else
			lRET := 0
		endif
	Endif

Return lRET

/*/{Protheus.doc} getCFOPCPC
description
Rotina que valida CFOP com Pedido Compra
@type function
@version  
@author Valdemir Jose
@since 24/02/2021
@param pCFOP, param_type, param_description
@return return_type, return_description
/*/
Static Function getCFOPCPC(pCFOP)
	Local lRET  := .F.
	Local cCFOP := "1101/2101/2102/1124/2124/1405/1406/2406/1407/2407/2551/1556/2556/1653/2653/2109/2110/1102/2102"

	lRET := (pCFOP $ cCFOP)

Return lRET

/*/{Protheus.doc} getCFOPNFO
description
Rotina que Valida CFOP Nota Fiscal Origem
@type function
@version  
@author Valdemir Jose
@since 24/02/2021
@param pCFOP, param_type, param_description
@return return_type, return_description
/*/
Static Function getCFOPNFO(pCFOP)
	Local lRET  := .F.
	Local cCFOP := "1902/2902"   // /1903/2903/1916/2916/1909/2909/1913/2913 - Removido conforme solicitaзaх Verфnica 24/02/2021 - 16:28

	lRET := (pCFOP $ cCFOP)

Return lRET


static function gPos(paCampos,pCampo)
	Local nPosRET := aScan(paCampos, {|X| alltrim(X[1])==alltrim(pCampo) })
Return nPosRET



/*/{Protheus.doc} GetCTNCM
description
Rotina que verifica se existe mais de um registro com mesmo posipi
@type function
@version  
@author Valdemir Jose
@since 29/03/2021
@param pcNCM, param_type, param_description
@return return_type, return_description
/*/
Static function GetCTNCM(pcNCM,pIPI)
	Local aZ4    := GetArea()
	Local lRET   := .F.
	Local nRET   := 0
	Local cQry   := ""
	Default pIPI := 0

	//cQry += "SELECT COUNT(*) REG " + CRLF
	cQry += "SELECT R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("SZ4") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_= ' ' " + CRLF
	cQry += " AND A.Z4_FILIAL='" + XFILIAL("SZ4") + "' " + CRLF
	cQry += " AND A.Z4_POSIPI='" + pcNCM + "' " + CRLF
	if pIPI > 0				// Valdemir Rabelo 01/06/2021
		cQry += " AND A.Z4_IPI= " + cValToChar(pIPI) + " " + CRLF
	endif
	cQry += "ORDER BY Z4_FILIAL, Z4_GATCLAS, Z4_POSIPI" + CRLF

	IF SELECT("TZ4") > 0
		TZ4->( dbCloseAre() )
	ENDIF
	tcQuery cQry New Alias "TZ4"

	if TZ4->( !eof() )
		nRET := TZ4->REG
		lRET := (nRET > 0)
	endif

	IF SELECT("TZ4") > 0
		TZ4->( dbCloseAre() )
	ENDIF

	RestArea( aZ4 )

	if nRET > 0
		SZ4->( dbGoto(nRET) )
	Endif

Return lRET


/*/{Protheus.doc} StPutNCM
description
Rotina que irб verificar se precisa atualizar o NCM
Ticket: 20210326004951
@type function
@version  
@author Valdemir Jose
@since 29/03/2021
@param cNCM, character, param_description
@return return_type, return_description
/*/
Static Function StPutNCM(cNCM, pPedido, pItem, lJob, pIPI )
	Local aRET := {}
	Local lNCM := .T.
	Local aEnv := {}
	Default pPedido := ""
	Default pItem   := ""
	Default pIPI    := 0

	dbSelectArea("SZ4")
	dbSetOrder(2)
	if dbSeek(xFilial("SZ4")+cNCM)
		lNCM   := GetCTNCM(cNCM, pIPI)
		if lNCM

			If (ALLTRIM(SB1->B1_XGATCL) != ALLTRIM(SZ4->Z4_GATCLAS))
				aAdd(aEnv, {"Letra Class DE: "+SB1->B1_XGATCL, "PARA: "+SZ4->Z4_GATCLAS})
			Endif
			if (alltrim(SB1->B1_POSIPI) != alltrim(SZ4->Z4_POSIPI))
				aAdd(aEnv, {"NCM DE: "+SB1->B1_POSIPI, "PARA: "+SZ4->Z4_POSIPI})
			endif
			if (SB1->B1_IPI != SZ4->Z4_IPI)
				aAdd(aEnv, {"IPI DE: "+cValToChar(SB1->B1_IPI), "PARA: "+cValToChar(SZ4->Z4_IPI)})
			Endif
			if (alltrim(SB1->B1_GRTRIB) != alltrim( IIF(SB1->B1_ORIGEM$"0/4/5", SZ4->Z4_GRTRIB, IIF(SB1->B1_ORIGEM$"1/2/3/8", SZ4->Z4_GRTRIB1,"")) ))
				aAdd(aEnv, {"Grupo Trib DE: "+SB1->B1_GRTRIB, "PARA: "+IIF(SB1->B1_ORIGEM$"0/4/5", SZ4->Z4_GRTRIB, IIF(SB1->B1_ORIGEM$"1/2/3/8", SZ4->Z4_GRTRIB1,""))})
			endif
			if ( alltrim(SB1->B1_CEST) != alltrim(u_xGetCest(SZ4->Z4_POSIPI)) )
				aAdd(aEnv, {"Cod.Espec.ST DE: "+SB1->B1_CEST, "PARA: "+u_xGetCest(SZ4->Z4_POSIPI)})
			endif
			RecLock("SB1",.F.)
			SB1->B1_XGATCL := SZ4->Z4_GATCLAS
			SB1->B1_POSIPI := SZ4->Z4_POSIPI
			SB1->B1_IPI    := SZ4->Z4_IPI
			SB1->B1_GRTRIB := IIF(SB1->B1_ORIGEM$"0/4/5", SZ4->Z4_GRTRIB, IIF(SB1->B1_ORIGEM$"1/2/3/8", SZ4->Z4_GRTRIB1,""))
			SB1->B1_CEST   := u_xGetCest(SZ4->Z4_POSIPI)
			SB1->( MSUnLock() )

			if Len(aEnv) > 0
				LogNCM(aEnv, lJob)
			Endif

			// Ajusto Pedido
			if (!Empty(pPedido) .and. !Empty(pItem))
				SC7->( dbSetOrder(1))
				lAchou := SC7->( dbSeek(xFilial('SC7')+pPedido+pItem) )
				if lAchou
			/*
			    Removido esta atuaqlizaзгo do pedido por solicitaзгo da Verфnica na reuniгo de ontem 04/05/2021
						RecLock('SC7', .F.)
						SC7->C7_IPI    := SB1->B1_IPI
					IF SB1->B1_IPI > 0
							SC7->C7_VALIPI := ((SC7->C7_TOTAL * SB1->B1_IPI) / 100)
					Endif
						MsUnlock()
			*/
				endif
			endif
		else
			AddLogErr(aRET, {upper("NCM: "+cNCM), upper("NCM: "+cNCM+" IPI: "+cValToChar(pIPI)+" estгo divergemtes com XML."),.F.})
		endif
	else
		AddLogErr(aRET, {upper("NCM: "+cNCM), upper("NCM: "+cNCM+" nгo encontrado na tabela. (SZ4-CLASSIFICACOES FISCAIS)"),.F.})
	endif

Return aRET


/*/{Protheus.doc} LogNCM
description
Rotina para Log dos campos alterados
@type function
@version  
@author Valdemir Jose
@since 05/05/2021
@param aEnv, array, param_description
@return return_type, return_description
/*/
Static Function LogNCM(paEnv, lJOB)
	Local aArea     := Getarea()
	Local cHist     := ""
	Local aEnv      := aClone(paEnv)
	Local _nLin

	cHist := ""
	For _nLin := 1 to Len(aEnv)
		cHist := "Produto: "+alltrim(SB1->B1_COD)+" "+aEnv[_nLin,1]+ " - " + aEnv[_nLin,2] + " ("+iif(lJOB, "AUT","MAN")+")"
		u_STCFG01(SB1->B1_COD,"Z9", cHist, cChvNfe)
	Next

	// Envia WF
	EnvNCM(aEnv, lJOB)

Return


/*/{Protheus.doc} EnvNCM
description
Rotina para enviar WF apresentando os campos alterados
@type function
@version  
@author Valdemir Jose
@since 05/05/2021
@param aEnv, array, param_description
@return return_type, return_description
/*/
Static Function EnvNCM(paEnv, plJOB)
	Local aArea     := Getarea()
	Local cMsg      := ""
	Local aEnv      := aClone(paEnv)
	Local cCC       := ""
	Local _aMsg     := {}
	Local _cAssunto := ""
	Local cSubject  := "NCM - Alteraзгo de Campos da (SB1)"
	Local cEmail    := ""
	Local _nLin
	Local _xNota     := Substr(cChvNfe,23,12)

	aAdd(_aMsg, {"Produto", SB1->B1_COD } )
	aAdd(_aMsg, {"Descriзгo", alltrim(SB1->B1_DESC) } )
	aAdd(_aMsg, {"Data", dtoc(dDatabase)} )
	aAdd(_aMsg, {"Hora", Time() } )
	aAdd(_aMsg, {"Gerado", if(plJOB, "Automбtico","Manual")})
	aAdd(_aMsg, {"", "" } )
	aAdd(_aMsg, {"Nota Fiscal", if(Empty(cNumNF),_xNota,cNumNF) } )
	aAdd(_aMsg, {"CAMPOS ALTERADOS", "" } )

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		if _nLin == Len(_aMsg)
			cMsg += '<TD><B><Font Color=#FF0000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		else
			cMsg += '<TD><B>' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		endif
		cMsg += '<TD>' + _aMsg[_nLin,2] + ' </Font></TD>'
	Next
	//A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(aEnv)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><B>' + aEnv[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD>' + aEnv[_nLin,2] + ' </Font></TD>'
	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	cNumNF  := ""

	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return

/*/{Protheus.doc} GetRecF2
description
Rotina para localizar a nota de saнda
@type function
@version  
@author Valdemir Jose
@since 24/09/2021
@param cREFNF, character, param_description
@return variant, return_description
/*/
Static Function GetRecF2(cREFNF)
	Local nRET := 0
	Local aSF2 := GetArea()
	Local cQry := ""

	cQry := "SELECT R_E_C_N_O_ REG " + CRLF 
	cQry += "FROM " + RETSQLNAME("SF2") + " SF2 " + CRLF 
	cQry += "WHERE SF2.D_E_L_E_T_ = ' ' " + CRLF  
	cQry += " AND SF2.F2_FILIAL = '"+XFILIAL("SF2") + "' " + CRLF 
	cQry += " AND SF2.F2_CHVNFE='" + cREFNF + "' " + CRLF 

	if Select("TF2") > 0
	   TF2->( dbCloseArea() )
	endif 
	TcQuery cQry New Alias "TF2"

	if !TF2->( Eof() )
		nRET := TF2->REG
	endif 

	if Select("TF2") > 0
	   TF2->( dbCloseArea() )
	endif 

	RestArea( aSF2 )

Return nRET
