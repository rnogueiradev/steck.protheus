#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
//#include "sigapsw.ch"

#define PSSVERSION '9.12.000'
#define PSWSESSION Chr(30)+Chr(1)+Chr(2)

#define USERLOCK "SIGAPSW_USER_"
#define GROUPLOCK "SIGAPSW_GROUP_"



#DEFINE ID_USER_ADMINISTRATOR "000000"

#DEFINE APSDET_USER_ID		aPswDet[01][01]
#DEFINE APSDET_USER_NAME	aPswDet[01][02]
#DEFINE APSDET_USER_GROUPS	aPswDet[01][03]
#DEFINE APSDET_USER_MENUS	aPswDet[01][04]
Static nOrder := 1, nRecPsw := 0
Static _Ap5RetPsw
Static _Ap5NoMv
Static cPswFile := "SIGAPSS.SPF"
Static lPswUpper
Static aPswLock := {}
User Function UseXp()
	
	//Local aUsuario	:= AllUsers()
	Local aGrupos	:= AllGroups()
	Local axGrupos	:= u_xAllGroups()
Return ()



User Function xRelaUsers()
	
	Local oReport
	
	oReport		:= ReportDef()
	oReport		:PrintDialog()
	
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
	TRCell():New(oSection,"PRIORIZAR1","TRB","REGRA DE ACESSO POR GRUPO?",,1)
	oSection2 := TRSection():New(oReport,"USUมRIOS",{"TRB"})
	
	TRCell():New(oSection2,"MENU","TRB","MENUS",,50)
	
	oSection:SetHeaderSection(.T.)
	oSection2:SetHeaderSection(.T.)
	
Return oReport

Static Function ReportPrint(oReport)
	
	Local oSection	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX			:= 0
	Local nZ			:= 0
	Local aDados[10]
	Local aDados1[1]
	Local aPswDet
	Local cPswFile	:= "sigapss.spf"
	Local lEncrypt	:= .F.
	Local aUsuarios	:= {}
	Local aGrupos	:= {}
	Local oReport
	Local oSection
	Local oSection2
	Local cGrupo
	Local cDados1
	Local cDados2
	Local _cPrioriza1
	Local _aGrupos := {}
	Local _aGrupos1:= {}
	Local cUserID := RetCodUsr()
	Local nw        	  := 0
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
	
	oReport:SetTitle("Rela็ใo de usuแrios")// Titulo do relat๓rio
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	oSection2:Init()
	
	
	
	For nX :=1 to Len(aUsuario)
		
		PswOrder(1)
		PswSeek(aUsuario[nX][1][10][1],.F.)
		__aGrupos := PswRet()
		___aGrupos	:= fwgrpparam(aUsuario[nX][1][10][1])
		
		_aGrupos	:= usrretgrp(aUsuario[nX][1][1])
		_cPrioriza1 := fwusrgrprule(aUsuario[nX][1][1])
		aDados[1] := aUsuario[nX][1][1]
		aDados[2] := aUsuario[nX][1][2]
		aDados[3] := aUsuario[nX][1][12]
		aDados[4] := aUsuario[nX][1][10][1]
		cGrupo 	:= aScan(aGrupos,{|y| AllTrim(y[1,1])==aUsuario[nX][1][10][1]})
		aDados[5] := aGrupos[cGrupo][1][2]
		aDados[6] := ___aGrupos[2][2]
		aDados[7] := ___aGrupos[2][3]
		aDados[8] := Iif(___aGrupos[2][1]=="1","S","N")
		aDados[9] := Iif(aUsuario[nX][1][18]==1,"S","N")
		aDados[10] := Iif(_cPrioriza1=="1","S","N") //1= Priorizar - 2=Desconsiderar - 3=Somar
		_atabela := aclone(agrupos[cGrupo,1])
		oSection:PrintLine()
		
		For nZ :=1 to Len(_atabela)
			cDados	:=	_atabela[nZ]
			cDados1	:= substr(cDados,3,1)
			If cDados1<>"X"
				oSection2:PrintLine()
				aRotinas := StRotinasMenu(substr(cDados,4,Len(cDados)))
				If !Empty(aRotinas)
					For nW :=1 to Len(aRotinas)
						cDados := aRotinas[nW]
						oSection2:PrintLine()
					Next nW
				EndIf
			Endif
		Next nZ
		
		aFill(aDados,nil)
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
		
		If '<MenuItem Status="Enable">' $ cLinha
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
		ElseIf '<Access>' $ cLinha
			_cAccess	:= FT_FReadLn()
			_cAccess	:= StrTran(_cAccess,'<Access>',"")
			_cAccess 	:= StrTran(_cAccess,'</Access>',"")
			_cAccess 	:= StrTran(_cAccess,'x',"s")
			_cAccess 	:= StrTran(_cAccess,' ',"n")
			AAdd(aRotina,"Acesso: "+_cAccess)
		EndIf
		FT_FSkip()
	EndDo
	
	FT_FUse()
	
