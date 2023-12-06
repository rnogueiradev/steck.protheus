#include 'protheus.ch'
#include 'parmtype.ch'

User Function A200BOK()

	/*------------------------------------------------------------------------------------------------\
	|	A200BOK - Ponto de entrada para Valida Alterações na Estrutura do Produto					|
	|--------------------------------------------------------------------------------------------------|
	| Autor: Eduardo Matias Data:13/11/2018		teste												 							|
	\------------------------------------------------------------------------------------------------*/

	Local aBkArea			:=	GetArea()
	Local aRegs				:=	PARAMIXB[1]
	Local lRet				:=	.T.
	Local cIDConf		  	:= RetCodUsr()
	Private cCod			:=	PARAMIXB[2]
	Private cDescUsr 	:= UsrRetName(cIDConf)

	If Len(aRegs)>0

		cQuery 	:=		" UPDATE " + RetSqlName("PC3")
		cQuery 	+=	" SET  PC3_USRALT = '" + cDescUsr + "', PC3_DTALT='" + Dtos(dDataBase) + "' " 
		cQuery		+=	" WHERE PC3_FILIAL='"+ xFilial("PC3") +"' AND PC3_COD='"+cCod+"' AND D_E_L_E_T_!='*' "

		If TCSqlExec(cQuery)<0
			lRet	:=	.F.
			MsgStop()("Erro para atualizar dados: " + TCSQLError())
		Else

			WFALTSG1()

		Endif

	EndIf

	RestArea(aBkArea)

Return(lRet) 

