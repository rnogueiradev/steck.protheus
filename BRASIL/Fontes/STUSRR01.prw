#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TOPCONN.CH"

#DEFINE ID_USER_ADMINISTRATOR "000000"

#DEFINE APSDET_USER_ID		aPswDet[01][01]
#DEFINE APSDET_USER_NAME	aPswDet[01][02]
#DEFINE APSDET_USER_GROUPS	aPswDet[01][03]
#DEFINE APSDET_USER_MENUS	aPswDet[01][04]

User Function STUSRR01()

	Local oReport

	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New("RelaUsers","RELATÓRIO DE USUÁRIOS",,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de usuários.")

	oSection := TRSection():New(oReport,"USUÁRIOS",{"TRB"})

	TRCell():New(oSection,"01","TRB","ID Usuário"	,,6)
	TRCell():New(oSection,"02","TRB","Nome"		 	,,25)
	TRCell():New(oSection,"03","TRB","Qtde grupos"	,,30)
	TRCell():New(oSection,"04","TRB","Prioriza"		,,3)
	TRCell():New(oSection,"05","TRB","Grupo"		,,28)
	TRCell():New(oSection,"09","TRB","Menu"		,,28)
	TRCell():New(oSection,"06","TRB","Rotina"		,,28)
	TRCell():New(oSection,"07","TRB","Função"		,,28)
	TRCell():New(oSection,"08","TRB","Acesso"		,,28)

	oSection:SetHeaderSection(.T.)

Return oReport

Static Function ReportPrint(oReport)

	Local oSection				:= oReport:Section(1)
//Local oSection2				:= oReport:Section(2)
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
//Local oSection2
	Local cGrupo
	Local cDados1
	Local cDados2
	Local cNameUsr
	Local _cPrioriza1
	Local _aGrupos 				:= {}
	Local _aGrupos1				:= {}
	Local cUserID 				:= RetCodUsr()
	Local cLinha  				:= ""
	Local lPrim   				:= .T.
	Local aCampos 				:= {}
	Local cDir	  				:= "C:\"
	Local n		  				:= 0
	Local aMenuGrp				:= {}
	Local aDadosMenu			:= {}
	Local aRotinas				:= {}
	Local cAviso 	 		:= ""
	Local cErro 	 		:= ""
	Local _nY, _nX
	Private aErro 				:= {}

	spf_CanOpen(cPswFile)

	aUsuario	:= AllUsers()
	aGrupos		:= AllGroups()

	oSection:Cell("01"):SetBlock( { || aDados[1] } )
	oSection:Cell("02"):SetBlock( { || aDados[2] } )
	oSection:Cell("03"):SetBlock( { || aDados[3] } )
	oSection:Cell("04"):SetBlock( { || aDados[4] } )
	oSection:Cell("05"):SetBlock( { || aDados[5] } )
	oSection:Cell("06"):SetBlock( { || aDados[6] } )
	oSection:Cell("07"):SetBlock( { || aDados[7] } )
	oSection:Cell("08"):SetBlock( { || aDados[8] } )
	oSection:Cell("09"):SetBlock( { || aDados[9] } )

	oReport:SetTitle("Relação de usuários")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	oSection:Init()

	ProcRegua(Len(aDadosMenu))   //incrementa regua

	For nX :=1 to Len(aUsuario)

		_cPrioriza1 := fwusrgrprule(aUsuario[nX][1][1])

		Conout(aUsuario[nX][1][1])

		If aUsuario[nX][1][1]=="000000"
			Loop
		EndIf
		If aUsuario[nX][1][17] //Bloqueado
			Loop
		EndIf

		aDados[1] := aUsuario[nX][1][1]
		aDados[2] := aUsuario[nX][1][2]
		aDados[3] := Len(aUsuario[nX][1][10])
		aDados[4] := _cPrioriza1

		If Len(aUsuario[nX][1][10])==0
			Loop
		EndIf

		aDados[5] := aUsuario[nX][1][10][1]

		aMenu1	:= FWGrpMenu(aUsuario[nX][1][10][1])

		For _nX:=1 To Len(aMenu1)
			If !SubStr(aMenu1[_nX],3,1)=="X"

				aXnu := XNULoad( substr(aMenu1[_nX],at("\",aMenu1[_nX]),len(aMenu1[_nX])) )

				For _nY:=1 To Len(aXnu)
					aMenu := {}
					RetSubMenu(aXnu[_nY][3])
					k := 1
					While k <= Len(aMenu)

						If !(aMenu[k][3])=="*" .And. (aMenu[k][2])=="Enable"
							aDados[1] := aUsuario[nX][1][1]
							aDados[2] := aUsuario[nX][1][2]
							aDados[3] := Len(aUsuario[nX][1][10])
							aDados[4] := _cPrioriza1
							aDados[5] := aUsuario[nX][1][10][1]
							aDados[6] := Alltrim(aMenu[k][1])
							aDados[7] := Alltrim(aMenu[k][3])
							aDados[8] := Alltrim(aMenu[k][4])
							aDados[9] := substr(aMenu1[_nX],at("\",aMenu1[_nX]),len(aMenu1[_nX]))
							oSection:PrintLine()
							aFill(aDados,nil)
						EndIf

						k++
					Enddo
				Next

			EndIf
		Next

	Next nX

	oSection:Finish()

	SPF_Close(cPswFile)

Return()

//http://tdn.totvs.com/pages/releaseview.action;jsessionid=30C2A9CCF254A499CC04822D73BFFCC8?pageId=6814847
//FWGrpAcess("000035")

/*
#include "protheus.ch"

User Function TstUsrRule()
Local cRet 
Local cUserID := "000003"

cRet := FWUsrGrpRule(cUserID)

IF cRet == "0" 
	ApMsgAlert("Usuário não encontrado") 
ElseIf cRet == "1"
	ApMsgAlert("Usuário prioriza regras do grupo") 
ElseIf cRet == "2"
	ApMsgAlert("Usuário desconsidera regras do grupo") 
ElseIf cRet == "3" 
	ApMsgAlert("Usuário soma regras do grupo") 
EndIf
Return 
*/

Static Function RetSubMenu(aSubMenu)
	Local i
	Local cAble := ""
	for i := 1 to Len(aSubMenu)
		if ValType(aSubMenu[i][3]) == 'A'
			cAble := iif(aSubMenu[i][2]=='E',"Enable",iif(aSubMenu[i][2]=='D',"Disable",iif(aSubMenu[i][2]=='H',"Hidden","None")))
			aAdd(aMenu,{aSubMenu[i][1][1],cAble,"*","*"})
			RetSubMenu(aSubMenu[i][3])
		else
			cAble := iif(aSubMenu[i][2]=='E',"Enable",iif(aSubMenu[i][2]=='D',"Disable",iif(aSubMenu[i][2]=='H',"Hidden","None")))
			aAdd(aMenu,{aSubMenu[i][1][1],cAble,aSubMenu[i][3],aSubMenu[i][5]})
		endif
	next i

Return