Return(aRotina)


user  Function xAllGroups(lAlfa)
Local aReturn := {}
Local nRet
Local cMemo			:= ""
Local cUser			:= ""
Local cUserName		:= ""
Local cUserPsw		:= ""
Local nOrder
Local aMemo
Local ni
Local nPos

lAlfa  := If(lAlfa==Nil,.F.,lAlfa)
nOrder := If(lAlfa,2,1)

nRet := SPF_SEEK( cPswFile, "1G000000", 1 )
If nRet > 0
	Aadd(aReturn,AdmInfo(.T.))
	//SPF_GETFIELDS( cPswFile, nRet, @cUser, @cUserName, @cUserPsw, @cMemo)
	If !Empty( cMemo )
		aMemo := Str2Array(cMemo)
		aReturn[1][1][5] := aMemo[1][5]		//quantas vezes para expirar
		aReturn[1][1][8] := aMemo[1][8]		//diretorio de impressao
		aReturn[1][1][9] := aMemo[1][9]		//impressora
		aReturn[1][1][12] := aMemo[1][12]	//data da ๚ltima altera็ใo
		aReturn[1][1][13] := aMemo[1][13]	//tipo de impressao
		aReturn[1][1][14] := aMemo[1][14]	//formato da impressao
		aReturn[1][1][15] := aMemo[1][15]	//ambiente de impressao
		aReturn[1][1][16] := LTrim(Padr(aMemo[1][16],50))//opcao de impressao
		If Len(aMemo[1]) > 17
			aReturn[1][1][18] := aMemo[1][18]	//valida็ใo ddatabase
		EndIf
		If Len(aMemo[1]) > 18
			aReturn[1][1][19] := aMemo[1][19] //data de inclusao
		EndIf
		If Len(aMemo[1]) > 19
			aReturn[1][1][20] := aMemo[1][20] //nivel global de campo
		EndIf
		
		//menus
		For ni := 1 To Len(aReturn[1][2])
			cMod := Subs(aReturn[1][2][ni],1,2)
			nPos := Ascan(aMemo[2],{|x| Subs(x,1,2) == cMod})
			If nPos > 0
				aReturn[1][2][ni] := Subs(aReturn[1][2][ni],1,3)+Subs(aMemo[2][nPos],4)
			EndIf
		Next
		
		//-- Paineis Online
		If Len(aMemo) > 2
			aReturn[1][3] := AClone(aMemo[3])
		EndIf
		
		//-- Indicadores
		If Len(aMemo) > 3
			aReturn[1][4] := AClone(aMemo[4])
		EndIf
		
		//-- Senha Temporaria
		If Len(aMemo) > 4
			aReturn[1][5] := AClone(aMemo[5])
		EndIf
		
	EndIf
EndIf

nRet :=  SPF_GOTOP( cPswFile, nOrder)
While nRet > 0
	
	//SPF_GETFIELDS( cPswFile, nRet, @cUser, @cUserName, @cUserPsw, @cMemo)   //00000000000000000000000000
	
	If ! ( Subs(cUser,1,2) == "1G" ) .Or. AllTrim(cUser) == "1G000000"
		nRet := SPF_SKIP( cPswFile, nRet, nOrder )
		Loop
	EndIf
	
	If !Empty( cMemo )
		Aadd( aReturn, aClone(Str2Array(cMemo)) )
		If Len(aReturn[Len(aReturn)][1]) < 20
			Asize(aReturn[Len(aReturn)][1],20)
		EndIf
		aReturn[Len(aReturn)][1][16] := LTrim(Padr(aReturn[Len(aReturn)][1][16],50))
		aReturn[Len(aReturn)][1][18] := If(aReturn[Len(aReturn)][1][18]==Nil,{.F.,0,0},aReturn[Len(aReturn)][1][18])
		aReturn[Len(aReturn)][1][19] := If(aReturn[Len(aReturn)][1][19]==Nil,CToD(""),aReturn[Len(aReturn)][1][19])
		aReturn[Len(aReturn)][1][20] := If(aReturn[Len(aReturn)][1][20]==Nil," ",aReturn[Len(aReturn)][1][20])
		
		//-- Paineis Online
		If Len(aReturn[Len(aReturn)]) < 3
			Aadd( aReturn[Len(aReturn)], {} )
		EndIf
		
		//-- Indicadores
		If Len(aReturn[Len(aReturn)]) < 4
			Aadd( aReturn[Len(aReturn)], {} )
		EndIf
		
		//-- Senha Temporaria
		If Len(aReturn[Len(aReturn)]) < 5
			Aadd( aReturn[Len(aReturn)], {} )
		EndIf
	EndIf
	
	nRet := SPF_SKIP( cPswFile, nRet, nOrder )
End

__Ap5GetPsw(.F.)

Return aReturn

