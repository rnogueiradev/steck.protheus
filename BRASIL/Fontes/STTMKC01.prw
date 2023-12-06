#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE APSDET_USER_ID		aPswDet[01][01]
#DEFINE APSDET_USER_NAME	aPswDet[01][02]
#DEFINE APSDET_USER_GROUPS	aPswDet[01][03]
#DEFINE APSDET_USER_MENUS	aPswDet[01][04]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKC01     ºAutor  ³Renato Nogueira  º Data ³  02/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criado consulta padrao especifica mostrando somente	  º±±
±±º          ³ as condicoes maiores que 501                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKC01()
	
	Local aGetArea := GetArea()
	Local oBrowCons
	Local aMat:={}
	Local lOpc:=.F.
	Local aInd:={}
	Local cFS_GRPSPVE	:= SuperGetMV("FS_GRPSPVE",,"")
	Local _aGrupos, _nPos
	
	SE4->(DbClearFilter())
	
	Aadd(aMat,{"E4_CODIGO" , "Código" , "@!" , "C", 03, 0})
	Aadd(aMat,{"E4_DESCRI" , "Descrição" , "@!" , "C", 15, 0})
	Aadd(aMat,{"E4_XACRESC" , "% Acres. Fin." , "@E 999.99" , "N", 6, 2})
	Aadd(aMat,{"E4_XVLRMIN" , "Valor mínimo" , "@E 9999999999999.99" , "N", 16, 2})
	
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf
	
	If _aGrupos[1][10][1] $ cFS_GRPSPVE
		cCondicao:= "SE4->E4_CODIGO >= '501' "
	Else
		cCondicao:= "SE4->E4_CODIGO $ '"+GetMv("ST_CONDPG",,"501#502#505#512#513#518#522#528#529#531#539#544#545#553#554#561#581#713")+"' "
	EndIf
	
	bFiltraBrw := {|| FilBrowse("SE4",@aInd,@cCondicao) }
	Eval(bFiltraBrw)
	
	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Cond. Pagamento"
	@ 006, 005 TO 190, 370 BROWSE "SE4" FIELDS aMat OBJECT oBrowCons
	
	@ 200, 120 BUTTON "_Pesq Codigo" SIZE 60, 13 ACTION PesqCodSE4()
	@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
	@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)
	
	oDlgPrd:lCentered := .t.
	oDlgPrd:Activate()
	
	SE4->(DbClearFilter())
	
	
Return lOpc

Static Function PesqCodSE4()
	
	Local cCondicao:=''
	Local cGet:=Space(03)
	Local aInd:={}
	
	DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por código:" PIXEL OF oMainWnd
	@ 8,11 TO 71,122
	@ 13,15 SAY "Expressão: "
	@ 13,50 GET cGet picture "@!" SIZE 60,30
	@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()
	
	Activate MsDialog oDlgPesq Centered
	
	If !Empty(cGet)
		SE4->(dbSetOrder(1))
		SE4->(dbSeek(xFilial("SE4")+cGet))
		
	Endif
	
return
