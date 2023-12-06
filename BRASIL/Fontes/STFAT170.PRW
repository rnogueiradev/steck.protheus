#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_ONLYSERVER + GETF_LOCALHARD + GETF_LOCALFLOPPY )

/*====================================================================================\
|Programa  | STFAT180        | Autor | Renato Nogueira           | Data | 13/08/2019  |
|=====================================================================================|
|Descrição | Enviar wf de romaneios TNT com notas que tiverem endereço de entrega     |
|          | nos dados adicionais                                                     |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT170()

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local cNewEmp  	:= "01"
	Local cNewFil  	:= "02"
	Local _nTotOs  	:= 0
	Local _nTotVol 	:= 0
	Local _nTotPes 	:= 0
	Local _nX
	Local aParamBox	:= {}
	Local aRet   	:= {}
	Local _dData	:= Date()

	AADD( aParamBox,{1,"Data:" ,DDATABASE,"99/99/9999","","","",70,.F.})

	If IsBlind()
		Reset Environment
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	Else
		If !ParamBox(aParamBox,"Parâmetros",@aRet,,,,,,,,.f.)
			Return
		EndIf
		_dData := MV_PAR01
	EndIf

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT PD2_FILIAL, PD2_CODROM, PD2_NFS, A1_NOME, PD2_REGIAO, PD2_QTDVOL, PD2_PBRUTO, C5.R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
	_cQuery1 += " ON D2_FILIAL=C5_FILIAL AND D2_PEDIDO=C5_NUM AND D2_CLIENTE=C5_CLIENTE AND D2_LOJA=C5_LOJACLI
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON PD2_FILIAL=D2_FILIAL AND PD2_NFS=D2_DOC AND PD2_SERIES=D2_SERIE 
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD1")+" PD1
	_cQuery1 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
	_cQuery1 += " ON CB7_FILIAL=PD2_FILIAL AND CB7_NOTA=PD2_NFS AND CB7_SERIE=PD2_SERIES AND CB7_CLIENT=PD2_CLIENT AND CB7_LOJA=PD2_LOJCLI
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' 
	_cQuery1 += " AND PD2_STATUS='2' AND PD1_PLACA='TNT' AND PD1_DTEMIS='"+DTOS(_dData)+"'
	_cQuery1 += " AND C5_FILIAL='"+xFilial("SC5")+"' AND (C5_ZENDENT<>' ' OR C5_ZCEPE<>' ')
	_cQuery1 += " GROUP BY PD2_FILIAL, PD2_CODROM, PD2_NFS, A1_NOME, PD2_REGIAO, PD2_QTDVOL, PD2_PBRUTO, C5.R_E_C_N_O_
	_cQuery1 += " ORDER BY PD2_FILIAL, PD2_CODROM, PD2_NFS

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cEmail	  := GetMv("STFAT1701",,"kleber.braga@steck.com.br;renato.oliveira@steck.com.br")
	_cCopia   := ""
	_cAssunto := "[WFPROTHEUS] - NFS TNT com endereço de entrega em dados adicionais"
	_aAttach  := {}
	_cCaminho := ""

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'

	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR BgColor=#FFFFFF>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Filial</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Romaneio</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Nota fiscal</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Nome</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Região</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Volumes</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Peso Bruto</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Cep</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Endereço</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Bairro</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Municipio</Font></B></TD>'
	cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Estado</Font></B></TD>'
	cMsg += '</TR>'

	_aRegiao := {}
	
	DbSelectArea("SC5")

	While (_cAlias1)->(!Eof())

		cMsg += '<TR BgColor=#66FF66>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD2_FILIAL+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD2_CODROM+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD2_NFS+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->A1_NOME+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias1)->PD2_REGIAO+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->PD2_QTDVOL)+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias1)->PD2_PBRUTO)+'</Font></B></TD>'
		
		SC5->(DbGoTo((_cAlias1)->RECSC5))
		_aEndEnt := U_STTNT011()
		
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aEndEnt[1][1]+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aEndEnt[1][2]+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aEndEnt[1][3]+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aEndEnt[1][5]+'</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aEndEnt[1][6]+'</Font></B></TD>'
		
		cMsg += '</TR>'

		(_cAlias1)->(DbSkip())
	EndDo

	cMsg += '</Table>'
	cMsg += '</body></html>'

	If IsBlind()
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
	EndIf

	If !IsBlind() .And. !Empty(cMsg)

		cPath		:= cGetFile( "Selecione o Diretorio | " , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )
		cArquivo	:= DTOS(Date())+StrTran(Time(),":")+".html"
		cAnexo		:= cPath+cArquivo

		nHdlXml   := FCreate(cAnexo,0)
		If nHdlXml > 0
			FWrite(nHdlXml,cMsg)
			FClose(nHdlXml)
			MsgAlert("Arquivo salvo com sucesso, obrigado!")
		Endif

	EndIf

Return()