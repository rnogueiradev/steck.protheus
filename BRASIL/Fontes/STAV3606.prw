#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Include 'Protheus.ch'

Static cRETGERAV
Static cRETGERAV1
Static cRETGERAV2
Static cRETGERAV3
Static cRETGERAV4

/*/{Protheus.doc} STAV3606

Consulta Padrão para retornar os Dados do Superior (AV3606)

@type function
@author Everson Santana
@since 07/08/17
@version Protheus 12 - Gestão de Pessoal

@history , ,

/*/

User Function STAV3606()

	Local aRet   := {}
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local lRet   := .F.
	Local aArea  := GetArea()
	Local uVarRet
	Local uVarRet1
	Local uVarRet2
	Local uVarRet3
	Local uVarRet4
	
	Private oDlg, oLbx
	Private aCpos  := {}
	Private _cCodigo := space(TamSX3("RA_NOME")[1])
	Private _nColuna 	:= 2
	
	cQuery := " SELECT * FROM ( "
	cQuery += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USRAVA FROM SRA010 WHERE RA_DEMISSA = ' ' AND RA_EMAIL <> ' ' AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USRAVA FROM SRA030 WHERE RA_DEMISSA = ' ' AND RA_EMAIL <> ' '  AND  SUBSTR(RA_MAT,1,1) <> '9' AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += " SELECT RA_XEMP EMP, RA_FILIAL FILIAL, RA_MAT MATRICULA,RA_NOME NOME,RA_XUSRCFG USRAVA FROM SRA070 WHERE RA_DEMISSA = ' ' AND RA_EMAIL <> ' ' AND D_E_L_E_T_ = ' ' "
	cQuery += " ) XXX ORDER BY XXX.NOME"
	//cQuery += " ) XXX WHERE (SUBSTR(XXX.MATRICULA,1,1) <> '9' OR XXX.NOME LIKE ('%LUIS%') ) ORDER BY XXX.NOME"
	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	While (cAlias)->(!Eof())
		aAdd(aCpos,{(cAlias)->(MATRICULA), (cAlias)->(NOME),(cAlias)->(EMP), (cAlias)->(FILIAL), (cAlias)->(USRAVA) })
		(cAlias)->(dbSkip())
	End
	(cAlias)->(dbCloseArea())

	If Len(aCpos) < 1
		aAdd(aCpos,{" "," "," "})
	EndIf

	DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Colaboradores" FROM 0,0 TO 430,590 PIXEL

	oCodigo:= TGet():New( 003, 005,{|u| if(PCount()>0,_cCodigo:=u,_cCodigo)},oDlg,205, 010,,{||},0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",_cCodigo,,,,,,,"Nome",1 )
	oButton1 := TButton():New(010, 212," &Pesquisar ",oDlg,{|| Processa({|| STAVPES(M->_cCodigo) },"Aguarde...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	@ 025,005 LISTBOX oLbx FIELDS HEADER 'Matricula', 'Nome', 'Empresa', 'Filial','Usr Protheus' SIZE 290,165 OF oDlg PIXEL
  
	oLbx:SetArray( aCpos )
	oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4], aCpos[oLbx:nAt,5]}}
	oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,3], oLbx:aArray[oLbx:nAt,4], oLbx:aArray[oLbx:nAt,5]}}}

	//DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,3], oLbx:aArray[oLbx:nAt,4]})  ENABLE OF oDlg
	DEFINE SBUTTON FROM 197,243 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,3], oLbx:aArray[oLbx:nAt,4], oLbx:aArray[oLbx:nAt,5]})  ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	If Len(aRet) > 0 .And. lRet
		If Empty(aRet[1])
			lRet := .F.
		Else
		
			uVarRet 	:= aRet[1]
			uVarRet1 	:= aRet[2]
			uVarRet2	:= aRet[4]
			uVarRet3   	:= aRet[3]
			uVarRet4	:= aRet[5]
			// Atualiza a Variável de Retorno
			cRETGERAV     := uVarRet
			cRETGERAV1    := uVarRet1
			cRETGERAV2    := uVarRet2
			cRETGERAV3    := uVarRet3
			cRETGERAV4    := uVarRet4
			//------------------------------------------------------------------------------------------------
			// Atualiza a Variável de Memória com o Conteúdo do Retorno
			SetMemVar("RA_XMATSUP",cRETGERAV)
			SetMemVar("RA_XNOMSUP",cRETGERAV1)
			SetMemVar("RA_XFILSUP",cRETGERAV2)
			SetMemVar("RA_XEMPSUP",cRETGERAV3)
			SetMemVar("RA_XUSRSUP",cRETGERAV4)

			//VAR_IXB := uVarRet
			//------------------------------------------------------------------------------------------------
			// Força a atualização dos Componentes (Provavelmente não irá funcionar). A solução. ENTER
			SysRefresh(.T.)         

			// Atualiza os componentes
			GetDRefresh()

			RestArea( aArea )

		EndIf
	EndIf
Return lRet

	*********************************************************************
	* Necessário criar para ser adicionado no retorno da consulta padrão
	*********************************************************************
User Function RETGERBV()
Return (cRETGERAV) 

User Function RETGERB1()
Return (cRETGERAV1) 

User Function RETGERB2()
Return (cRETGERAV2)

User Function RETGERB3()
Return (cRETGERAV3) 

User Function RETGERB4()
Return (cRETGERAV4)

Static Function STAVPES(cBusca)
	Local i := 0

	if !Empty(cBusca)
		For i := 1 to len(aCpos)
			//Aqui busco o texto exato, mas pode utilizar a função AT() para pegar parte do texto
			if UPPER(Alltrim(aCpos[i,_nColuna])) = UPPER(Alltrim(cBusca))
				//Se encontrar me posiciono no grid e saio do "For"			
				oLbx:GoPosition(i)
				oLbx:Setfocus()
				exit
			Endif
		Next
	Endif
Return