#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STEXCMAS
@description
Rotina para exclusão de compromisso em massa
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@param pRefer, variant, param_description
@return variant, return_description,
/*/
USER FUNCTION STEXCMAS()
    // Declarar variáveis Locais
    Local oColumn
    Local aCampos  := {}
    Local aColumns := {}
    Local cArqTrb
    Local nX
    Local lMarcar  := .F.
    Local cIndice1 := ""
    Local cIndice2 := ""
    Local cIndice3 := ""
    Local cIndice4 := ""
    Local bCarga   := "getCarga()"
    Local bCria    := "CriaTemp()"
    Local bExec    := {|| &bCria, &bCarga}
    Local bKeyF12  := {|| GetFiltro(bExec) }

    // Declarar variáveis privadas
    Private aSeek     := {}
    Private oBrowse   := Nil
    Private cCadastro := "Exclusão Compromisso em Massa"
    Private aRotina   := Menudef()  
     
    if !GetFiltro(bExec)
        Return
    endif 

    oBrowse:= FWMarkBrowse():New()
    oBrowse:SetDescription(cCadastro) //Titulo da Janela
    oBrowse:SetParam(bKeyF12) // Seta tecla F12
    
    oBrowse:SetAlias("TRB") //Indica o alias da tabela que será utilizada no Browse
    oBrowse:SetFieldMark("TR_OK") //Indica o campo que deverá ser atualizado com a marca no registro
    oBrowse:oBrowse:SetDBFFilter(.T.)
    oBrowse:oBrowse:SetUseFilter(.T.) //Habilita a utilização do filtro no Browse
    oBrowse:oBrowse:SetFixedBrowse(.T.)
    oBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
    oBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
    oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporária
    oBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
    oBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
    getColunas(oBrowse)

    //Permite adicionar legendas no Browse
    //oBrowse:AddLegend("Empty(TR_EX)" ,"GREEN","Registro Ativo")
    //oBrowse:AddLegend("!Empty(TR_EX)","RED"  ,"Registro Excluído")    

    //Adiciona botoes na janela
    oBrowse:AddButton("Excluir Registros" , { || stExcReg()  },,,, .F., 2 )
    //oBrowse:AddButton("Detalhes"          , { || MsgRun('Coletando dados de usuário(s)','Relatório',{|| U_RCFG0005() }) },,,, .F., 2 )
    //oBrowse:AddButton("Retornar"           , { || oBrowse:Close() },,,, .F., 2 )    

    oBrowse:bAllMark := { || stInvert(oBrowse:Mark(), lMarcar := !lMarcar ), oBrowse:Refresh(.T.)  }    

    //Método de ativação da classe
    oBrowse:Activate()
    
    oBrowse:oBrowse:Setfocus() //Seta o foco na grade

Return 

/*/{Protheus.doc} getColunas
@description
Rotina que fará a montagem das colunas
@type function
@version 1.00
@author Valdemir Jose
@since 16/07/2021
@param oBrowse, object, param_description
@return variant, return_description
/*/
Static Function getColunas(oBrowse)
    Local nC := 0

    SX3->( dbSetOrder(2) )
    oBrowse:SetColumns(MntCol("ZZJ_NUM"    ,"Compromisso"        ,03,"@!",0,006,0))
    oBrowse:SetColumns(MntCol("ZZJ_COD"    ,"Produto"            ,04,"@!",0,015,0))
    oBrowse:SetColumns(MntCol("ZZJ_OP"     ,"Referência"         ,05,"@!",0,TamSX3("ZZJ_OP")[1],0))
    oBrowse:SetColumns(MntCol("ZZJ_QUANT"  ,"Quant"              ,06,"@!",0,TamSX3("ZZJ_QUANT")[1],0))
    oBrowse:SetColumns(MntCol("ZZJ_DATA"   ,"Data Prev"          ,07,"@!",0,TamSX3("ZZJ_DATA")[1],0))
    oBrowse:SetColumns(MntCol("ZZJ_USUARI" ,"Usuario"            ,08,"@!",0,TamSX3("ZZJ_USUARI")[1],0))
    oBrowse:SetColumns(MntCol("ZZJ_NOME"   ,"Nome"               ,09,"@!",0,TamSX3("ZZJ_NOME")[1],0))
    oBrowse:SetColumns(MntCol("ZZJ_ALTER"  ,"Alteração"          ,10,"@!",0,TamSX3("ZZJ_ALTER")[1],0))
    
Return 

/*/{Protheus.doc} STEXCLEG
description
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
Static Function STEXCLEG()
    Local oLegenda  :=  FWLegend():New()

    oLegenda:Add( '', 'BR_VERDE'   , "Registros Ativo" )
    oLegenda:Add( '', 'BR_VERMELHO', "Registros Excluídos")
    
    oLegenda:Activate()
    oLegenda:View()
    oLegenda:DeActivate()
