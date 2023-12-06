#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STDCR06  � Autor � Cristiano Pereira� Data �  30/03/13     ���
�������������������������������������������������������������������������͹��
���Descricao � Listagem dos itens que est�o com Numero da DCR             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STDCR06()

Local oReport
Local aArea	:= GetArea()



If Pergunte("STDCR06",.T.)
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

oReport := TReport():New("STDCR06","Rela��o de Itens com DCR-e","STDCR06",{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir os itens com DCR-e.")

oReport:SetLandscape()
pergunte("STDCR06",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros						  �
//� mv_par01			// Mes							 		  �
//� mv_par02			// Ano									  �
//���������������������������������������������������������������� 


oSection1 := TRSection():New(oReport,"DCRe",{"SB1"},)  


TRCell():New(oSection1,"PRODUTO"		,,"Produto"	    ,"@!",015,.F.,)
TRCell():New(oSection1,"DESCR"		,,"Descri��o"	,"@!",050,.F.,) 
TRCell():New(oSection1,"NCM"		,,"Ncm"	,"@!",010,.F.,) 
TRCell():New(oSection1,"ALTER"		,,"Alternativo"	,"@!",010,.F.,)   
TRCell():New(oSection1,"DCR"		,,"Dcr"	,"@!",025,.F.,)
TRCell():New(oSection1,"DCRe"		,,"Dcre"	,"@!",025,.F.,)   


oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SB1")


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

Local cTitulo		:= OemToAnsi("DCRe")
Local cAlias1		:= "QRY1SB1"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local aDados1[06]
Local oSection1  := oReport:Section(1)
        
oSection1:Cell("PRODUTO"  )		:SetBlock( { || aDados1[1] })
oSection1:Cell("DESCR" )		:SetBlock( { || aDados1[2] })
oSection1:Cell("NCM" )		:SetBlock( { || aDados1[5] })
oSection1:Cell("ALTER" )		:SetBlock( { || aDados1[6] })
oSection1:Cell("DCR" )	    	:SetBlock( { || aDados1[3] })
oSection1:Cell("DCRE" )	    	:SetBlock( { || aDados1[4] })




cQuery1 :=  " SELECT SB1.B1_COD  AS PRODUTO, "
cQuery1 +=  "        SB1.B1_DESC AS DESCR  , "
cQuery1 +=  "        SB1.B1_DCR  AS DCR    , "
cQuery1 +=  "        SB1.B1_DCRE AS DCRE   ,  "
cQuery1 +=  "        SB1.B1_POSIPI  AS NCM,    "
cQuery1 +=  "        SB1.B1_ALTER  AS ALTERR    "

 

cQuery1 +=  "   FROM   "+RetSqlName("SB1")+" SB1 "
           
cQuery1 +=  "   WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND  SB1.D_E_L_E_T_ <> '*'   AND "
cQuery1 +=  "       ( SB1.B1_DCR <> ' '  OR SB1.B1_DCRE <> ' '  )                      AND "
cQuery1 +=  "       SB1.B1_COD >= '"+MV_PAR01+"' AND SB1.B1_COD <= '"+MV_PAR02+"'     AND " 
cQuery1 +=  "       SB1.B1_GRUPO >= '"+MV_PAR03+"' AND SB1.B1_GRUPO <= '"+MV_PAR04+"'     "



                 
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


//Atualiza Array com dados de Capta��o
While (cAlias1)->(!Eof())
     
	aDados1[01]  := (cAlias1)->(PRODUTO) 
	aDados1[02]  := (cAlias1)->(DESCR) 
	aDados1[05]  := (cAlias1)->NCM
	aDados1[03]  := (cAlias1)->(DCR) 
	aDados1[04]  := (cAlias1)->(DCRE) 
	aDados1[06]  := (cAlias1)->(ALTERR)
    
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



