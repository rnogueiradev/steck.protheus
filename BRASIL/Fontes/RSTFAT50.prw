#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT50  �Autor  �Renato Nogueira     � Data �  31/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de altera��es de pre�o 	                          ���
���          �Chamado 000530                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Expedi��o                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                

*-----------------------------*
User Function RSTFAT50()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT50"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

//PutSx1(cPerg, "01", "OS de:"	 					, "OS de:"	 		, "OS de:"	 		,"mv_ch1","C",6,0,0,"G","",'CB7'    ,"","","mv_par01","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Renato Nogueira     � Data �  22/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
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

oReport := TReport():New(cPergTit,"Relat�rio de altera��es DA1",/*cPerg*/,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de altera��es DA1")

//Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Pre�os alterados",{"DA1"})

TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"				,"@!"			   		,15,.F.,)
TRCell():New(oSection,"LOG"					 ,,"LOG"				,"@!" 			   		,  ,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SB1")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint�Autor  �Renato Nogueira     � Data �  22/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
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
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[16]
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""

oSection1:Cell("CODIGO")    			:SetBlock( { || aDados[01] } )
oSection1:Cell("LOG")		  			:SetBlock( { || aDados[02] } )

oReport:SetTitle("DA1")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery() },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())

If  Select(cAliasLif) > 0
	
	While (cAliasLif)->(!Eof())
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbGoTo((cAliasLif)->REGISTRO))
		
		If SB1->(!Eof())
			
			aDados[01]	:=	SB1->B1_COD
			aDados[02]	:= 	SB1->B1_XLOGDA1
			
			oSection:PrintLine()
			aFill(aDados,nil)
			
		EndIf
		
		(cAliasLif)->(dbskip())
		
	EndDo
	
	oReport:SkipLine()
	
EndIf

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Renato Nogueira � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio COMISSAO				                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery(cCodOpe)
*-----------------------------*

Local cQuery     := ' '

cQuery := " SELECT R_E_C_N_O_ REGISTRO "
cQuery += " FROM "+RetSqlName("SB1")+" B1 "
cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_XLOGDA1 IS NOT NULL "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()