Return Nil


/*/{Protheus.doc} CriaTemp
@description
Rotina que irá criar a tabela temporaria
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
Static Function CriaTemp()
    Local aCampos := ZZJ->( dbStruct() )
    Local oTable
    Local cAlias := ""

    aAdd(aCampos, aClone(aCampos[5]))
    aCampos[Len(aCampos)][1] := "TR_RG"
    aAdd(aCampos, aClone(aCampos[17]))
    aCampos[Len(aCampos)][1] := "TR_EX"
    aAdd(aCampos, aClone(aCampos[17]))
    aCampos[Len(aCampos)][1] := "TR_OK"

    If (Select("TRB") <> 0)
        dbSelectArea("TRB")
        TRB->(dbCloseArea ())
        oTable:Delete()
    Endif  

    //cArqTrb   := CriaTrab(aCampos,.T.) //Função CriaTrab descontinuada, adicionado o oTable no lugar
    oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
    oTable:SetFields(aCampos)				//adicionado\Ajustado
    oTable:Create()							//adicionado\Ajustado
    cAlias	:= oTable:GetAlias()			//adicionado\Ajustado
    cArqTrb	:= oTable:GetRealName()			//adicionado\Ajustado

    //Criar indices
    cIndice1 := Alltrim(CriaTrab(,.F.))
    cIndice2 := cIndice1
    cIndice3 := cIndice1
    cIndice4 := cIndice1   

    cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
    cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"
    cIndice3 := Left(cIndice3,5) + Right(cIndice3,2) + "C"
    cIndice4 := Left(cIndice4,5) + Right(cIndice4,2) + "D"     

    //Se indice existir excluir
    If File(cIndice1+OrdBagExt())
        FErase(cIndice1+OrdBagExt())
    EndIf
    If File(cIndice2+OrdBagExt())
        FErase(cIndice2+OrdBagExt())
    EndIf
    If File(cIndice3+OrdBagExt())
        FErase(cIndice3+OrdBagExt())
    EndIf
    If File(cIndice4+OrdBagExt())
        FErase(cIndice4+OrdBagExt())
    EndIf      

    //A função dbUseArea abre uma tabela de dados na área de trabalho atual ou na primeira área de trabalho disponível
    dbUseArea(.T.,"TOPCONN",cArqTrb,cAlias,Nil,.F.)

    //A função IndRegua cria um índice temporário para o alias especificado, podendo ou não ter um filtro
    IndRegua("TRB", cIndice1, "ZZJ_NUM" ,,, "Indice Compromisso...")
    IndRegua("TRB", cIndice2, "ZZJ_COD" ,,, "Indice Produto...")
    IndRegua("TRB", cIndice3, "ZZJ_OP"  ,,, "Indice Referência...")
    IndRegua("TRB", cIndice4, "ZZJ_DATA",,, "Indice Data...")    

    //Fecha todos os índices da área de trabalho corrente.
    dbClearIndex()

    //Acrescenta uma ou mais ordens de determinado índice de ordens ativas da área de trabalho.
    dbSetIndex(cIndice1+OrdBagExt())
    dbSetIndex(cIndice2+OrdBagExt())
    dbSetIndex(cIndice3+OrdBagExt())
    dbSetIndex(cIndice4+OrdBagExt())

Return 

/*/{Protheus.doc} getCarga
@description
Rotina que irá popular a tabela temporaria.
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@param pRefer, variant, param_description
@return variant, return_description
/*/
Static Function getCarga()
    Local cQry  := ""
    Local nC    := 0
    Local aAre1 := GetArea()

    cQry := "SELECT A.*,A.R_E_C_N_O_ REG FROM " + RETSQLNAME("ZZJ") + " A " + CRLF 
    cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF 
    cQry += " AND A.ZZJ_FILIAL ='" + XFILIAL("ZZJ") + "' " + CRLF 
    cQry += " AND ZZJ_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF 
    cQry += " AND A.ZZJ_OP LIKE '" + ALLTRIM(MV_PAR03)+"%' " + CRLF 
    cQry += "ORDER BY ZZJ_NUM " + CRLF 

    If Select("TZZJ") > 0
       TZZJ->( dbCloseArea() )
    endif 

    TcQuery cQry New Alias "TZZJ"
    TCSetField( 'TZZJ', 'ZZJ_DATA',   'D', TamSX3('ZZJ_DATA')[01], TamSX3('ZZJ_DATA')[02] ) 
    TCSetField( 'TZZJ', 'ZZJ_REPRO',  'D', TamSX3('ZZJ_DATA')[01], TamSX3('ZZJ_DATA')[02] ) 
    TCSetField( 'TZZJ', 'ZZJ_DTCHEG', 'D', TamSX3('ZZJ_DATA')[01], TamSX3('ZZJ_DATA')[02] ) 
    TCSetField( 'TZZJ', 'ZZJ_EMBAR',  'D', TamSX3('ZZJ_DATA')[01], TamSX3('ZZJ_DATA')[02] ) 
    TCSetField( 'TZZJ', 'ZZJ_MHISTO', 'M', TamSX3('ZZJ_MHISTO')[01], TamSX3('ZZJ_MHISTO')[02] ) 

    While TZZJ->( !Eof() )
        RecLock("TRB",.T.)
        For nC := 1 to TZZJ->(FCount() )
            cCampo := TZZJ->( Field(nC) )
            TRB->&cCampo := TZZJ->&cCampo
        Next 
        TRB->TR_RG := TZZJ->REG 
        TRB->( MsUnlock() )
        TZZJ->( dbSkip() )
    EndDo

    If Select("TZZJ") > 0
       TZZJ->( dbCloseArea() )
    endif 

    if TRB->( !Eof() )
        //Irei criar a pesquisa que será apresentada na tela
        aAdd(aSeek,{"Compromisso",{{"","C",TamSX3("ZZJ_NUM")[1] ,0,"ZZJ_NUM"    ,"@!"}} } )
        aAdd(aSeek,{"Produto"    ,{{"","C",TamSX3("ZZJ_COD")[1] ,0,"ZZJ_COD"    ,"@!"}} } )
        aAdd(aSeek,{"Referencia" ,{{"","C",TamSX3("ZZJ_OP")[1]  ,0,"ZZJ_OP"     ,"@!"}} } )
        aAdd(aSeek,{"Data Prev"  ,{{"","D",TamSX3("ZZJ_DATA")[1],0,"ZZJ_DATA"   ,"@!"}} } )    
    endif 

    RestArea( aAre1 )

Return

/*/{Protheus.doc} MntCol
@description
Rotina que monta coluna por campos informados
@type function
@version 1.00 
@author Valdemir Jose
@since 16/07/2021
@param cCampo, character, param_description
@param cTitulo, character, param_description
@param nArrData, numeric, param_description
@param cPicture, character, param_description
@param nAlign, numeric, param_description
@param nSize, numeric, param_description
@param nDecimal, numeric, param_description
@return variant, return_description
/*/
Static Function MntCol(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
    Local aColumn
    Local bData      :={||}
    Default nAlign   := 1
    Default nSize    := 20
    Default nDecimal := 0
    Default nArrData := 0
        
    If nArrData > 0
        bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
    EndIf
    
    /* Array da coluna
    [n][01] Título da coluna
    [n][02] Code-Block de carga dos dados
    [n][03] Tipo de dados
    [n][04] Máscara
    [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
    [n][06] Tamanho
    [n][07] Decimal
    [n][08] Indica se permite a edição
    [n][09] Code-Block de validação da coluna após a edição
    [n][10] Indica se exibe imagem
    [n][11] Code-Block de execução do duplo clique
    [n][12] Variável a ser utilizada na edição (ReadVar)
    [n][13] Code-Block de execução do clique no header
    [n][14] Indica se a coluna está deletada
    [n][15] Indica se a coluna será exibida nos detalhes do Browse
    [n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
    */
    aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}