Static Function  WFALTSG1()

	Local cTop01		:=	"SQL01"
	Local cHora			:= StrTran( Time(), ":", "" )
	Local cPath			:=	"\REGALTSG1"
	Local cArq			:=	"ALTSG1_"+Dtos(dDataBase)+"_"+cHora	+".xls"
	Local cCaminho	:=	cPath+"\"+cArq
	Local cDetProd	:=AllTrim(cCod) +" - "+ AllTrim(GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cCod,1,"Erro"))
	Local cSheet1		:=	"Detalhes"
	Local cTable		:=	cDetProd	
	Local cEmail		:= SuperGetMv("A200BOK01",.F.,"jonas.santos@steck.com.br")
	Local cCopia		:=""
	Local _aAttach	:={}
	Private oExcel		:=	FWMSEXCEL():New()

	If !ExistDir(cPath)
		MakeDir(cPath)
	EndIf

	oExcel:AddworkSheet(cSheet1)

	oExcel:AddTable (cSheet1,cTable)
	oExcel:AddColumn(cSheet1,cTable,"FILIAL"						,1,1)
	oExcel:AddColumn(cSheet1,cTable,"STATUS"					,1,1)
	oExcel:AddColumn(cSheet1,cTable,"COMPONENTE"		,1,1)
	oExcel:AddColumn(cSheet1,cTable,"DESCRIÇÃO"			,1,1)
	oExcel:AddColumn(cSheet1,cTable,"QUANT ANTES"		,1,2)
	oExcel:AddColumn(cSheet1,cTable,"QUANT DEPOIS"		,1,2)
	oExcel:AddColumn(cSheet1,cTable,"DATA ALTERAÇÃO"	,1,2)
	oExcel:AddColumn(cSheet1,cTable,"HORA"						,1,1)
	oExcel:AddColumn(cSheet1,cTable,"USUARIO"				,1,1)

	cQuery:= " 	SELECT FILIAL,CODIGO,MAX(TRIM(SB1P.B1_DESC)) DESCP,COMP,MAX(TRIM(SB1C.B1_DESC)) DESCC,MAX(QTDANT) QTDANT,MAX(QTDPOS)QTDPOS, " + CRLF
	cQuery+= " CASE  " + CRLF 
	cQuery+= " WHEN MAX(QTDANT)=0 THEN 'INCLUIDO'  " + CRLF  
	cQuery+= " WHEN MAX(QTDPOS)=0 THEN 'EXCLUIDO'  " + CRLF 
	cQuery+= " WHEN MAX(QTDPOS)=MAX(QTDANT) THEN 'ORIGINAL'  " + CRLF 
	cQuery+= " ELSE 'ALTERADO' END STATUS   " + CRLF 
	cQuery+= " FROM (	SELECT PC3_FILIAL FILIAL,PC3_COD CODIGO,PC3_COMP COMP,PC3_QUANT QTDANT,0 QTDPOS  " + CRLF 
	cQuery+= " 				FROM "+RetSqlName("PC3")+" PC3  " + CRLF 
	cQuery+= " 				WHERE PC3_FILIAL='"+xFilial("PC3")+"' AND PC3_COD='"+cCod+"' AND PC3.D_E_L_E_T_!='*'  " + CRLF 

	cQuery+= " 				UNION ALL  " + CRLF 

	cQuery+= " 				SELECT G1_FILIAL,G1_COD,G1_COMP,0 QTDANT,G1_QUANT QTDPOS  " + CRLF 
	cQuery+= " 				FROM "+RetSqlName("SG1")  + CRLF 
	cQuery+= " 				WHERE G1_FILIAL='"+xFilial("SG1")+"' AND G1_COD='"+cCod+"'  AND D_E_L_E_T_!='*'	) TMP1  " + CRLF 
	cQuery+= " 				INNER JOIN "+RetSqlName("SB1")+"  SB1P ON SB1P.B1_FILIAL=' ' AND SB1P.B1_COD=TMP1.CODIGO AND SB1P.D_E_L_E_T_!='*'  " + CRLF  
	cQuery+= " 				INNER JOIN "+RetSqlName("SB1")+" SB1C ON SB1C.B1_FILIAL=' ' AND SB1C.B1_COD=TMP1.COMP AND SB1C.D_E_L_E_T_!='*'  " + CRLF 

	cQuery+= " GROUP BY FILIAL,CODIGO,COMP  " + CRLF 

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

	While (cTop01)->(!Eof())

		If (cTop01)->STATUS!="ORIGINAL"

			oExcel:AddRow(cSheet1,cTable,{;
			(cTop01)->FILIAL,;
			(cTop01)->STATUS,;
			(cTop01)->COMP,;
			(cTop01)->DESCC,;
			(cTop01)->QTDANT,;
			(cTop01)->QTDPOS,;
			Dtoc(dDataBase),;
			cHora,;
			cDescUsr;
			})

		Else

			oExcel:AddRow(cSheet1,cTable,{;
			(cTop01)->FILIAL,;
			(cTop01)->STATUS,;
			(cTop01)->COMP,;
			(cTop01)->DESCC,;
			(cTop01)->QTDANT,;
			(cTop01)->QTDPOS,;
			'',;
			'',;
			'';
			})

		EndIf

		(cTop01)->(dbSkip())

	EndDo

	oExcel:Activate()
	oExcel:GetXMLFile(cCaminho)

	Aadd(_aAttach,{cArq})

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	cBody	:= " Registro de alteração de estrutura, produto: "+cDetProd+" </b><br><br>"
	cBody	+= "<em>Este é um e-mail automático, por favor não responda.</em><br><br>"
	cBody	+= "Steck - A200BOK</em></b><br><br>"

	Z1A->(RecLock("Z1A",.T.))

	Z1A->Z1A_FILIAL		:= cfilant
	Z1A->Z1A_NUM			:= GetSxeNum("Z1A", "Z1A_NUM")
	Z1A->Z1A_DATA		:= DATE()
	Z1A->Z1A_HORA		:= TIME()
	Z1A->Z1A_TABELA	:= ' '
	Z1A->Z1A_RECTAB	:= 0
	Z1A->Z1A_USUARI	:= __cUserId
	Z1A->Z1A_NUSUAR	:= cDescUsr
	Z1A->Z1A_PARA		:= cEmail
	Z1A->Z1A_CC				:= cCopia
	Z1A->Z1A_ASSUNT	:= "Reg. alteração estrutura:"+cDetProd
	Z1A->Z1A_CORPO 	:= cBody
	Z1A->Z1A_Q1			:= 1
	Z1A->Z1A_Q2			:= 0
	Z1A->Z1A_ANEXOS	:= cCaminho
	Z1A->Z1A_LOG			:= 'INCLUSAO: '+ dToc(DATE())+' - '+ TIME()+' - '+ __cUserId  +' - '+ cDescUsr +' - '+ Upper(FunName()) + CRLF  
	Z1A->Z1A_INTERV		:= 0

	Z1A->(MsUnlock())
	Z1A->(DbCommit())
	ConfirmSX8()

Return()