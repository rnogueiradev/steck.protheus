#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFATAX   �Autor  �Robson Mazzarotto � Data �  28/03/17     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de tarefas em Execu��o do PMS                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFATAX()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAX"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Projeto de:" 	,"Projeto de:" 	 ,"Projeto de:" 		,"mv_ch1","C",15,0,0,"G","",'AF8' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Projeto Ate:"	,"Projeto Ate:"  ,"Projeto Ate:"		,"mv_ch2","C",15,0,0,"G","",'AF8' ,"","","mv_par02","","","","","","","","","","","","","","","","")
//	PutSx1(cPerg, "03", "Da Emissao:"	,"Da Emissao:"	 ,"Da Emissao:"			,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	//PutSx1(cPerg, "04", "At� a Emissao:","At� a Emissao:","At� a Emissao:" 		,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    ,""	 ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
 
	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Robson Mazzarotto� Data �  28/03/17    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de tarefas em Execu��o do PMS 				    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELAT�RIO TAREFAS EM EXECU��O",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio das tarefas em Execu��o dos projetos")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Tarefas em Execu��o",{"AFW"})



    TRCell():New(oSection,"01",,"RECURSO"		,,30,.F.,)
	TRCell():New(oSection,"02",,"PROJETO" 		,,30,.F.,)
	TRCell():New(oSection,"03",,"CODTAREFA"   ,,30,.F.,)
	TRCell():New(oSection,"04",,"TAREFA"	    ,,30,.F.,)
	TRCell():New(oSection,"05",,"EMISSAO"		,,10,.F.,)
	TRCell():New(oSection,"06",,"HORA"			,,10,.F.,)


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("AFW")

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint  �Autor  �Robson Mazzarotto� Data �  28/03/17    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de tarefas em Execu��o do PMS					    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]


	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	 

	oReport:SetTitle("TAREFAS EM EXECU��O")// Titulo do relat�rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())

		
			aDados1[01]	:=  (cAliasLif)->RECURSO
			aDados1[02]	:=  (cAliasLif)->PROJETO
			aDados1[03]	:=  (cAliasLif)->CODTAREFA
			aDados1[04]	:=  (cAliasLif)->TAREFA
			aDados1[05]	:=	(cAliasLif)->EMISSAO
			aDados1[06]	:= 	(cAliasLif)->HORA
					  	
		
			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Robson Mazzarotto� Data �  28/03/17    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de tarefas em Execu��o do PMS					    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery     := ' '


	cQuery := " SELECT
	cQuery += " AFW_TAREFA
	cQuery += ' "CODTAREFA",
	cQuery += " AE8_DESCRI
	cQuery += ' "RECURSO",
	cQuery += " AF8_DESCRI
	cQuery += ' "PROJETO",
	cQuery += " AF9_DESCRI
	cQuery += ' "TAREFA",
	cQuery += " SUBSTR(AFW_DATA,7,2)||'/'|| SUBSTR(AFW_DATA,5,2)||'/'|| SUBSTR(AFW_DATA,1,4)
	cQuery += ' "EMISSAO",
	cQuery += " AFW_HORA
	cQuery += ' "HORA"
	
	cQuery += " FROM AFW010 AFW

	cQuery += "   INNER JOIN(SELECT * FROM AF8010 )AF8
	cQuery += " 	  ON AF8.D_E_L_E_T_   = ' '
	cQuery += " 	  AND AF8.AF8_PROJET = AFW_PROJET

	cQuery += "   INNER JOIN(SELECT * FROM AE8010 )AE8
	cQuery += " 	  ON AE8.D_E_L_E_T_   = ' '
	cQuery += " 	  AND AE8.AE8_RECURS = AFW_RECURS

	cQuery += "   INNER JOIN(SELECT * FROM AF9010 )AF9
	cQuery += " 	  ON AF9.D_E_L_E_T_   = ' '
	cQuery += " 	  AND AF9.AF9_TAREFA = AFW_TAREFA
		
	cQuery += " WHERE AFW.D_E_L_E_T_ = ' '
	cQuery += " AND AFW.AFW_PROJET BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " ORDER BY AFW.AFW_PROJET
	 

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
 