/*/{Protheus.doc} STInvert
@description
Rotina que controlará o marca e desmarca
@type function
@version  1.00
@author Valdemir Jose
@since 16/07/2021
@param cMarca, character, param_description
@param lMarcar, logical, param_description
@return variant, return_description
/*/
Static Function STInvert(cMarca, lMarcar)
    Local cAliasSD1 := 'TRB'
    Local aAreaSD1  := (cAliasSD1)->( GetArea() )

    dbSelectArea(cAliasSD1)
    (cAliasSD1)->( dbGoTop() )
    While !(cAliasSD1)->( Eof() )
        RecLock( (cAliasSD1), .F. )
        (cAliasSD1)->TR_OK := IIf( lMarcar, cMarca, '  ' )
        MsUnlock()
        (cAliasSD1)->( dbSkip() )
    EndDo

    RestArea( aAreaSD1 )

Return .T.

/*/{Protheus.doc} MenuDef
description
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
Static Function MenuDef()
    Local aRot := {}
    
    ADD OPTION aRot TITLE "Excluir Registros" ACTION "U_MCFG006M()"  OPERATION 6 ACCESS 0
    //ADD OPTION aRot TITLE "Detalhes"          ACTION "MsgRun('Coletando dados de usuário(s)','Relatório',{||  })"  OPERATION 6 ACCESS 0
    //ADD OPTION aRot TITLE "Legenda"         ACTION ""  OPERATION 6 ACCESS 0

Return(Aclone(aRot))

/*/{Protheus.doc} stExcReg
description
@type function
@version  
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
Static Function stExcReg()
    Local nSelec := 0
    TRB->( dbEVal({|| if(!Empty(TRB->TR_OK),nSelec++,)},,{|| !Eof() }))
    if nSelec > 0
        Processa( {|| stExc001() },"Processando","Excluindo registros, aguarde.")
    else
       MsgRun("Não foi selecionado nenhum registro", "Atenção!", {|| Sleep(3000)}) 
    Endif 
