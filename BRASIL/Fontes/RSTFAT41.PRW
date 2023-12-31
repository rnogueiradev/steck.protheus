#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFAT41    �Autor  �Giovani Zago    � Data �  23/04/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Regime especial		                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFAT41()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT41"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
Private cPergTit 		:= cAliasLif
Private _aMes           := {}   
Private j 				:= 0



//PutSx1(cPerg, "01", "Do Produto:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",15,0,0,"G","",'SB1'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "02", "Ate Produto:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",15,0,0,"G","",'SB1'    ,"","","mv_par02","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "03", "Do Grupo:" 		    ,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")


oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Regime especial		                          ���
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

oReport := TReport():New(cPergTit,"RELAT�RIO Regime especial",'',{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio Regime especial")

//Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Regime especial",{"SA1"})


TRCell():New(oSection,"CLIENTE"	 	,,"CLIENTE"	 ,,09,.F.,)
TRCell():New(oSection,"RAZAO"  	 	,,"RAZAO SOCIAL",,30,.F.,)
TRCell():New(oSection,"UF"  	 	,,"UF"			 ,,03,.F.,)
TRCell():New(oSection,"DESCRICAO"  ,,"DESCRICAO",,50,.F.,)
TRCell():New(oSection,"VALIDADE"   ,,"VALIDADE",,10,.F.,)


oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SA1")

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint  �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Regime especial    	                          ���
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
Local aDados[2]
Local aDados1[26] 
Local k :=0




oSection1:Cell("CLIENTE")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("RAZAO")  			    :SetBlock( { || aDados1[02] } )
oSection1:Cell("UF")    			    :SetBlock( { || aDados1[03] } )
oSection1:Cell("DESCRICAO")  			:SetBlock( { || aDados1[04] } )
oSection1:Cell("VALIDADE")    			:SetBlock( { || aDados1[05] } )


oReport:SetTitle("Regime especial")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->CLIENTE
		aDados1[02]	:= 	(cAliasLif)->RAZAO
		aDados1[03]	:=	(cAliasLif)->UF
		aDados1[04]	:= 	(cAliasLif)->DESCRICAO
		aDados1[05]	:=	(cAliasLif)->VALIDADE
	 
		oSection1:PrintLine()
		aFill(aDados1,nil)
				
		
		(cAliasLif)->(dbskip())  
		
		
	End
		
EndIf



oReport:SkipLine()




Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Giovani Zago    � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio Regime especial 		                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

Local cQuery     := ' '



cQuery := " SELECT
cQuery += " A1_COD||'-'||A1_LOJA 
cQuery += ' "CLIENTE",
cQuery += " RTRIM(LTRIM(A1_NOME)) 
cQuery += ' "RAZAO",
cQuery += " A1_EST
cQuery += ' "UF",
cQuery += " NVL((SELECT M4_FORMULA
cQuery += "  FROM "+RetSqlName("SM4")+"  SM4 "
cQuery += " WHERE SM4.D_E_L_E_T_ = ' '
cQuery += " AND SM4.M4_FILIAL = '"+xFilial("SM4")+"'"
cQuery += " AND SM4.M4_CODIGO = SA1.A1_FORMVIS),' ')
cQuery += ' "DESCRICAO",
cQuery += " SUBSTR(SA1.A1_XVALRE,7,2)||'/'|| SUBSTR(SA1.A1_XVALRE,5,2)||'/'|| SUBSTR(SA1.A1_XVALRE,1,4)   
cQuery += ' "VALIDADE"
cQuery += " FROM "+RetSqlName("SA1")+"  SA1 "
cQuery += " WHERE SA1.D_E_L_E_T_ = ' '
cQuery += " AND SA1.A1_XVALRE <> ' ' 
cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

