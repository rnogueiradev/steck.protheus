#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} STMTR850
    description
    Relacao Das Ordens de Producao
    @type function
    @version 
    @author Valdemir Jose
    @since 30/09/2020
    @return return_type, return_description
    u_STMTR850
/*/
User Function STMTR850()
    Local oReport

    Private cAliasSC2 := GetNextAlias()

    // Interface de impressao                                                  
    oReport:= ReportDef()
    oReport:PrintDialog()

Return



/*/{Protheus.doc} ReportDef
    description
    A funcao estatica ReportDef devera ser criada para todos os
    relatorios que poderao ser agendados pelo usuario.
    @type function
    @version 
    @author Valdemir Jose
    @since 30/09/2020
    @return return_type, return_description
/*/
Static Function ReportDef()
    Local nTamOp   := TamSX3( 'D3_OP' )[1]+2
    Local nTamProd := TamSX3( 'C2_PRODUTO' )[1]
    Local nTamSld  := TamSX3( 'C2_QUANT' )[1]
    Local cPictQtd := PesqPictQt("C2_QUANT")
    Local aOrdem   :=  {"Por o.p.", "Por produto", "Por C. De Custo"}
    Local oReport
    Local oOp

    /*
        Criacao do componente de impressao                                      
        TReport():New                                                           
        ExpC1 : Nome do relatorio                                               
        ExpC2 : Titulo                                                          
        ExpC3 : Pergunte                                                        
        ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  
        ExpC5 : Descricao                                                       
    */
    oReport:= TReport():New("MATR850","Relação das Ordens de Produção","MTR850", {|oReport| ReportPrint(oReport,@cAliasSC2)},"Este programa irá imprimir a Relação das Ordens de Produção.")
    If nTamProd > 15
        oReport:SetLandscape() 
    EndIf
    /*
         Verifica as perguntas selecionadas                           
         Variaveis utilizadas para parametros                         
         mv_par01        	// Da OP                                 
         mv_par02        	// Ate a OP                              
         mv_par03        	// Do Produto                            
         mv_par04        	// Ate o Produto                         
         mv_par05        	// Do Centro de Custo                    
         mv_par06        	// Ate o Centro de Custo                 
         mv_par07        	// Da data                               
         mv_par08        	// Ate a data                            
         mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     
         mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    
         mv_par11            // Impr. OP's Firmes, Previstas ou Ambas 
    */
    Pergunte(oReport:uParam,.F.)

    /*
        Criacao da secao utilizada pelo relatorio                                                                                                             
        TRSection():New                                                         
        ExpO1 : Objeto TReport que a secao pertence                             
        ExpC2 : Descricao da seçao                                              
        ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   
                sera considerada como principal para a seção.                   
        ExpA4 : Array com as Ordens do relatório                                
        ExpL5 : Carrega campos do SX3 como celulas                              
                Default : False                                                 
        ExpL6 : Carrega ordens do Sindex                                        
                Default : False                                                 
    */

    // Sessao 1 (oOp)                                               
    oOp := TRSection():New(oReport,"Ordens de Produção",{"SC2","SB1"},aOrdem)    
    oOp:SetTotalInLine(.F.)

    TRCell():New(oOp,'OP'			,'SC2',"Número",          /*Picture*/	,nTamOp		              ,/*lPixel*/, {|| (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) } )
    TRCell():New(oOp,'C2_PRODUTO'	,'SC2',"Produto",         /*Picture*/	,TamSX3('C2_PRODUTO')[1]+4,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'B1_DESC'		,'SB1',"Descrição",       /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'G2_OPERAC'    ,'SG2',"Oper.",           /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'G2_RECURSO'   ,'SG2',"Num.Maq.",        /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'G2_DESCRI'    ,'SG2',"Descrição",       /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'H1_DESCRI'    ,'SH1',"Nome Recurso",    /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'G2_LOTEPAD'   ,'SG2',"Peças/Horas",     /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'C2_CC'		,'SC2',"Centro De Custo", /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'C2_EMISSAO'	,'SC2',"Emissão",         /*Picture*/	,TamSX3('C2_EMISSAO')[1]+4,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'C2_DATPRF'	,'SC2',"Dt. prevista",    /*Picture*/	,TamSX3('C2_DATPRF')[1]+4 ,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'C2_DATRF'		,'SC2',"Dt. Real",        /*Picture*/	,TamSX3('C2_DATRF')[1]+4  ,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'C2_QUANT'		,'SC2',"Quant. Original", /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    TRCell():New(oOp,'SALDO'		,'SC2',"Saldo A Entregar", cPictQtd		,nTamSld	,/*lPixel*/,{|| IIf(Empty((cAliasSC2)->C2_DATRF),aSC2Sld(cAliasSC2),0) } )
    //TRCell():New(oOp,'G2TEMPO'      ,'SG2',"Tempo Produção",   /*Picture*/	,/*Tamanho*/,/*lPixel*/,{|| AjusTempo('H') } /*{|| code-block de impressao }*/)
    //TRCell():New(oOp,'G2TMPC'       ,'SG2',"Tempo Prd.Cent.",   /*Picture*/	,/*Tamanho*/,/*lPixel*/,{|| AjusTempo('C') } /*{|| code-block de impressao }*/)
    If ! __lPyme
        TRCell():New(oOp,'C2_STATUS','SC2',"Status",           /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
        TRCell():New(oOp,'C2_TPOP'	,'SC2',"Tipo",             /*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
    EndIf

    oOp:SetHeaderPage()

Return(oReport)



/*/{Protheus.doc} ReportPrint
    description
    A funcao estatica ReportPrint devera ser criada para todos
    os relatorios que poderao ser agendados pelo usuario
    @type function
    @version 
    @author Valdemir Jose
    @since 30/09/2020
    @param oReport, object, param_description
    @param cAliasSC2, character, param_description
    @return return_type, return_description
/*/
Static Function ReportPrint(oReport,cAliasSC2)
    Local oOp        := oReport:Section(1)
    Local nOrdem     := oOp:GetOrder()
    Local cFilterUsr := ""
    Local oBreak

    Local cWhere01   := "",cWhere02:="",cWhere03:=""
    Local cSpace     := Space(TamSx3("C2_DATRF")[1])
    Local aStrucSC2  := SC2->(dbStruct())
    Local cSelectUsr := ""
    Local cSelect    := ""
    Local aFieldUsr  := {}
    Local nCnt       := 0
    Local nPos       := 0

    // Acerta o titulo do relatorio                                 
    oReport:SetTitle(oReport:Title()+IIf(nOrdem==1," - Por O.P.",IIf(nOrdem==2," - Por Produto"," - Por Centro de Custo"))) 

    // Definicao da linha de SubTotal                               
    If nOrdem == 2
        oBreak := TRBreak():New(oOp,oOp:Cell("C2_PRODUTO"),"Total ---->",.F.)
    EndIf	

    If nOrdem == 2
        TRFunction():New(oOp:Cell('C2_QUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
        TRFunction():New(oOp:Cell('SALDO'		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
    EndIf

    dbSelectArea("SC2")
    dbSetOrder(nOrdem)

    // Esta rotina foi escrita para adicionar no select os campos         
    // adicionados pelo usuario.                                          
    cSelectUsr := "%"
    cSelect := "C2_FILIAL,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_DATRF,C2_CC,C2_EMISSAO,C2_DATPRF,C2_QUANT,"
    cSelect += "C2_QUJE,C2_PERDA,C2_STATUS,C2_TPOP,SC2.R_E_C_N_O_ SC2RECNO, SG2.G2_OPERAC, SG2.G2_RECURSO,SG2.G2_DESCRI," 
    cSelect += "SG2.G2_LOTEPAD,SH1.H1_DESCRI" 
    aFieldUsr:= R850UsrSC2(oOP)

    For nCnt:=1 To Len(aFieldUsr)
        If ( nPos:=Ascan(aStrucSC2,{|x| AllTrim(x[1])==aFieldUsr[nCnt]}) ) > 0
            If aStrucSC2[nPos,2] <> "M"  
                If !aStrucSC2[nPos,1] $ cSelectUsr .And. !aStrucSC2[nPos,1] $ cSelect
                    cSelectUsr += ","+aStrucSC2[nPos,1] 
                Endif 	
            EndIf
        EndIf 			       	
    Next
    cSelectUsr += "%"

    // Condicao Where para C2_STATUS                                
    cWhere01 := "%"
    If mv_par10 == 1
        cWhere01 += "'S'"
    ElseIf mv_par10 == 2
        cWhere01 += "'U'"
    ElseIf mv_par10 == 3
        cWhere01 += "'S','U','D','N',' '"
    EndIf
    cWhere01 += "%"

    // Condicao Where para C2_TPOP                                  
    cWhere02 := "%"
    If mv_par11 == 1
        cWhere02 += "'F'"
    ElseIf mv_par11 == 2
        cWhere02 += "'P'"
    ElseIf mv_par11 == 3
        cWhere02 += "'F','P'"
    EndIf	
    cWhere02 += "%"

    // Condicao Where para filtrar a condicao da OP(Em Aberto / Encerrada / Todas)
    cWhere03 := "%"
    If mv_par09 == 1
        cWhere03 += " SC2.C2_DATRF =  '"+cSpace+"' AND "
    ElseIf mv_par09 == 2
        cWhere03 += " SC2.C2_DATRF <> '"+cSpace+"' AND "
    EndIf	

    cFilterUsr := oOP:GetSqlExp("SC2")
    If !Empty(cFilterUsr)
        cWhere03 := cWhere03 + " (" + cFilterUsr + ")" + " AND "
    Endif
    
    cFilterUsr := oOP:GetSqlExp("SB1")
    If !Empty(cFilterUsr)
        cWhere03 := cWhere03 + " (" + cFilterUsr + ")" + " AND "
    Endif
    cWhere03 += "%"

    //Transforma parametros Range em expressao SQL                            
    MakeSqlExpr(oReport:uParam)

    //Inicio do Embedded SQL                                                  
    BeginSql Alias cAliasSC2

        Column C2_DATPRF  as Date
        Column C2_DATRF   as Date
        Column C2_EMISSAO as Date
        Column C2_DATPRI  as Date		
        Column C2_DATAJI  as Date
        Column C2_DATAJF  as Date
        Column C2_DTUPROG as Date
        
        SELECT C2_FILIAL,C2_PRODUTO,C2_NUM,C2_ITEM,C2_SEQUEN,C2_ITEMGRD,C2_DATRF,C2_CC,
            C2_EMISSAO,C2_DATPRF,C2_QUANT,C2_QUJE,C2_PERDA,C2_STATUS,C2_TPOP,
            SC2.R_E_C_N_O_ SC2RECNO, SG2.G2_OPERAC, SG2.G2_RECURSO,SG2.G2_DESCRI, SG2.G2_LOTEPAD,
            SH1.H1_DESCRI
            %Exp:cSelectUsr%
        
        FROM %table:SC2% SC2, %table:SB1% SB1, %table:SG2% SG2, %table:SH1% SH1

        WHERE  SC2.C2_FILIAL = %xFilial:SC2%  AND
            SB1.B1_FILIAL    = %xFilial:SB1%  AND
            SG2.G2_FILIAL    = %xFilial:SG2%  AND
            SH1.H1_FILIAL    = %xFilial:SH1%  AND
            SC2.C2_PRODUTO   = SB1.B1_COD     AND
            SG2.G2_PRODUTO   = SC2.C2_PRODUTO AND 
            SG2.G2_CODIGO    = SC2.C2_ROTEIRO AND 
            SH1.H1_CODIGO    = G2_RECURSO     AND 
            SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD >= %Exp:mv_par01% AND
            SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD <= %Exp:mv_par02% AND
            SC2.C2_PRODUTO  >= %Exp:mv_par03% AND SC2.C2_PRODUTO <= %Exp:mv_par04% AND
            SC2.C2_CC       >= %Exp:mv_par05% AND SC2.C2_CC      <= %Exp:mv_par06% AND
                SC2.C2_EMISSAO  >= %Exp:mv_par07% AND SC2.C2_EMISSAO <= %Exp:mv_par08% AND
            SC2.C2_STATUS IN (%Exp:cWhere01%) AND SC2.C2_TPOP IN (%Exp:cWhere02%)  AND
                %Exp:cWhere03%
                SC2.%NotDel% AND
                    SB1.%NotDel% AND
                    SG2.%NotDel% AND
                    SH1.%NotDel%

    ORDER BY %Order:SC2%
        
    EndSql

    oReport:Section(1):EndQuery()

    // Abertura do arquivo de trabalho                              
    dbSelectArea(cAliasSC2)

    TRPosition():New(oOp,"SB1",1,{|| xFilial("SB1") + (cAliasSC2)->C2_PRODUTO} )
    oOp:SetLineCondition({|| MtrAValOP(mv_par11,'SC2',cAliasSC2) } )

    //Impressao do Relatorio 
    oOp:Print()

Return Nil




/*/{Protheus.doc} R850UsrSC2
    description
    Retorna celulas informadas pelo usuário que deveram 
    compor a select na tabela SC2 
    @type function
    @version 
    @author Valdemir Jose
    @since 30/09/2020
    @param oObj, object, param_description
    @return return_type, return_description
/*/
Static Function R850UsrSC2(oObj)
    Local aFieldUsr := {}
    Local nCntFor   := 0

    For nCntFor:=1 To Len(oObj:ACell)
        If oObj:Acell[nCntFor]:lUserField
            If "C2_" == Left(oObj:Acell[nCntFor]:cName,3)
                Aadd(aFieldUsr, Alltrim(oObj:Acell[nCntFor]:cName))
            EndIf
        EndIf
    Next nCntFor

Return aFieldUsr


/*/{Protheus.doc} AjusTempo
description
Conversão para horas
@type function
@version 
@author Valdemir Jose
@since 30/09/2020
@return return_type, return_description
/*/
Static Function AjusTempo(pTipo)
    Local cRET
    Local nQtde   := aSC2Sld(cAliasSC2)
    Local nTmpTot := (nQtde / (cAliasSC2)->G2_LOTEPAD) * 0.6
    LOCAL cTempo  := Alltrim(CVALTOCHAR(nTmpTot))
    
    cTempo  := Substr(cTempo,1,At(".",cTempo)+2)
    	
    if At(".",Alltrim(Str(nTmpTot))) > 0
        nTam := Len(alltrim(Left(cTempo, At(".",cTempo)-1 )))
        if nTam < 2
           nTam := 2
        endif 
		//cTempo := Substr(Alltrim(Str(nTmpTot)),1,At(".",Alltrim(Str(nTmpTot)))+2)
		cTempo := StrZero(Val(alltrim(Left(cTempo, At(".",cTempo)-1 ))),nTam)+":"+Right(alltrim(Transform(val(cTempo),"@R 99.99") ),2)
		cTempo := cTempo+":00"
	else 
        nTam := Len(Alltrim(cValToChar(nTmpTot)))
        if nTam < 2
           nTam := 2
        endif
		cTempo  := Alltrim(StrZero(nTmpTot,nTam))+":00:00"
	endif     
    if pTipo=="H"
        cRET := cTempo  
    else
        cRET := nTmpTot
    endif 

Return cRET