Return 


/*/{Protheus.doc} stExc001
@description
Rotina que fará a exclusão em massa
@type function
@version  1.00
@author Valdemir Jose
@since 16/07/2021
@return variant, return_description
/*/
Static Function stExc001()
    Local nTotal := 0
    dbSelectArea("TRB")
    Count To nTotal
    ProcRegua(nTotal)
    TRB->( dbGoTop() )
    While TRB->(! Eof() )
        IncProc()
        if !Empty(TRB->TR_OK) 
           ZZJ->( dbGoto(TRB->TR_RG))
           RecLock("ZZj",.f.)
           ZZJ->(dbDelete())
           ZZJ->(MsUnlock())
           RecLock("TRB",.F.)
           TRB->(dbDelete())
           TRB->(MsUnlock())
        Endif 
        TRB->( dbSkip() )
    EndDo 
    TRB->( dbGoTop() )
    oBrowse:oBrowse:Refresh()
    

Return 

/*/{Protheus.doc} GetFiltro
@description
Rotina que irá filtrar os dados
@type function
@version  
@author Valdemir Jose
@since 18/07/2021
@param bExec, codeblock, param_description
@return variant, return_description
/*/
Static Function GetFiltro(bExec)
    _aParamBox := {}
    _aRet      := {}
    lRET       := .T.
    
   	AADD(_aParamBox,{1,"Compromisso De" 	,Space(6)	,"@!"				,"","",".T.",50,.F.})
   	AADD(_aParamBox,{1,"Compromisso Até" 	,"ZZZZZZ"	,"@!"				,"","",".T.",50,.T.})
   	AADD(_aParamBox,{1,"Referência" 	    ,Space(240)	,"@!"				,"","",".T.",50,.T.})

    lRET := ParamBox(_aParamBox,"Informe os Dados para Filtrar",@_aRet,,,.T.,,500)   

    if lRET 
       FWMsgRun(,{|| EVal(bExec) },"Aguarde","Filtrando Registros" )
       //TRB->( dbGoBottom() )
       TRB->( dbGoTop() )   
       if oBrowse != nil 
          oBrowse:oBrowse:Refresh()
       endif     
    Endif 

Return lRET
