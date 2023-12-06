#Include "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} ARFATVEI

Informar o codigo do veiculo

@type function
@author Everson Santana
@since 07/02/18
@version Protheus 12 - Faturamento

@history , ,

/*/

User Function ARFATVEI()

	Local _cVersao := '20180807'
	Local _cVeic  := SF2->F2_VEHICL
	Local _cPlaca := ""
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
	DEFINE MSDIALOG _oDlg TITLE "Incluir Plava Vehículo - "+_cVersao FROM 000, 000  TO 150, 200 COLORS 0, 16777215 PIXEL

	_oSay	:= TSay():New(010,010,{||'Codigo Placa:'},_oDlg,,,,,,.T.,,,060,20)
	_oTGet  := TGet():New(020,010,{| u | if( pCount() > 0,_cVeic := u, _cVeic ) },_oDlg,080,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"DA3ARG",_cVeic,,,, )
	//_oTGet  := TGet():New(020,060,{| u | if( pCount() > 0,_cPlaca := u, _cPlaca ) },_oDlg,100,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_cPlaca,,,, )

	_oTButCon:= TButton():New( 050, 010, "Confirmar" ,_oDlg,{|| _nOpc := 1,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButFec:= TButton():New( 050, 055, "Fechar",_oDlg,{|| _nOpc := 0,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc == 1 

		DbSelectArea("SF2")
		RecLock("SF2",.f.)
		SF2->F2_VEHICL := _cVeic
		MsUnLock("SF2")
	EndIf

Return