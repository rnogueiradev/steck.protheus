#INCLUDE 'RWMAKE.CH' 
#INCLUDE "TOTVS.CH"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A710PAR  º Autor ³ RVG                º Data ³  27/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ alteracao de parametros conforme configuracoes basicas     º±±
±±º          ³ do MRP Steck                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11 - STECK                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A710PAR

	Local _nCount	
	//Local lSaida	:= .F.
	//Local _cGetMot	:= Space(3)

	Public _cDestOP := ''
	
	_nTipoPer  	:= PARAMIXB[1]
	_nPeriodos  := PARAMIXB[2]
	_aTipos     := PARAMIXB[3]
	_aGrupos    := PARAMIXB[4]
	_lPv        := PARAMIXB[5]

	cPerg := "STMRPA0002"

	DbSelectArea("SX1")
	DbSetOrder(1)

	//						Removido por Valdemir Rabelo - 15/07/2019

	If cFilAnt $"02#05" //Ticket 20210706011812 - Everson Santana - 06.07.2021

		/* Removido 11/05/23 - Não executa mais Recklock na X1 - Criar perguntas no configurador
		If ! DbSeek(cPerg+"01",.t.)
			Reclock("SX1",.t.)
			SX1->X1_GRUPO   := cPerg
			SX1->X1_ORDEM   := "01"
			SX1->X1_PERGUNT := "Configuração"
			SX1->X1_VARIAVL := "mv_ch1"
			SX1->X1_TIPO    := "C"
			SX1->X1_TAMANHO := 6
			SX1->X1_DECIMAL := 0
			SX1->X1_PRESEL  := 0
			SX1->X1_GSC     := "G"
			SX1->X1_VALID   := "EXISTCPO('PPB')"
			SX1->X1_VAR01   := "mv_par01"
			SX1->X1_DEF01   := ""
			SX1->X1_F3		 := "PPB"
			MsUnLock()
		EndIf
		*/

		IF PERGUNTE(cPerg,.T.)

			DbselectArea('PPB')
			DbSetOrder(1)
			Dbseek(xfilial('PPB')+MV_PAR01)

			if val(PPB->PPB_TIPO) > 0 .and. val(PPB->PPB_TIPO) < 8

				_nTipoPer := val(PPB->PPB_TIPO)

			Endif

			if PPB->PPB_NUMPER > 0

				_nPeriodos := PPB->PPB_NUMPER

			Endif

			if !empty(PPB->PPB_GRUPOS)

				For _nCount := 1 to len(_aGrupos)

					if alltrim(SubStr(_aGrupos[_ncount,2],1,nTamGr711)) $ alltrim(PPB->PPB_GRUPOS)
						_aGrupos[_ncount,1] := .t.
					else
						_aGrupos[_ncount,1] := .f.
					endif

				Next _nCount

			endif

			if !empty(PPB->PPB_TIPOS)

				For _nCount := 1 to len(_aTipos)

					if alltrim(SubStr(_aTipos[_ncount,2],1,nTamTipo711)) $ alltrim(PPB->PPB_TIPOS)
						_aTipos[_ncount,1] := .t.
					else
						_aTipos[_ncount,1] := .f.
					endif

				Next _nCount

			endif

		Endif

	EndIf

	aRet := {{ _nTipoPer , _nPeriodos,  _aTipos, _aGrupos , _lPv } }

	AjustaSX1()
	/*
	Removido por Valdemir Rabelo - 15/07/2019

	If cFilAnt=="04" //Chamado 008860

	DbSelectArea("SX6")
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	If !SX6->(DbSeek(cFilAnt+"ST_MOTMRP"))
	SX6->(RecLock("SX6",.T.))
	SX6->X6_FIL 	:= cFilAnt
	SX6->X6_VAR 	:= "ST_MOTMRP"
	SX6->X6_DESCRIC := "Parametro de controle do motivo do MRP"
	SX6->X6_CONTEUD := ""
	SX6->(MsUnLock())
	EndIf

	While !lSaida

	Define msDialog oDlg Title "Preencher motivo" From 10,10 TO 20,30 Style DS_MODALFRAME

	@ 001,003 Say "Motivo: " Pixel Of oDlg
	@ 010,003 MsGet _cGetMot valid ExistCpo("SZ1",_cGetMot) size 30,10 Picture "@!" pixel OF oDlg

	DEFINE SBUTTON FROM 30,30 TYPE 1 ACTION IF(!empty(_cGetMot),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parâmetro em Branco","Atenção")) ENABLE OF oDlg

	Activate dialog oDlg centered

	End

	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	If SX6->(DbSeek(cFilAnt+"ST_MOTMRP"))
	SX6->(RecLock("SX6",.F.))
	SX6->X6_CONTEUD := _cGetMot
	SX6->(MsUnLock())
	EndIf

	EndIf
	
*/
Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A710FILALMºAutor  ³ RVG Solucoes       º Data ³  12/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os armazens para o MRP                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - STECK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()
	Local cAlias := Alias()
	Local aRegistros:={}
	Local i :=0

	_cDtIni :=   ctod("01/"+ substr(dtoc(ddatabase),4) )
	_cDtFim := _cDtIni + 364

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"05",dtos(_cDtini),""})

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"06",dtos(_cDtFim),""})

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"08","01",""})

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"09","99",""})

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"23","      ",""})

	aadd(aRegistros,{Padr("MTA712",Len(SX1->X1_GRUPO),""),"24","ZZZZZZ",""})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	For i:=1 to Len(aRegistros)
		If dbSeek(aRegistros[i,1]+aRegistros[i,2])
			/* Removido 11/05/23 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
			RecLock("SX1",.f.)
			SX1->X1_CNT01 := aRegistros[i,3]
			IF !EMPTY( aRegistros[i,4])
				SX1->X1_PRESEL :=  aRegistros[i,4]
			Endif
			MsUnlock()
			*/
		EndIf
	Next I
	dbSelectArea(cAlias)

Return

