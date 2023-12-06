#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} U_STCOM181

@type function
@author Everson Santana
@since 13/12/19
@version Protheus 12 - Compras

@history ,Ticket 20191126000011 ,

/*/

User function STCOM181()

	Privat aCposBrw	:= {}
	Private aRotina := {}
	Private cArqTMP
	Private cNomArq1
	Private LNomArq1 := .F.	
	//Monta Arquivo Temporario
	MsgRun("Selecionando Registros, Aguarde...",,{|| MONTATRAB()})

	AAdd( aRotina, { "Pesquisar", "U_MBrowPesq", 0, 1 } )

	mBrowse( 6, 1,22,75,"TMP",aCposBrw,,,,,)

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	// Fecha arquivos de trabalho
	If LNomArq1
		fErase(cNomArq1 + OrdBagExt())
	EndIf
	
Return Nil

//ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
//і FUNCTION MONTATRAB (MONTA ARQUIVO DE TRABALHO DO BROWSE)                    і
//АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ
Static Function MONTATRAB()

	Local aEstrut     	:= {}
	Local cQuery     	:= ""
	Local nX
	Local oTable //adicionado\Ajustado
	Local cAlias //adicionado\Ajustado
	//Monta Query dos Pedidos DE Compra

	cQuery      := ""

	cQuery += " SELECT * FROM ( "+CR
	cQuery += " SELECT '01'    AS EMP, "+CR
	cQuery += "     SC7.C7_FILIAL  AS FIL, "+CR                 
	cQuery += "     SC7.C7_NUM     AS NUM, "+CR                 
	cQuery += "     SC7.C7_FORNECE AS FORNECE, "+CR             
	cQuery += "     SC7.C7_LOJA    AS LOJA, "+CR  
	cQuery += "     SA2.A2_NOME    AS NOME, "+CR
	cQuery += "     SC7.C7_USER    AS USERR, "+CR
	cQuery += "     SCR.CR_DATALIB AS LIB, "+CR
	cQuery += "     SC7.C7_OBS     AS OBS "+CR
	cQuery += " FROM   SC7010   SC7 "+CR  
	cQuery += " LEFT JOIN SCR010 SCR "+CR
	cQuery += " ON SCR.CR_FILIAL = SC7.C7_FILIAL "+CR
	cQuery += "     AND SCR.CR_NUM = SC7.C7_NUM "+CR
	cQuery += "     AND SCR.CR_TIPO = 'PC' "+CR
	cQuery += "     AND SCR.CR_STATUS = '05' "+CR
	cQuery += "     AND SCR.D_E_L_E_T_ = ' ' "+CR
	cQuery += " LEFT JOIN SA2010 SA2 "+CR
	cQuery += " ON SA2.A2_COD = SC7.C7_FORNECE "+CR
	cQuery += "     AND SA2.A2_LOJA = SC7.C7_LOJA "+CR
	cQuery += "     AND SA2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " WHERE SC7.C7_ENCER <> 'E'  AND "+CR 
	cQuery += "     SC7.C7_CONAPRO = 'L' AND "+CR 
	cQuery += "     SCR.CR_DATALIB IS NOT NULL AND "+CR
	cQuery += "     SC7.D_E_L_E_T_ = ' ' "+CR
	cQuery += " UNION "+CR 
	cQuery += " SELECT '03'      AS EMP, "+CR
	cQuery += "     SC7.C7_FILIAL  AS FIL, "+CR                 
	cQuery += "     SC7.C7_NUM     AS NUM, "+CR                 
	cQuery += "     SC7.C7_FORNECE AS FORNECE, "+CR             
	cQuery += "     SC7.C7_LOJA    AS LOJA, "+CR  
	cQuery += "     SA2.A2_NOME    AS NOME, "+CR
	cQuery += "     SC7.C7_USER    AS USERR, "+CR
	cQuery += "     SCR.CR_DATALIB AS LIB, "+CR
	cQuery += "     SC7.C7_OBS     AS OBS "+CR
	cQuery += " FROM   SC7030   SC7 "+CR  
	cQuery += " LEFT JOIN SCR030 SCR "+CR
	cQuery += " ON SCR.CR_FILIAL = SC7.C7_FILIAL "+CR
	cQuery += "     AND SCR.CR_NUM = SC7.C7_NUM "+CR
	cQuery += "     AND SCR.CR_TIPO = 'PC' "+CR
	cQuery += "     AND SCR.CR_STATUS = '05' "+CR
	cQuery += "     AND SCR.D_E_L_E_T_ = ' ' "+CR
	cQuery += " LEFT JOIN SA2030 SA2 "+CR
	cQuery += " ON SA2.A2_COD = SC7.C7_FORNECE "+CR
	cQuery += "     AND SA2.A2_LOJA = SC7.C7_LOJA "+CR
	cQuery += "     AND SA2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " WHERE SC7.C7_ENCER <> 'E'  AND "+CR 
	cQuery += "     SC7.C7_CONAPRO = 'L' AND "+CR 
	cQuery += "     SCR.CR_DATALIB IS NOT NULL AND "+CR
	cQuery += "     SC7.D_E_L_E_T_ = ' ') XXX "+CR  
	cQuery += " GROUP BY  XXX.EMP,XXX.FIL,XXX.NUM,XXX.FORNECE,XXX.LOJA,XXX.USERR,XXX.LIB,XXX.OBS,XXX.NOME "+CR
	cQuery += " ORDER BY  XXX.LIB DESC "+CR 

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TRB", .F., .F.)

	TRB->(dbGoTop())

	If !TRB->(Eof())

		aAdd(aCposBrw,      { "Empresa"			, "EMP"		,"C"	, 2          				, 0, ""})
		aAdd(aCposBrw,      { "Filial"     		, "FIL"     ,"C"    , TamSx3("C7_FILIAL")[1]	, 0, ""})
		aAdd(aCposBrw,      { "Pedido"     		, "NUM"     ,"C"    , TamSx3("C7_NUM")[1]		, 0, ""})
		aAdd(aCposBrw,      { "Fornecedor"  	, "FORNECE" ,"C"    , TamSx3("C7_FORNECE")[1]	, 0, ""})
		aAdd(aCposBrw,      { "Loja"  			, "LOJA"    ,"C"    , TamSx3("C7_LOJA")[1]      , 0, ""})
		aAdd(aCposBrw,      { "Razгo Social"	, "NOME"    ,"C"    , TamSx3("A2_NOME")[1]     	, 0, ""})
		aAdd(aCposBrw,      { "Usuario" 	    , "USERR"   ,"C"    , 30     					, 0, ""})
		aAdd(aCposBrw,      { "Dt Liberaзгo"  	, "LIB"     ,"D"    , TamSx3("CR_DATALIB")[1]   , 0, ""})
		aAdd(aCposBrw,      { "Observaзгo"    	, "OBS"     ,"C"    , TamSx3("C7_OBS")[1]   	, 0, ""})

		For nX := 1 To Len(aCposBrw)
			aAdd(aEstrut,     { aCposBrw[nX,2], aCposBrw[nX,3], aCposBrw[nX,4], aCposBrw[nX,5]})
		Next nX

		If Select("TMP") > 0
			TMP->(dbCloseArea())
			oTable:Delete("TMP") //adicionado\Ajustado
		EndIf

		//cArqTMP := CriaTrab(aEstrut, .T.) //Funзгo CriaTrab descontinuada, adicionado o oTable no lugar
		oTable := FWTemporaryTable():New("TMP") //adicionado\Ajustado
		oTable:SetFields(aEstrut)				//adicionado\Ajustado
		oTable:Create()							//adicionado\Ajustado
		cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
		cArqTMP := oTable:GetRealName()			//adicionado\Ajustado
		dbUseArea(.T.,"TOPCONN", cArqTMP, cAlias, .T., .F.)

		DbSelectArea("TRB")

		While !TRB->(Eof())

			DbSelectArea("TMP")

			RecLock("TMP", .T.)

			TMP->EMP     	:= TRB->EMP
			TMP->FIL     	:= TRB->FIL
			TMP->NUM     	:= TRB->NUM
			TMP->FORNECE    := TRB->FORNECE
			TMP->LOJA       := TRB->LOJA
			TMP->NOME     	:= TRB->NOME
			TMP->USERR     	:= UsrRetName(TRB->USERR)
			TMP->LIB        := Stod(TRB->LIB)
			TMP->OBS        := TRB->OBS

			TMP->(msUnlock())

			TRB->(DbSkip())

		Enddo

	EndIf

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

Return Nil

/*****
*
* Funзгo para pesquisar dados no arquivo temporбrio.
*
*/
User Function MBrowPesq()
	local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
	Local cOrdem
	Local cChave := Space(255)
	Local aOrdens := {}
	Local nOrdem := 1
	Local nOpcao := 0

	LNomArq1 := .T.
	cNomArq1 := Subs(cArqTMP,1,7)+"A"
	IndRegua( "TMP", cNomArq1, "EMP+FIL+NUM",,,"Indexando registros..." )
	dbClearIndex()
	dbSetIndex(cNomArq1 + OrdBagExt())

	AAdd( aOrdens, "Empresa+Filial+Pedido" )
	//AAdd( aOrdens, "Descriзгo" )

	DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
	@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
	@ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER

	If nOpcao == 1
		cChave := AllTrim(cChave)
		TMP->(dbSetOrder(nOrdem)) 
		TMP->(dbSeek(cChave))
	Endif
Return
