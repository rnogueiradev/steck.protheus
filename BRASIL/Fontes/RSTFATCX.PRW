#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCX        | Autor | RENATO.OLIVEIRA           | Data | 16/07/2020  |
|=====================================================================================|
|Descrição | Relatório de unicom			                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCX()

	Local   oReport
	Private cPerg 			:= "RFATCX"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	//U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	//U_STPutSx1( cPerg, "02","Data ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de acessos a fornecedor",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acessos a fornecedor")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"Z20",{"Z20"})

	TRCell():New(oSection1,"01"	  			 ,,"Usuário"								,,TamSx3("Z20_USER")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Acesso inclusao?"						,,20,.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("Z20")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()
	Local _nX

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )

	oReport:SetTitle("Relatório de acessos SA2")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	_aCposObg := {}

	AADD(_aCposObg,{"A2_TIPO",.F.})
	AADD(_aCposObg,{"A2_CGC",.F.})
	AADD(_aCposObg,{"A2_COD",.F.})
	AADD(_aCposObg,{"A2_LOJA",.F.})
	AADD(_aCposObg,{"A2_NOME",.F.})
	AADD(_aCposObg,{"A2_NREDUZ",.F.})
	AADD(_aCposObg,{"A2_END",.F.})
	AADD(_aCposObg,{"A2_EST",.F.})
	AADD(_aCposObg,{"A2_MUN",.F.})
	AADD(_aCposObg,{"A2_TEL",.F.})
	AADD(_aCposObg,{"A2_XSOLIC",.F.})
	AADD(_aCposObg,{"A2_XDEPTO",.F.})
	AADD(_aCposObg,{"A2_CODPAIS",.F.})

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			_aCposUsr 	:= {}
			_lAcessFul 	:= .T.

			For _nX:=1 To Len(_aCposObg)
				_aCposObg[_nX][2] := .F.
			Next

			aDados1[01]	:= (cAliasLif)->Z20_USER

			_cQuery1 := " SELECT Z20_CAMPO
			_cQuery1 += " FROM Z20010 Z20
			_cQuery1 += " WHERE Z20.D_E_L_E_T_=' ' AND Z20_USER='"+(cAliasLif)->Z20_USER+"'

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			While (_cAlias1)->(!Eof())

				For _nX:=1 To Len(_aCposObg)
					If AllTrim((_cAlias1)->Z20_CAMPO)==AllTrim(_aCposObg[_nX][1])
						_aCposObg[_nX][2] := .T.
					EndIf
				Next

				(_cAlias1)->(DbSkip())
			EndDo

			For _nX:=1 To Len(_aCposObg)
				If !_aCposObg[_nX][2]
					_lAcessFul := .F.
					exit
				EndIf
			Next

			If _lAcessFul
				aDados1[02]	:= "SIM"
			Else
				aDados1[02]	:= "NAO"
			EndIf


			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT DISTINCT Z20_USER
	cQuery += " FROM Z20010 Z20
	cQuery += " WHERE Z20.D_E_L_E_T_=' ' AND Z20_ROTINA='SA2'
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
