#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM160        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Enviar para aprovação digital	 					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM160()

	Local _aAreaSC1 		:= SC1->(GetArea())
	Local _cFilSC			:= SC1->C1_FILIAL
	Local _cNumSC			:= SC1->C1_NUM
	Local _cQuery1  		:= ""
	Local _cAlias1  		:= GetNextAlias()
	Local _lProc			:= .F.
	Local _aHeader		:= {}
	Local _aCols		:= {}
	Local lSaida   		:= .T.
	Local lConfirma 	:= .F.
	Local nY:= 0
	Local _nX:= 0
	Local _oWindow,;
	oFontWin,;
	_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
	_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
	_aButtons	    	:= {},_oGet
	Private	_aRet 			:= {}
	Private	_aParamBox 		:= {}	

	If !(__cUserId $ AllTrim(GetMv("STCOM1601",,"000000#000010")))
		MsgAlert("Rotina não disponível para o seu usuário, verifique!")
		Return
	EndIf

	If !(AllTrim(SC1->C1_ZSTATUS)=="3") .Or. !Empty(SC1->C1_COTACAO)
		MsgAlert("Cotação não está com status pendente, verifique!")
		Return
	EndIf

	Aadd(_aHeader,{"Mar/Des"							,"MARKBROW"			    ,"@BMP"				,2	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Item"								,"C1_ITEM"		    	,"@!"				,TamSx3("C1_ITEM")[1]	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Produto"							,"C1_PRODUTO"	    	,"@!"				,TamSx3("C1_PRODUTO")[1]	  ,0    ,"",,"C",""})
	Aadd(_aHeader,{"Qtde"								,"C1_QUANT"		    	,"@E"				,TamSx3("C1_QUANT")[1]	  ,TamSx3("C1_QUANT")[2]    ,"",,"N",""})
	Aadd(_aHeader,{"Descrição"							,"C1_DESCRI"	    	,"@!"				,TamSx3("C1_DESCRI")[1]	  ,0    ,"",,"C",""})

	SC1->(DbSetOrder(1))
	SC1->(DbSeek(_cFilSC+_cNumSC))

	While SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM)==_cFilSC+_cNumSC

		AADD(_aCols,Array(Len(_aHeader)+1))

		For nY := 1 To Len(_aHeader)

			DO CASE

				CASE AllTrim(_aHeader[nY][2]) =  "MARKBROW"
				_aCols[Len(_aCols)][nY] := "LBNO"
				CASE AllTrim(_aHeader[nY][2]) =  "C1_ITEM"
				_aCols[Len(_aCols)][nY] := SC1->C1_ITEM
				CASE AllTrim(_aHeader[nY][2]) =  "C1_PRODUTO"
				_aCols[Len(_aCols)][nY] := SC1->C1_PRODUTO
				CASE AllTrim(_aHeader[nY][2]) =  "C1_QUANT"
				_aCols[Len(_aCols)][nY] := SC1->C1_QUANT
				CASE AllTrim(_aHeader[nY][2]) =  "C1_DESCRI"
				_aCols[Len(_aCols)][nY] := SC1->C1_DESCRI

			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

		SC1->(DbSkip())
	EndDo

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 300,800/*500,1200*/ TITLE Alltrim(OemToAnsi('Selecionar itens')) Pixel //430,531
	_oGet1	:= MsNewGetDados():New(030,000,_oWindow:nClientHeight/2-5,_oWindow:nClientWidth/2-5,GD_UPDATE,,,,{'MARKBROW'},,Len(_aCols),,,,_oWindow,_aHeader,_aCols)
	bDbClick := _oGet1:oBrowse:bLDblClick
	_oGet1:oBrowse:bLDblClick := {|| (Iif(_oGet1:aCols[_oGet1:nAt,1]=="LBNO",_oGet1:aCols[_oGet1:nAt,1]:="LBOK",_oGet1:aCols[_oGet1:nAt,1]:="LBNO"),_oGet1:oBrowse:Refresh(),"")}
	_oGet1:SetArray(_aCols)
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

	If lConfirma	

		AADD(_aParamBox,{1,"Aprovador 1" ,Space(25),"","U_STCOM161()","GETUSR","",0,.F.})
		AADD(_aParamBox,{1,"Aprovador 2" ,Space(25),"","U_STCOM161()","GETUSR","",0,.F.})

		If !ParamBox(_aParamBox,"Aprovadores",@_aRet,,,.T.,,500)
			Return
		EndIf

		SC1->(DbSetOrder(1))
		SC1->(DbSeek(_cFilSC+_cNumSC))

		For _nX:=1 To Len(_oGet1:aCols)
			If _oGet1:aCols[_nX][1]=="LBOK"
				If SC1->(DbSeek(_cFilSC+_cNumSC+_oGet1:aCols[_nX][2]))

					SC1->(RecLock("SC1",.F.))
					If !Empty(MV_PAR01)
						SC1->C1_XSTAP1  := "P"
						SC1->C1_XAPROV1 := MV_PAR01
						_cEmail := UsrRetMail(__cUserId)
					EndIf 
					If !Empty(MV_PAR02)
						SC1->C1_XSTAP2  := "P"
						SC1->C1_XAPROV2 := MV_PAR02
						_cEmail := UsrRetMail(__cUserId) 
					EndIf
					
					SC1->C1_XSTAPRO := "P"
					
					SC1->(MsUnLock())

					_lProc := .T.

				EndIf
			EndIf
		Next _nX

	EndIf

	If _lProc

		_cAssunto := "[WFPROTHEUS] - Você possui novas aprovações para analisar
		_cCopia   := ""
		cAttach   := ""

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += 'Olá <b>'+Alltrim(UsrRetName(__cUserId))+'</b>,<br><br>
		cMsg += 'Acesse o aplicativo da Steck na opção de aprovações para analisar suas solicitações pendentes.<br> 
		cMsg += 'Obrigado!<br><br>

		cMsg += 'Atenciosamente,<br>
		cMsg += 'Steck Indústria Elétrica Ltda

		cMsg += '</body></html>'

		U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)

		MsgAlert("Solicitação de aprovação enviada com sucesso!")

	EndIf

	RestArea(_aAreaSC1)

Return()

/*====================================================================================\
|Programa  | STCOM161        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM161()

	Local _lRet := .T.

Return(_lRet)