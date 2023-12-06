#INCLUDE "TOPCONN.CH" 
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} JOBAGAPI
description
Rotina que irá verificar quem ainda não realizou o agendamento
enviando novamente o WFs
@type function
@version  1.00
@author Valdemir Jose
@since 06/04/2021
@return return_type, return_description
u_JOBAGAPI
/*/
USER FUNCTION JOBAGAPI()
/*
    RpcClearEnv()
    RpcSetType(3)
    RpcSetEnv('01','02',,,,GetEnvServer(),{ "SC5","SA3","SA1","SB1","SBF","ZS3" } )
    SetModulo("SIGAFAT","FAT")    
*/
    NaoRetir()    // Agendamento não cumprido

    u_ProcesAG()    // Envia WF solicitando agendamento

//    RpcClearEnv()

RETURN 

User Function TstQryAP()
  u_ProcesAG() 
Return


/*/{Protheus.doc} JOBPEDOS
description
    Rotina que envia WF dos pedidos que esta 100% Liberados deverá ser preparado
    Colocar Schedule para rodar de 1 em 1 hora
@type function
@version  1.00
@author Valdemir Jose
@since 26/05/2021
@return return_type, return_description
u_JOBPEDOS
/*/
USER FUNCTION JOBPEDOS()

    RpcClearEnv()
    RpcSetType(3)
    RpcSetEnv('11','01',,,,GetEnvServer(),{ "SC5","SA3","SA1","SB1","SBF","ZS3" } )
    SetModulo("SIGAFAT","FAT")    

    EnvPrpPV()    // Envia WF com pedidos já com todas as liberações

    RpcClearEnv()

RETURN 


