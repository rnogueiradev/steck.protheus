#INCLUDE "PROTHEUS.CH"

#DEFINE ID_USER_ADMINISTRATOR "000000"

#DEFINE APSDET_USER_ID		aPswDet[01][01]
#DEFINE APSDET_USER_NAME	aPswDet[01][02]
#DEFINE APSDET_USER_GROUPS	aPswDet[01][03]
#DEFINE APSDET_USER_MENUS	aPswDet[01][04]

User Function RelaUsers()

	Local oReport

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2

	oReport := TReport():New("RelaUsers","RELATำRIO DE USUมRIOS",,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de usuแrios.")

	oSection := TRSection():New(oReport,"USUมRIOS",{"TRB"})

	TRCell():New(oSection,"ID","TRB","USER ID",,6)
	TRCell():New(oSection,"USER","TRB","USERNAME",,25)
	TRCell():New(oSection,"DEPTO","TRB","DEPTO NAME",,30)
	TRCell():New(oSection,"NDEPTO","TRB","NUM DEPTO",,6)
	TRCell():New(oSection,"NOMEDEPTO","TRB","NOME DEPTO",,28)
	TRCell():New(oSection,"RETROC","TRB","RETROCEDER",,4)
	TRCell():New(oSection,"AVANC","TRB","AVANวAR",,4)
	TRCell():New(oSection,"TROCADT","TRB","TROCA DATA",,1)
	TRCell():New(oSection,"PRIORIZAR","TRB","PRIORIZA GRUPO?",,1)
	TRCell():New(oSection,"PRIORIZAR1","TRB","PRIORIZA GRUPO?",,1)

	oSection2 := TRSection():New(oReport,"USUมRIOS",{"TRB"})

	TRCell():New(oSection2,"MENU","TRB","MENUS",,50)
	TRCell():New(oSection2,"MENUUSR","TRB","USUARIO",,25)

	oSection:SetHeaderSection(.T.)
	oSection2:SetHeaderSection(.T.)

Return oReport

Static Function ReportPrint(oReport)

	Local oSection				:= oReport:Section(1)
	Local oSection2				:= oReport:Section(2)
	Local nX					:= 0
	Local nZ					:= 0
	Local aDados[10]
	Local aDados1[2]
	Local aPswDet
	Local cPswFile				:= "sigapss.spf"
	Local lEncrypt 				:= .F.
	Local aUsuarios				:= {}
	Local aGrupos 				:= {}
	Local oReport
	Local oSection
	Local oSection2
	Local cGrupo
	Local cDados1
	Local cNameUsr
	Local _cPrioriza1
	Local cUserID 				:= RetCodUsr()
	Local cLinha  				:= ""
	Local lPrim   				:= .T.
	Local aCampos 				:= {}
	Local cDir	  				:= "C:\"
	Local n		  				:= 0
	Local nW := 0
	Local aMenuGrp				:= {}
	Local aDadosMenu			:= {}
	Local aRotinas				:= {}
//	Local _aGrupos 				:= {}
//	Local _aGrupos1				:= {}
//	Local cDados2

	Private aErro 				:= {}

	spf_CanOpen(cPswFile)

	aUsuario	:= AllUsers()
	aGrupos		:= AllGroups()

	oSection:Cell("ID"):SetBlock( { || aDados[1] } )
	oSection:Cell("USER"):SetBlock( { || aDados[2] } )
	oSection:Cell("DEPTO"):SetBlock( { || aDados[3] } )
	oSection:Cell("NDEPTO"):SetBlock( { || aDados[4] } )
	oSection:Cell("NOMEDEPTO"):SetBlock( { || aDados[5] } )
	oSection:Cell("RETROC"):SetBlock( { || aDados[6] } )
	oSection:Cell("AVANC"):SetBlock( { || aDados[7] } )
	oSection:Cell("TROCADT"):SetBlock( { || aDados[8] } )
	oSection:Cell("PRIORIZAR"):SetBlock( { || aDados[9] } )
	oSection:Cell("PRIORIZAR1"):SetBlock( { || aDados[10] } )

	oSection2:Cell("MENU"):SetBlock( { || cDados } )
	oSection2:Cell("MENUUSR"):SetBlock( { || cNameUsr } )

	oReport:SetTitle("Rela็ใo de usuแrios")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	oSection2:Init()

	ProcRegua(Len(aDadosMenu))   //incrementa regua

	For nX :=1 to Len(aUsuario)

		//_aGrupos	:= usrretgrp()
		//_aGrupos1	:= fwgrpparam()

		_cPrioriza1 := fwusrgrprule(aUsuario[nX][1][1])
		aDados[1] := aUsuario[nX][1][1]
		aDados[2] := aUsuario[nX][1][2]
		aDados[3] := aUsuario[nX][1][12]
		aDados[4] := ""
		aDados[5] := ""
		aMenuGrp  := {} 
		If ! Empty(aUsuario[nX][1][10])
			aDados[4] := aUsuario[nX][1][10][1]
			cGrupo 	:= aScan(aGrupos,{|y| AllTrim(y[1,1]) == aUsuario[nX][1][10][1]})
			aDados[5] := aGrupos[cGrupo][1][2]
			aMenuGrp	:= FWGrpMenu(aUsuario[nX][1][10][1])
		Endif
		aDados[6] := aUsuario[nX][1][23][2]
		aDados[7] := aUsuario[nX][1][23][3]
		aDados[8] := Iif(!aUsuario[nX][1][23][1],"N","S")
		aDados[9] := Iif(aUsuario[nX][1][18]==1,"S","N")
		aDados[10] := Iif(_cPrioriza1=="1","S","N")
		//_atabela := aclone(agrupos[cGrupo,1])

		oSection:PrintLine()
	
		For nZ :=1 to Len(aMenuGrp)
			If aMenuGrp[nZ] <> nil
				cDados	:=	aMenuGrp[nZ]
				cDados1	:= substr(cDados,3,1)
				If cDados1 <> "X"
					oSection2:PrintLine()
					aRotinas := StRotinasMenu(SubStr(cDados,12,len(cDados)-8))
					If !Empty(aRotinas)
						For nW :=1 to Len(aRotinas)
							If SubStr(Alltrim(aRotinas[nW]),1,7)<>"Acesso:"
								cDados 	 := Alltrim(aRotinas[nW])
							ElseIf SubStr(Alltrim(aRotinas[nW]),1,7)=="Acesso:"
								cDados	 += " - "+Alltrim(aRotinas[nW])
								cNameUsr :=	aUsuario[nX][1][2]
								oSection2:PrintLine()
							EndIf
						Next nW
					EndIf
				Endif
			EndIf
		Next nZ
	
		aFill(aDados,nil)
		aFill(aMenuGrp,nil)
		aFill(aRotinas,nil)
		//aFill(_atabela,nil)

	Next nX

	oSection:Finish()
	oSection2:Finish()

	SPF_Close(cPswFile)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStRotinasMenu บAutor  ณMicrosiga       บ Data ณ  12/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre o arquivo .xnu e retorna Aray com rotinas ativas      บฑฑ
ฑฑบ          ณ aRotinas[n][1]= Descri็ใo e aRotinas[n][2]= Fun็ใo         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StRotinasMenu(cArquivo)

	Local aRotina	:= {}
	Local cLinha	:= ""
	Local _cDesc	:= ""
	Local _cFunc	:= ""
	Local _cAccess	:= ""
	Local _lNaoDisp	:= .F.

	cArquivo := StrTran(cArquivo,"//","/")

	nHandle	:=	FT_FUse(cArquivo)
	If nHandle	= -1
		Return(aRotina)
	EndIf
	FT_FGoTop()
	ProcRegua(FT_FLastRec())
	FT_FGoTop()

	While !FT_FEof()
	
		IncProc("Analisando Arquivo: "+cArquivo)
	
		cLinha := FT_FReadLn()
	
		If ('<MenuItem Status="Enable">' $ cLinha) .And. (!_lNaoDisp)
			FT_FSkip()
			_cDesc := FT_FReadLn()
			_cDesc := StrTran(_cDesc,'<Title lang="pt">',"")
			_cDesc := StrTran(_cDesc,'</Title>',"")
			FT_FSkip()
			FT_FSkip()
			FT_FSkip()
			_cFunc := FT_FReadLn()
			_cFunc := StrTran(_cFunc,'<Function>',"")
			_cFunc := StrTran(_cFunc,'</Function>',"")
			AAdd(aRotina,_cDesc+" - "+_cFunc)
		ElseIf ('<Access>' $ cLinha) .And. (!_lNaoDisp)
			_cAccess	:= FT_FReadLn()
			_cAccess	:= StrTran(_cAccess,'<Access>',"")
			_cAccess 	:= StrTran(_cAccess,'</Access>',"")
			_cAccess 	:= StrTran(_cAccess,'x',"s")
			_cAccess 	:= StrTran(_cAccess,' ',"n")
			AAdd(aRotina,"Acesso: "+_cAccess)
		ElseIf ('<MenuItem Status="Hidden">' $ cLinha) .And. (!_lNaoDisp)
			_cDesc		:= "Rotina nใo disponํvel"
			_cFunc		:= ""
			AAdd(aRotina,_cDesc)
		ElseIf ('<MenuItem Status="Disable">' $ cLinha) .And. (!_lNaoDisp)
			_cDesc		:= "Rotina nใo disponํvel"
			_cFunc		:= ""
			AAdd(aRotina,_cDesc)
		ElseIf '<Menu Status="Hidden">' $ cLinha
			_lNaoDisp	:= .T.
		ElseIf '<Menu Status="Disable">' $ cLinha
			_lNaoDisp	:= .T.
		ElseIf '</Menu>' $ cLinha .And. _lNaoDisp
			_lNaoDisp	:= .F.
		EndIf
		FT_FSkip()
	EndDo

	FT_FUse()

Return(aRotina)

//http://tdn.totvs.com/pages/releaseview.action;jsessionid=30C2A9CCF254A499CC04822D73BFFCC8?pageId=6814847
//FWGrpAcess("000035")

/*
#include "protheus.ch"

User Function TstUsrRule()
Local cRet 
Local cUserID := "000003"

cRet := FWUsrGrpRule(cUserID)

IF cRet == "0" 
	ApMsgAlert("Usuแrio nใo encontrado") 
ElseIf cRet == "1"
	ApMsgAlert("Usuแrio prioriza regras do grupo") 
ElseIf cRet == "2"
	ApMsgAlert("Usuแrio desconsidera regras do grupo") 
ElseIf cRet == "3" 
	ApMsgAlert("Usuแrio soma regras do grupo") 
EndIf
Return 
*/
