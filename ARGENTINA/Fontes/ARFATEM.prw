#Include "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} ARFATEM

Informar atualiza data de emissão do remito

@type function
@author Everson Santana
@since 08/08/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARFATEM()

	Local _cVersao := '2018080'
	Local _cEmis  := Dtoc(SF2->F2_EMISSAO)
	Local _cRemel :=SF2->F2_FLREMEL
	Local _nOpc	 := 0
	Local _oDlg
	Local _cUser	 := RetCodUsr()
	Local _lEdtBar := .T.  
	Private _oSay
	Private _oTGet
	Private _oTButCon
	Private _oTButFec

	If _cRemel $ 'E'
		MsgAlert("Remito Autorizado","Atención")
		Return
	EndIf 	
	DEFINE MSDIALOG _oDlg TITLE "Cambio Fecha de Emisión - "+_cVersao FROM 000, 000  TO 150, 200 COLORS 0, 16777215 PIXEL

	_oSay	:= TSay():New(010,010,{||'Fecha de Emisión:'},_oDlg,,,,,,.T.,,,060,20)
	_oTGet  := TGet():New(020,010,{| u | if( pCount() > 0,_cEmis := u, _cEmis ) },_oDlg,080,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_cEmis,,,, )

	_oTButCon:= TButton():New( 050, 010, "Confirmar" ,_oDlg,{|| _nOpc := 1,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButFec:= TButton():New( 050, 055, "Fechar",_oDlg,{|| _nOpc := 0,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc == 1 

		DbSelectArea("SF2")
		RecLock("SF2",.f.)
		SF2->F2_EMISSAO := Ctod(_cEmis)
		MsUnLock("SF2")
	EndIf

Return