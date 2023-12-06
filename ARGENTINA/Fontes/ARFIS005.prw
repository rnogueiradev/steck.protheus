#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ARFIS005  � Autor � Cristiano Pereira� Data �  30/03/13    ���
�������������������������������������������������������������������������͹��
���Descricao � Listado das retenciones Steck Libro Compras                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ARFIS005()

Local oReport
Local aArea	:= GetArea()



If Pergunte("ARFIS05",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
EndIf

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Microsiga           � Data �  03/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Definicao do layout do Relatorio                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("ARFIS05","Retencion Ventas","ARFIS05",{|oReport| ReportPrint(oReport)},"Retencion Vendas.")

oReport:SetLandscape()
pergunte("ARFIS05",.F.)

//��������������������������������������������������������������Ŀ                                     
//� Variaveis utilizadas para parametros						  �
//� mv_par01			// Mes							 		  �
//� mv_par02			// Ano									  �
//���������������������������������������������������������������� 


oSection1 := TRSection():New(oReport,"Retencion Ventas",{"SD2"},)  

TRCell():New(oSection1,"IMPUESTO"	    ,,"IMPUESTO"	,"@!",010,.F.,) 
TRCell():New(oSection1,"EMISION"	    ,,"EMISION"	,"@!",008,.F.,) 
TRCell():New(oSection1,"NUM_FAT"		,,"NUM. FACTURA" ,"@!",010,.F.,)   
TRCell():New(oSection1,"DENOMINACION"   ,,"DENOMINACION" ,"@!",040,.F.,)
TRCell():New(oSection1,"CUIT"		    ,,"CUIT"	,"@!",025,.F.,) 
TRCell():New(oSection1,"PROVINCIA"		    ,,"PROVINCIA"	,"@!",05,.F.,)
TRCell():New(oSection1,"BASE_IMPONIBLE"		,,"BASE IMPONIBLE"	,"@!",20,.F.,) 
TRCell():New(oSection1,"PERCEP_RETENCION_BRUTO_CF"		 ,,"PERCEP INGRES BRUTO_CF"	,"@!",20,.F.,)  
TRCell():New(oSection1,"PERCEP_RETENCION_BRUTO_BA"		 ,,"PERCEP INGRES BRUTO_BA"	,"@!",20,.F.,)  
TRCell():New(oSection1,"PERCEP_RETENCION_BRUTO_IVA"		 ,,"PERCEP INGRES BRUTO_IVA"	,"@!",20,.F.,)   
TRCell():New(oSection1,"RETENCION_IB"		 ,,"RETEN INGRES. BRUTO"	,"@!",20,.F.,) 
 

oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.) 
oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('PERCEP_RETENCION_BRUTO_CF'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('PERCEP_RETENCION_BRUTO_BA'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection1:Cell('PERCEP_RETENCION_BRUTO_IVA'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection1:Cell('RETENCION_IB'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)  



oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SD2")


Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Microsiga		          � Data �12.05.12 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                            ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

Local cTitulo		:= OemToAnsi("Retencion Ventas")
Local cAlias1		:= "QRY1SD2"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local aDados1[11]
Local oSection1  := oReport:Section(1)
        
oSection1:Cell("IMPUESTO"  )		:SetBlock( { || aDados1[1] })
oSection1:Cell("EMISION" )		:SetBlock( { || aDados1[2] })
oSection1:Cell("NUM_FAT" )		:SetBlock( { || aDados1[3] })
oSection1:Cell("DENOMINACION" )		:SetBlock( { || aDados1[4] })
oSection1:Cell("CUIT" )	    	:SetBlock( { || aDados1[5] })
oSection1:Cell("PROVINCIA" )	    	:SetBlock( { || aDados1[6] }) 
oSection1:Cell("BASE_IMPONIBLE" )	:SetBlock( { || aDados1[7] }) 
oSection1:Cell("PERCEP_RETENCION_BRUTO_CF" )	:SetBlock( { || aDados1[8] }) 
oSection1:Cell("PERCEP_RETENCION_BRUTO_BA" )	:SetBlock( { || aDados1[9] }) 
oSection1:Cell("PERCEP_RETENCION_BRUTO_IVA" )	:SetBlock( { || aDados1[10] })
oSection1:Cell("RETENCION_IB" )	:SetBlock( { || aDados1[11] }) 

cQuery1 := " SELECT    "
cQuery1 += "        '' AS codigo_impuesto,      "
cQuery1 += "       SUBSTR(SD2.D2_EMISSAO,7,2)||'/'|| SUBSTR(SD2.D2_EMISSAO,5,2)||'/'|| SUBSTR(SD2.D2_EMISSAO,1,4) AS emision,  "
cQuery1 += "       SD2.D2_DOC AS numero_de_factura,        "
cQuery1 += "       SA1.A1_NOME AS denominacion,     "
cQuery1 += "       SA1.A1_CGC  AS numero_de_CUIT,   "
cQuery1 += "       SA1.A1_EST  AS provincia,        "
cQuery1 += "       SD2.D2_TOTAL AS base_imponible,  "
cQuery1 += "       '' AS libro,         "
cQuery1 += "       SD2.D2_VALIMPZ AS percepc_IBCF,  "
cQuery1 += "        SD2.D2_VALIMP6 AS percepc_IBBA, "
cQuery1 += "        SD2.D2_VALIMP4 AS percepc_IVA,  "
cQuery1 += "        SD2.D2_VALIMPR AS retenciones_IB          "
       
       

cQuery1 += " FROM "+RetSqlName("SD2")+" SD2 ,"+RetSqlName("SA1")+" SA1 "      
cQuery1 += " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'           AND    "
cQuery1 += "      SD2.D_E_L_E_T_ <> '*'          AND                     "
cQuery1 += "      SD2.D2_EMISSAO >='"+Dtos(MV_PAR01)+"'    AND                      "
cQuery1 += "      SD2.D2_EMISSAO <='"+Dtos(MV_PAR02)+"'    AND                     "
cQuery1 += "      SD2.D2_CLIENTE= SA1.A1_COD     AND                     "
cQuery1 += "      SD2.D2_LOJA   = SA1.A1_LOJA    AND                     "
cQuery1 += "      ( SD2.D2_VALIMPZ > 0 OR SD2.D2_VALIMP6 > 0 OR SD2.D2_VALIMP4 > 0 OR SD2.D2_VALIMPR > 0) AND " 
cQuery1 += "      SA1.D_E_L_E_T_ <> '*'                                  "
      
               
cQuery1 := ChangeQuery(cQuery1)

//�������������������������������Ŀ
//� Fecha Alias se estiver em Uso �
//���������������������������������
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//���������������������������������������������
//� Monta Area de Trabalho executando a Query �
//���������������������������������������������
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)


oReport:SetTitle(cTitulo)
               
nCont:= 0
dbeval({||nCont++})

oReport:SetMeter(nCont)

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())
  
//Imprime Dcre
aFill(aDados1,nil)
oSection1:Init()


//Atualiza Array com dados 
While (cAlias1)->(!Eof())
     
	aDados1[01]  := (cAlias1)->(codigo_impuesto) 
	aDados1[02]  := (cAlias1)->(emision) 
	aDados1[03]  := (cAlias1)->(numero_de_factura)
	aDados1[04]  := (cAlias1)->(denominacion) 
	aDados1[05]  := (cAlias1)->(numero_de_CUIT) 
	aDados1[06]  := (cAlias1)->(provincia) 
	aDados1[07]  := Alltrim(Transform((cAlias1)->(base_imponible),PesqPict("SE2","E2_VALOR")))
	aDados1[08]  := Alltrim(Transform((cAlias1)->(percepc_IBCF),PesqPict("SE2","E2_VALOR")))
	aDados1[09]  := Alltrim(Transform((cAlias1)->(percepc_IBBA),PesqPict("SE2","E2_VALOR"))) 
	aDados1[10]  := Alltrim(Transform((cAlias1)->(percepc_IVA),PesqPict("SE2","E2_VALOR"))) 
	aDados1[11]  := Alltrim(Transform((cAlias1)->(retenciones_IB),PesqPict("SE2","E2_VALOR"))) 
	
    oSection1:PrintLine()
	aFill(aDados1,nil)

	(cAlias1)->(dbSkip())
EndDo

//�������������������������������Ŀ
//� Fecha Alias se estiver em Uso �
//���������������������������������
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif
 
//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()
   
oSection1:PrintLine()
aFill(aDados1,nil)

oReport:SkipLine()
oSection1:Finish() 

Return

