#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFAT77     �Autor  �Renato Nogueira � Data �  29/09/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio de Instru�ao de despacho	                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFAT77()
*-----------------------------*          
Local   oReport
Private cPerg 			:= "RFAT77"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif



PutSx1(cPerg, "01", "Processo" 		,"Processo" 		,"Processo" 		,"mv_ch1","C",17,0,0,"G","","SW6"    ,"","","mv_par01","","","","","","","","","","","","","","","","")

Begin Transaction

PUTMV("MV_IMPSX1","N")

oReport		:= ReportDef()
oReport:PrintDialog()

PUTMV("MV_IMPSX1","S")

End Transaction

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio ONE VOICE				                          ���
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
Local oSection1
Local oSection2

oReport := TReport():New(cPergTit,"INSTRU��O DE DESPACHO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de instru��o de despacho ")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"INSTRU��O DE DESPACHO",{"SW7"})
oSection2 := TRSection():New(oReport,"INSTRU��O DE DESPACHO",{"SW7"})

TRCell():New(oSection,"Qtde"	,,"QTD."									,"@E 99,999,999.99",14)
TRCell():New(oSection,"Produto"	,,"PRODUTO"									,,50,.F.,)
TRCell():New(oSection,"Codigo"	,,"COD"										,,15,.F.,)
TRCell():New(oSection,"Ncm"		,,"N.C.M."									,,8 ,.F.,)
TRCell():New(oSection,"Fab"		,,"COD.FAB"									,,6 ,.F.,)

TRCell():New(oSection2,"Total"	,,"Total USD"								,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SW7")

oSection2:SetHeaderSection(.t.)
oSection2:Setnofilter("SW7")

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint  �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Produtos em transito	                          ���
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
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local aDados2[1]

oSection1:Cell("Qtde") 		:SetBlock( { || aDados1[01] } )
oSection1:Cell("Produto") 	:SetBlock( { || aDados1[02] } )
oSection1:Cell("Codigo") 	:SetBlock( { || aDados1[03] } )
oSection1:Cell("Ncm") 		:SetBlock( { || aDados1[04] } )
oSection1:Cell("Fab") 		:SetBlock( { || aDados1[05] } )

oSection2:Cell("Total")		:SetBlock( { || aDados2[01] } )

oReport:SetTitle("INSTRU��O DE DESPACHO")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
aFill(aDados2,nil)
oSection1:Init()
oSection2:Init()

Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
	 	aDados1[01]	:=	(cAliasLif)->QTDE
		aDados1[02]	:= 	(cAliasLif)->PRODUTO
		aDados1[03]	:=  (cAliasLif)->CODIGO
		aDados1[04]	:=  (cAliasLif)->NCM
		aDados1[05]	:=  (cAliasLif)->FAB

		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf

oReport:SkipLine()
aDados2[01]	:=  STGETOT()
oSection2:PrintLine()

oReport:SkipLine()
Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Giovani Zago    � Data �  21/02/14     ���
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
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT W7_QTDE QTDE, B1_DESC PRODUTO, W7_COD_I CODIGO, W7_NCM NCM, W7_FABR FAB "
cQuery += " FROM "+RetSqlName("SW7")+" W7 "
cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
cQuery += " ON B1_COD=W7_COD_I "
cQuery += " WHERE W7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND W7_FILIAL='"+cFilAnt+"' AND W7_HAWB='"+MV_PAR01+"' "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Giovani Zago    � Data �  21/02/14     ���
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
Static Function STGETOT()
*-----------------------------*

Local cQuery     := ' '
Local _nTotal	 := 0

cQuery := " SELECT SUM(W7_QTDE*W7_PRECO) TOTAL "
cQuery += " FROM "+RetSqlName("SW7")+" W7 "
cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
cQuery += " ON B1_COD=W7_COD_I "
cQuery += " WHERE W7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND W7_FILIAL='"+cFilAnt+"' AND W7_HAWB='"+MV_PAR01+"' "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

_nTotal	:= (cAliasLif)->TOTAL

Return(_nTotal)