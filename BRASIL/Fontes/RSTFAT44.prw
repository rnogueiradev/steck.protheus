#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT44	�Autor  �Renato Nogueira     � Data �  12/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio utilizado para imprimir informa��es da �rvore     ���
���          �de usu�rios dos chamados  		  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RSTFAT44()

Local   oReport
Private cPerg 			:= "RFAT44"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

//PutSx1(cPerg, "01", "Emissao de:" 		,"Emissao de: ?" 		,"Emissao de: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "02", "Emissao ate:" 		,"Emissao ate: ?" 		,"Emissao ate: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")

oReport:=ReportDef()
oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"Relat�rio de aprovadores","",{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de aprovadores")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Aprovadores",{"ZZE"})

TRCell():New(oSection,"DEPTO"	  			 ,,"DEPTO"		,"@!",40,.F.,)
TRCell():New(oSection,"APROV"	  			 ,,"APROVADOR"	,"@!",25,.F.,)
TRCell():New(oSection,"GRUPO"  			 	 ,,"GRUPO"		,"@!",6 ,.F.,)
TRCell():New(oSection,"USERS" 			 	 ,,"USUARIOS"	,"@!",25,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("ZZE")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrin�Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[4]
Local _cSta 	:= ''
Local nX		:=	nY		:= 0
Local nOcorren	:= nAcumulado	:= 0
Local cUsuario	:= ""
Local aUsers	:= aUsersFin	:= {}
Local nY

aUsers	:= AllUsers()

For nX:=1 To Len(aUsers)
	
	AADD(aUsersFin,{aUsers[nX][1][10][1],aUsers[nX][1][2]})
	
Next

nX	:=	0

oSection1:Cell("DEPTO")	    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("APROV")  				:SetBlock( { || aDados1[02] } )
oSection1:Cell("GRUPO")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("USERS")  				:SetBlock( { || aDados1[04] } )

oReport:SetTitle("Aprovadores")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection1:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())

If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->ZZE_NOMEDP
		aDados1[02]	:= 	Alltrim(UsrRetName((cAliasLif)->ZZE_APROV))
		
		For nX:=1 To Len((cAliasLif)->ZZE_GRPSOL)
			
			If SubStr((cAliasLif)->ZZE_GRPSOL,nX,1)=="#"
				nOcorren++
			EndIf
			
		Next
		
		nX	:= 0
		nOcorren++
		nAcumulado	:= 7
		
		For nX:=1 To nOcorren
			
			If nX=1
				aDados1[03] :=	SubStr((cAliasLif)->ZZE_GRPSOL,1,6)
			Else
				aDados1[03]	:=	SubStr((cAliasLif)->ZZE_GRPSOL,1+nAcumulado,6)
				nAcumulado	:= nAcumulado+7
			EndIf
			
			For nY:=1 To Len(aUsersFin)
				
				If Alltrim(aDados1[03])==AllTrim(aUsersFin[nY][1])
					aDados1[04]	:= 	AllTrim(aUsersFin[nY][2])
					oSection1:PrintLine()
				EndIf
				
			Next
			
		Next
		
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
���Programa  �StQuery	�Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function StQuery()

Local cQuery     := ' '

cQuery := " SELECT ZZE_NOMEDP, ZZE_APROV, ZZE_GRPSOL "
cQuery += " FROM "+RetSqlName("ZZE")+" ZZE "
cQuery += " WHERE ZZE.D_E_L_E_T_=' '  "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()