/*/{Protheus.doc} ProcesAG
description
Rotina que iniciara o processo de envio WFs
@type function
@version   1.00
@author Valdemir Jose
@since 06/04/2021
@return return_type, return_description
/*/
User Function ProcesAG(pNumNF)
    Local cQry       := ""
    Local cEmlCli    := ""
    Local cMsgErr    := ""
    Local aAreaAG    := GetArea()
    Local aArquivo   := {}
    Local aError     := {}
    Local _cEmail    := ""    //"valdemir.rabelo@sigamat.com.br"
    Default pNumNF   := ""

    cQry  := getMntQry(pNumNF)
    
    dbSelectArea("PD2")
    dbSetOrder(2)
    dbSelectArea("PD1")
    dbSetOrder(1)
    dbSelectArea("SF2")
    dbSetOrder(1)
    dbSelectArea("ZS3")
    dbSelectArea("SA1")

    if Select("TAGE") > 0
       TAGE->( dbCloseArea() )
    endif 

    TcQuery cQry New Alias 'TAGE'

    While TAGE->( !Eof() )
       
       ZS3->( dbGoto(TAGE->REG) )

        if SF2->( !dbSeek(xFilial("SF2")+ZS3->ZS3_NOTAFI) )
           cMsgErr    := "Nota Fiscal: "+ZS3->ZS3_NOTAFI+' Não Encontrada'
           Conout(cMsgErr)
           aAdd(aError,{'Pedido: '+ZS3->ZS3_PEDIDO, cMsgErr})
           AutoGrLog(cMsgErr)
           LjWriteLog( '\arquivos\ProcesAG.log', cMsgErr )
           TAGE->( dbSkip() )
           Loop
        endif 

       if ZS3->( FieldPos('ZS3_HRENV') = 0)
          //FWMsgRun(,{|| Sleep(4000)},'Informativo',"O campo ZS3_HRENV não foi criado. Por favor, informar o setor TI")
          cMsgErr := "O campo ZS3_HRENV não foi criado. Por favor, informar o setor TI"
          Conout(cMsgErr)
          aAdd(aError,{'Pedido: '+ZS3->ZS3_PEDIDO, cMsgErr})
          LjWriteLog( '\arquivos\ProcesAG.log', cMsgErr )
       Endif 

       // Verifico se existe retirada com status 3-Encerrado ou 2-Fechamento
       if PD2->( dbSeek(xFilial("PD2")+SF2->F2_DOC+SF2->F2_SERIE) )
          PD1->( dbSeek(xFilial("PD1")+PD2->PD2_CODROM) )
          if (PD1->PD1_STATUS $ "2/3")
             REClOCK("ZS3",.F.)
             ZS3->ZS3_STATUS = "R"
             ZS3->( MSUnLock() )
             TAGE->( dbSkip() )
             Loop             
          Endif 
       endif 

       IF SC5->( FIELDPOS('C5_XEMAILR') > 0)
          IF !Empty(TAGE->C5_XEMAILR)
            cEmlCli := ALLTRIM(TAGE->C5_XEMAILR)
            
            if !Empty(cEmlCli) .and. (Len(cEmlCli) > 1)
                // Adicionado 26/05/2021
                If File("\arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".pdf") .And.;
                   File("\arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".xml")
                   aAdd(aArquivo, SF2->F2_CHVNFE+".pdf")
                   aAdd(aArquivo, SF2->F2_CHVNFE+".xml")
                   
                   //StaticCall (APIAGEPD, EnviaWF, cEmlCli, 'ZS3',,{} ,aArquivo, "\arquivos\xml_nfe\"+cEmpAnt+"\")
                   u_EnviaWF(cEmlCli, 'ZS3',,{} ,aArquivo, "\arquivos\xml_nfe\"+cEmpAnt+"\")
                   // Valdemir Rabelo 24/06/2021 - Adicionado regra para não enviar mais de uma vez por dia.
                   RecLock("ZS3",.f.)
                   ZS3->ZS3_ENVIWF := dDatabase
                   if ZS3->( FieldPos('ZS3_HRENV') ) > 0
                      ZS3->ZS3_HRENV  := TIME()              // 14/07/2021 - Valdemir Rabelo 
                   endif 
                   ZS3->( MsUnlock() )
                else 
                   cMsgErr := "FILIAL: "+SF2->F2_FILIAL+" Nota Fiscal: "+SF2->F2_DOC+" - Arquivo não encontrado: \arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".xml"
                   conout(cMsgErr)
                   aAdd(aError,{'Pedido: '+ZS3->ZS3_PEDIDO, cMsgErr})
                   LjWriteLog( '\arquivos\ProcesAG.log', cMsgErr )
                endif
                aArquivo := {}            
            else 
              cMsgErr := "Pedido: "+ZS3->ZS3_PEDIDO+" Não foi informado os e-mail no campo: C5_XEMAILR"
              Conout(cMsgErr)
              aAdd(aError,{'Pedido: '+ZS3->ZS3_PEDIDO, cMsgErr})
              LjWriteLog( '\arquivos\ProcesAG.log', cMsgErr )
            endif 
          Else 
            cMsgErr := "Pedido: "+ZS3->ZS3_PEDIDO+" Não foi informado o(s) e-mail(s) no campo: C5_XEMAILR"
            Conout(cMsgErr)
            aAdd(aError,{'Pedido: '+ZS3->ZS3_PEDIDO, cMsgErr})
            LjWriteLog( '\arquivos\ProcesAG.log', cMsgErr )
          ENDIF            
       ENDIF

       TAGE->( dbSkip() )
    EndDo 

    RestArea( aAreaAG )

    if len(aError) > 0
       EnviaErr(_cEmail, aError, "Erro Agendamento Recepção Digital")
    endif 

Return 


/*/{Protheus.doc} getMntQry
description
Rotina que irá filtrar os registros a serem disparados via WF
@type function
@version   1.00
@author Valdemir Jose
@since 06/04/2021
@return return_type, return_description
/*/
Static Function getMntQry(pNumNF)
    Local cQry     := ""
    Default pNumNF := ""

    cQry += "SELECT DISTINCT C5_CLIENTE, C5_LOJACLI, C5_XEMAILR, C5_VEND2, ZS3.R_E_C_N_O_ REG " + CRLF 
    cQry += "FROM " + RETSQLNAME("ZS3") + " ZS3 " + CRLF
    cQry += "INNER JOIN " + RETSQLNAME("SC5") + " SC5 " + CRLF
    cQry += "ON SC5.C5_FILIAL=ZS3.ZS3_FILIAL AND SC5.C5_NUM=ZS3.ZS3_PEDIDO AND SC5.C5_FILIAL='"+XFILIAL('SC5')+"'  AND SC5.C5_XTIPO='1' AND SC5.D_E_L_E_T_ = ' ' " + CRLF    
    cQry += "WHERE ZS3.D_E_L_E_T_ = ' '  " + CRLF
    if !Empty(pNumNF)
        cQry += " AND ZS3.ZS3_NOTAFI = '"+pNumNF+"'  " + CRLF 
    else 
        cQry += " AND ZS3.ZS3_NOTAFI <> ' '  " + CRLF 
    Endif
    //cQry += " AND ZS3.ZS3_PEDIDO='625691' " + CRLF    // REMOVER APOS TESTES
    cQry += " AND ZS3.ZS3_DATAGE = ' '   " + CRLF 
    cQry += " AND ZS3.ZS3_FILIAL='"+XFILIAL("ZS3")+"' " + CRLF
    //cQry += " AND (ZS3.ZS3_ENVIWF <> '"+dtos(dDatabase)+"'  OR ZS3.ZS3_ENVIWF IS NULL)  " + CRLF 
    cQry += " AND ZS3.ZS3_STATUS <> 'R' " + CRLF
    cQry += " AND (ZS3.ZS3_ENVIWF <> '"+dtos(dDataBase)+"'  OR ZS3.ZS3_ENVIWF IS NULL)  " + CRLF 

Return cQry

  





/*/{Protheus.doc} NaoRetir
    description
    Rotina para verificar os agendamentos não cumpridos
    @type function
    @version   1.00
    @author Valdemir Jose
    @since 06/04/2021
    @return return_type, return_description
/*/
Static Function NaoRetir()
    Local cQry := ""

    dbSelectArea('ZS3')

    cQry := "SELECT ZS3.R_E_C_N_O_ REG " + CRLF 
    cQry += "FROM " + RETSQLNAME("ZS3 ") + " ZS3 " + CRLF 
    cQry += "WHERE ZS3.D_E_L_E_T_ = ' ' " + CRLF
    cQry += " AND ZS3.ZS3_DATAGE < '" +DTOS(dDATABASE)+ "'  " + CRLF 
    cQry += " AND ZS3.ZS3_STATUS = 'A'  " + CRLF 

    if select('NRET') > 0
       NRET->( dbCloseArea() )
    endif 

    tCQuery cQry New Alias 'NRET'

    While NRET->( !Eof() )
      ZS3->( dbGoto(NRET->REG) )
      RecLock("ZS3")
      ZS3->ZS3_DATAGE := ctod('')
      ZS3->ZS3_HORAGE := ''
      ZS3->ZS3_STATUS := ''
      MsUnlock()

      NRET->( dbSkip() )
    EndDo 

    if select('NRET') > 0
       NRET->( dbCloseArea() )
    endif 

Return



/*/{Protheus.doc} JOBAGDIA
description
Rotina JOB que enviará o WF com as pendencias do dia
@type function
@version   1.00
@author Valdemir Jose
@since 06/04/2021
@return return_type, return_description
u_JOBAGDIA
/*/
USER FUNCTION JOBAGDIA()

    RpcClearEnv()
    RpcSetType(3)
    RpcSetEnv('11','01',,,,GetEnvServer(),{ "SC5","SA3","SA1","SB1","SBF","ZS3" } )
    SetModulo("SIGAFAT","FAT")    

    AGNDADIA()    // Envia WF Agendamentos do dia

    RpcClearEnv()

RETURN 

/*/{Protheus.doc} EnviaErr
description
Rotina para enviar WF de Erro no processo
@type function
@version  
@author Valdemir Jose
@since 22/07/2021
@param pemail, variant, param_description
@param _aMsg, variant, param_description
@param pAssunto, variant, param_description
@return variant, return_description
/*/
Static Function EnviaErr(pemail, _aMsg, pAssunto)
   Local _cCopia   := ""
   Local cMsg      := ""
   Local cAttach   := ""
   Local _cAssunto := pAssunto
   Local _nLin     := 0

	// Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
    // Cabecalho
    cMsg += '<TR BgColor=#FFFFFF>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Documento </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> Erro </Font></B></TD>'
    cMsg += '</TR>'
	// Definicao do texto/detalhe do email                                        
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	// Definicao do rodape do email                                                
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(JOBAGAPI)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

    if Len(_aMsg) > 0
	    U_STMAILTES(pemail, _cCopia, _cAssunto, cMsg, cAttach)
    Endif 

Return 



/*/{Protheus.doc} EnvPrpPV
description
Rotina que envia WF dos Pedidos com liberações OK
@type function
@version   1.00
@author Valdemir Jose
@since 25/05/2021
@return return_type, return_description
/*/
Static Function EnvPrpPV()
    Local cQry       := ""
    LOCAL cLINHAS    := ""
    Local _cCopia    := ""
    Local cAttach    := ""
    Local cMsg       := ""
    Local _aMsg      := {}
    Local cStatus    := ""
    Local _cFa10Oper := GetMv("ST_FAOPER",, '74' )
    Local _cAssunto  := "Pedidos Retiras Pendentes Faturar"
    Local _cEmail    := GetMv("ST_EMLAGEN",.F.,"kleber.braga@steck.com.br,simone.mara@steck.com.br,guilherme.fernandez@steck.com.br,jefferson.puglia@steck.com.br")
    Local _nLin
    Local _nLinhas   := 0

   cQry += "SELECT DISTINCT C5_FILIAL, C5_NUM, C5_NOTA, CB7_NOTA, C5_CLIENTE, C5_LOJACLI, (       SELECT COUNT(*) " + CRLF
   cQry += "            FROM " + RETSQLNAME("CB8") + " L  " + CRLF
   //---------------------------------------------------------------------------------------------------------------------//
   //FR - 15/08/2023 - REVISÃO DO WF SOLICITADA POR KLEBER BRAGA - PEDIDOS MERCADO LIVRE
   //Revisão do código fonte do JOB de envio do WF : "Pedidos e Retiras Pendentes", 
   //este WF envia para os envolvidos, uma relação dos pedidos pendentes a faturar, 
   //mas como os pedidos do Mercado Livre não são faturados, é necessária uma tratativa de verificação 
   //quando a embalagem estiver finalizada, é porque finalizou o pedido, e neste caso, 
   //não pode aparecer no WF os pedidos já finalizados.
   //---------------------------------------------------------------------------------------------------------------------//
   cQry += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON L.CB8_FILIAL = SC6.C6_FILIAL " + CRLF 
   cQry += "         AND L.CB8_PEDIDO = SC6.C6_NUM AND L.CB8_ITEM = SC6.C6_ITEM "    + CRLF
   cQry += "         AND (SC6.C6_QTDVEN - SC6.C6_QTDENT) >0 AND SC6.C6_BLQ=' ' "     + CRLF  
   cQry += "         AND SC6.D_E_L_E_T_ = ' ' "                                      + CRLF
   //FR - 15/08/2023 - Flávia Rocha - Sigamat Consultoria

   cQry += "            WHERE L.D_E_L_E_T_ = ' '  " + CRLF
   cQry += "             AND L.CB8_FILIAL = C5.C5_FILIAL AND L.CB8_ORDSEP = CB7.CB7_ORDSEP  " + CRLF
   cQry += "            ) LINHAS   , CB7.CB7_STATUS, CB7.CB7_ORDSEP " + CRLF
   
   cQry += "FROM " + RETSQLNAME("SC5") + " C5 " + CRLF
   //COMENTADO POR FR - FLÁVIA ROCHA - POIS FOI INSERIDA NA SUBQUERY ACIMA
   //cQry += "LEFT JOIN " + RETSQLNAME("SC6") + " C6 " + CRLF     //FR - 15/08/2023 - Flávia Rocha - Sigamat Consultoria
   //cQry += "ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM " + CRLF   //FR - 15/08/2023 - Flávia Rocha - Sigamat Consultoria
   //COMENTADO POR FR - FLÁVIA ROCHA

   cQry += "LEFT JOIN " + RETSQLNAME("CB7") + " CB7 " + CRLF
   cQry += "ON CB7_FILIAL=C5_FILIAL AND CB7_PEDIDO=C5_NUM  " + CRLF
   //COMENTADO POR FR - FLÁVIA ROCHA - C6 FOI INSERIDA NA SUBQUERY ACIMA
   //cQry += "WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' '  " + CRLF
   cQry += "WHERE C5.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' '  " + CRLF
   
   //FR - 15/08/2023 - Flávia Rocha - Sigamat Consultoria
   //cQry += "AND C5_FILIAL='" +XFILIAL("SC5")+ "' AND C5_XTIPO='1' AND C6_QTDVEN-C6_QTDENT>0 AND C6_BLQ=' '  " + CRLF
   
   cQry += "AND C5_FILIAL='" +XFILIAL("SC5")+ "' AND C5_XTIPO='1' " + CRLF
   
   cQry += "AND C5_TIPOCLI<>'X' AND CB7_STATUS<='4' AND CB7_NOTA=' ' " + CRLF
   MemoWrite("C:\TEMP\EnvPrpPV.TXT" , cQry)

    if Select('TDIA') > 0
       TDIA->( dbCloseArea() )
    endif 

    tCQuery cQry New Alias 'TDIA'

    While TDIA->( !Eof() )
        cNome := Posicione("SA1",1,xFilial('SA1')+TDIA->C5_CLIENTE+TDIA->C5_LOJACLI,"A1_NOME")
        _nLinhas := TDIA->LINHAS 
        
        If _nLinhas > 0
         if TDIA->CB7_STATUS == '0'
            cStatus := "INICIO"
         ELSEIF TDIA->CB7_STATUS == '1'
            cStatus := "SEPARANDO"
         ELSEIF TDIA->CB7_STATUS == '2'
            cStatus := "SEP.FINAL"
         ELSEIF TDIA->CB7_STATUS == '3'
            cStatus := "EMBALANDO"
         ELSEIF TDIA->CB7_STATUS == '4'
            cStatus := "EMB.FINAL"
         ELSEIF TDIA->CB7_STATUS == '8'
            cStatus := "EMBARCADO"
         ELSEIF TDIA->CB7_STATUS == '9'
            cStatus := "EMBARQUE FINALIZADO"
         ELSE 
            cStatus := ""
         ENDIF 
           //Aadd( _aMsg , { TDIA->C5_NUM, ALLTRIM(cNome), cValToChar(TDIA->LINHAS), TDIA->CB7_ORDSEP, cStatus  } )
           Aadd( _aMsg , { TDIA->C5_NUM, ALLTRIM(cNome), cValToChar(_nLinhas), TDIA->CB7_ORDSEP, cStatus  } )
        Endif 
       TDIA->( dbSkip() )
    EndDo 

    if Select('TDIA') > 0
       TDIA->( dbCloseArea() )
    endif 

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
    	_cEmail  := 'valdemir.rabelo@sigamat.com.br'
	EndIf

	// Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
    // Cabecalho
    cMsg += '<TR BgColor=#FFFFFF>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> PEDIDO </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> CLIENTE </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> QTD.LINHAS </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> ORD.SEP. </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> STATUS </Font></B></TD>'
    cMsg += '</TR>'
	// Definicao do texto/detalhe do email                                        
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	// Definicao do rodape do email                                                
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(APIAGEPD)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
   //FR - TESTE
   //_cEmail += ";flavia.rocha76@outlook.com;flah.rocha@sigamat.com.br"
   //_cAssunto += " - KLEBER POR FAVOR, VALIDAR"
   //FR - TESTE
    if Len(_aMsg) > 0
	    U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg, cAttach)
    Endif 

Return




/*/{Protheus.doc} AGNDADIA
description
Rotina que fará o processamento dos registros diarios a serem enviado
@type function
@version   1.00
@author Valdemir Jose
@since 06/04/2021
@return return_type, return_description
/*/
Static Function AGNDADIA()
    Local cQry       := ""
    Local _cCopia    := ""
    Local cAttach    := ""
    Local cMsg       := ""
    Local _aMsg      := {}
    Local _cFa10Oper := GetMv("ST_FAOPER",, '74' )
    Local _cAssunto  := "WF - RELAÇÃO DE PENDENTES DO DIA"
    Local _cEmail    := GetMv("ST_EMLAGEN",.F.,"kleber.braga@steck.com.br")
    Local _nLin

    cQry += "SELECT DISTINCT C5_CLIENTE, C5_LOJACLI, C5_XEMAILR, C5_VEND2, ZS3.R_E_C_N_O_ REG " + CRLF
    cQry += "FROM " + RETSQLNAME("ZS3") + " ZS3 " + CRLF
    cQry += "INNER JOIN " + RETSQLNAME("SC5") + " SC5 " + CRLF
    cQry += "ON SC5.C5_FILIAL=ZS3.ZS3_FILIAL AND SC5.C5_NUM=ZS3.ZS3_PEDIDO AND SC5.C5_FILIAL='"+XFILIAL('SC5')+"' AND SC5.D_E_L_E_T_ = ' ' " + CRLF    
    cQry += "WHERE ZS3.D_E_L_E_T_ = ' '  " + CRLF
    cQry += " AND ZS3.ZS3_NOTAFI <> ' '  " + CRLF 
    cQry += " AND ZS3.ZS3_DATAGE = ' '   " + CRLF 
    cQry += " AND ZS3.ZS3_DATA = '" +DTOS(dDATABASE)+ "' " + CRLF    

    if Select('TDIA') > 0
       TDIA->( dbCloseArea() )
    endif 

    tCQuery cQry New Alias 'TDIA'

    While TDIA->( !Eof() )
        ZS3->( dbGoto( TDIA->REG ) )
       	Aadd( _aMsg , { ZS3->ZS3_CODIGO, DTOC(ZS3->ZS3_DATA), ZS3->ZS3_PEDIDO } )
       TDIA->( dbSkip() )
    EndDo 

    if Select('TDIA') > 0
       TDIA->( dbCloseArea() )
    endif 

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
    	_cEmail  := 'valdemir.rabelo@sigamat.com.br'
	EndIf

	// Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<Img Src="https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
    // Cabecalho
    cMsg += '<TR BgColor=#FFFFFF>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> PROTOCOLO </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> EMISSÃO </Font></B></TD>'
    cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial"> PEDIDO </Font></B></TD>'
    cMsg += '</TR>'
	// Definicao do texto/detalhe do email                                        
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	// Definicao do rodape do email                                                
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">(APIAGEPD)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg, cAttach)

Return 
