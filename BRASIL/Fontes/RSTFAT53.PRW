#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFAT53     �Autor  �Giovani Zago    � Data �  20/08/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Compara��o lista de pre�o                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFAT53()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT53"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif



PutSx1(cPerg, "01", "Tabela 01:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",3,0,0,"G","",'DA0'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Tabela 02:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",3,0,0,"G","",'DA0'    ,"","","mv_par02","","","","","","","","","","","","","","","","")

PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")
/*
PutSx1(cPerg, "05", "Do Pedido:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch5","C", 6,0,0,"G","",'SC5' ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Ate Pedido:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch6","C", 6,0,0,"G","",'SC5' ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "Da Emiss�o:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch7","D", 8,0,0,"G","",'' ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate Emiss�o:"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch8","D", 8,0,0,"G","",'' ,"","","mv_par08","","","","","","","","","","","","","","","","")
*/

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Giovani Zago    � Data �  21/02/14     ���
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
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELAT�RIO Compara��o lista de pre�o ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio Compara��o lista de pre�o ")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Compara��o lista de pre�o ",{"SC5"})



TRCell():New(oSection,"PRODUTO"	  			 ,,"PRODUTO"		,,15,.F.,)
TRCell():New(oSection,"DESCRI"  			 ,,"DESCRICAO"		,,35,.F.,)
TRCell():New(oSection,"GRUPO"	  			 ,,"GRUPO"			,,05,.F.,)
TRCell():New(oSection,"GRPDESC"  			 ,,"DES_GRUPO"		,,35,.F.,)
TRCell():New(oSection,"PRC01" 			 	 ,,"PRC_"+MV_PAR01	,"@E 99,999,999.99",14)
TRCell():New(oSection,"PRC02"     			 ,,"PRC_"+MV_PAR02	,"@E 99,999,999.99",14)
TRCell():New(oSection,"REAJUSTE"     		 ,,"REAJUSTE"		,"@E 99,999,999.99",14)


oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC5")

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
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local _cSta 	:= ''



oSection1:Cell("PRODUTO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("DESCRI")  				:SetBlock( { || aDados1[02] } )
oSection1:Cell("GRUPO")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("GRPDESC")       		:SetBlock( { || aDados1[04] } )
oSection1:Cell( "PRC01" )  				:SetBlock( { || aDados1[05] } )
oSection1:Cell("PRC02")    				:SetBlock( { || aDados1[06] } )
oSection1:Cell("REAJUSTE")  			:SetBlock( { || aDados1[07] } )




oReport:SetTitle("Compara��o lista de pre�o ")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
		aDados1[01]	:=	(cAliasLif)->PRODUTO
		aDados1[02]	:= 	(cAliasLif)->DESC
		aDados1[03]	:=  (cAliasLif)->GRUPO
		aDados1[04]	:=  (cAliasLif)->GRPDESC
		aDados1[05]	:=  (cAliasLif)->PRC01
		aDados1[06]	:=	(cAliasLif)->PRC02
		aDados1[07]	:= 	(cAliasLif)->REAJUSTE
		
		
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf
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


cQuery := " SELECT
cQuery += " SB1.B1_COD
cQuery += ' AS "PRODUTO",
cQuery += " SB1.B1_DESC
cQuery += ' AS "DESC",
cQuery += " SB1.B1_GRUPO
cQuery += ' AS "GRUPO",
cQuery += " SBM.BM_DESC
cQuery += ' AS "GRPDESC",
cQuery += " NVL(TA1.DA1_PRCVEN,0)
cQuery += ' AS "PRC01",
cQuery += " NVL(DA1.DA1_PRCVEN,0)
cQuery += ' AS "PRC02",
cQuery += " CASE WHEN NVL(DA1.DA1_PRCVEN,0) <> 0 AND NVL(TA1.DA1_PRCVEN,0) <> 0 THEN ROUND((round(((DA1.DA1_PRCVEN*100)/TA1.DA1_PRCVEN),2) - 100),2) ELSE 0 END
cQuery += ' AS "REAJUSTE"

cQuery += " FROM   "+RetSqlName("DA1")+" DA1 "

cQuery += " LEFT JOIN (SELECT * FROM   "+RetSqlName("DA1")+") TA1 "
cQuery += " ON TA1.D_E_L_E_T_ = ' '
cQuery += " AND TA1.DA1_FILIAL = DA1.DA1_FILIAL
cQuery += " AND TA1.DA1_CODTAB = '"+MV_PAR01+"'
cQuery += " AND TA1.DA1_CODPRO = DA1.DA1_CODPRO

cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SB1")+") SB1 "
cQuery += " ON SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_FILIAL = ' '
cQuery += " AND SB1.B1_COD = DA1.DA1_CODPRO


cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SBM")+") SBM "
cQuery += " ON SBM.D_E_L_E_T_ = ' '
cQuery += " AND SBM.BM_FILIAL = ' '
cQuery += " AND SBM.BM_GRUPO = SB1.B1_GRUPO

cQuery += " WHERE DA1.D_E_L_E_T_ = ' '
cQuery += " AND DA1.DA1_CODTAB = '"+MV_PAR02+"'
cQuery += " AND DA1.DA1_FILIAL = ' '
cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'





cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

