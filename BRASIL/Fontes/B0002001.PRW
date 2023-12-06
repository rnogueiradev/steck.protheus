#include 'totvs.ch'


/*/{Protheus.doc} B0002001
Atualização do armazém conforme
cadastro de cliente.
@type function
@version 1.0
@author marcio.katsumata
@since 17/10/2022
/*/
user function B0002001()

    private cFilBkp    as character
    private cCliDe     as character
    private cLojaDe    as character
    private cCliAte    as character
    private cLojaAte   as character
    private cPedDe     as character
    private cPedAte    as character
    private dDtEmisDe  as date
    private dDtEmisAte as date
    private cFilDe     as character
    private cFilAte    as character

    cFilBkp := cFilAnt

    if Aviso("Reprocessamento armazém do cliente nos pedidos",;
             "Esta rotina tem por objetivo verificar o armazém do cliente e atualizar nos pedidos em aberto",;
             {"Prossseguir", "Cancelar"},1) == 1 .and. parametros()

        processa({||procPedido()},"Executando" ) 

    endif

    cFilAnt := cFilBkp
    FWSm0Util():setSm0PositionBycFilAnt()
return




/*/{Protheus.doc} parametros
Parâmetros da rotina de atualização do armazém
@type function
@version  1.0
@author marcio.katsumata
@since 22/09/2022
@return logical, retorno da confirmação do parambox
/*/
static function parametros()


	local aParamBox  as array
	local aRet       as array
	local lConfirmado as logical

	aParamBox := {}
	aRet      := {}

	//-------------------------------------------------------------------------
	//Definção dos parâmetros do parambox
	//------------------------------------------------------------------------
	aAdd(aParamBox,{9,"Atualização de armazém do cliente nos pedidos: " ,150,7,.T.})
	aAdd(aParamBox,{1,"Cliente De " ,space(tamSx3("A1_COD")[1]),"","","SA1","",50,.F.})
	aAdd(aParamBox,{1,"Loja De " ,space(tamSx3("A1_LOJA")[1]),"","","","",50,.F.})
	aAdd(aParamBox,{1,"Cliente Ate " ,space(tamSx3("A1_COD")[1]),"","","SA1","",50,.T.})
	aAdd(aParamBox,{1,"Loja Ate " ,space(tamSx3("A1_LOJA")[1]),"","","","",50,.T.})
    aAdd(aParamBox,{1,"Emissão De " ,stod(""),"","","","",50,.F.})
    aAdd(aParamBox,{1,"Emissão Ate " ,stod(""),"","","","",50,.F.})
    aAdd(aParamBox,{1,"Pedido De " ,space(tamSx3("C5_NUM")[1]),"","","SC5","",50,.F.})
    aAdd(aParamBox,{1,"Pedido Ate " ,space(tamSx3("C5_NUM")[1]),"","","SC5","",50,.T.})
    aAdd(aParamBox,{1,"Filial De " ,space(tamSx3("C5_FILIAL")[1]),"","","SM0","",50,.F.})
    aAdd(aParamBox,{1,"Filial Ate " ,space(tamSx3("C5_FILIAL")[1]),"","","SM0","",50,.T.})

	If (lConfirmado := ParamBox(aParamBox,"Parâmetros",@aRet))
		cCliDe     := aRet[2]
		cLojaDe    := aRet[3]
		cCliAte    := aRet[4]
		cLojaAte   := aRet[5]
        dDtEmisDe  := aRet[6]
        dDtEmisAte := aRet[7]
        cPedDe     := aRet[8]
        cPedAte    := aRet[9]
        cFilDe     := aRet[10]
        cFilAte    := aRet[11]
	endif


	aSize(aParambox,0)
	aSize(aRet,0)

return lConfirmado

/*/{Protheus.doc} procPedido
Processa pedidos de venda
@type function
@version  1.0
@author marcio.katsumata
@since 17/10/2022
/*/
static function procPedido()

    local cAliasPed as character
    local nRecAtu   as numeric
    local nTotRec   as numeric
    local aAreas    as array
    local cQuery    as character
    private altera  as logical
    private inclui  as logical
    private aHeader    as array
    private aCols      as array

    aAreas    := {getArea(), SC5->(getArea()), SC6->(getArea())}
    inclui    := .F.
    altera    := .T.
    cAliasPed := getNextAlias()
    nRecAtu   := 1
    cWhereEmis := "% "+iif(!empty(dDtEmisAte), "SC5.C5_EMISSAO              BETWEEN '"+dtos(dDtEmisDe)+"' AND '"+dtos(dDtEmisAte)+"' AND ",;
                       iif(!empty(dDtEmisDe), "SC5.C5.EMISSAO >= '"+dtos(dDtEmisDe)+"' AND ",""))+" %"

    beginSql alias cAliasPed 
        SELECT R_E_C_N_O_ AS REGISTRO
        FROM %table:SC5% SC5
        WHERE SC5.C5_CLIENTE||SC5.C5_LOJACLI BETWEEN %exp:cCliDe+cLojaDe%  AND %exp:cCliAte+cLojaAte% AND
              %exp:cWhereEmis%
              SC5.C5_NUM                  BETWEEN %exp:cPedDe%          AND %exp:cPedAte%          AND
              SC5.C5_LIBEROK = %exp:space(tamSx3("C5_LIBEROK")[1])%     AND
              SC5.C5_ZMOTREJ = %exp:space(tamSx3("C5_ZMOTREJ")[1])%     AND 
              SC5.C5_ZFATBLQ = '3'                                      AND  
              SC5.C5_FILIAL  BETWEEN %exp:cFilDe%    AND  %exp:cFilAte% AND           
              SC5.%notDel%                  
    endSql

    nTotRec := contar(cAliasPed, "!eof()")
    ProcRegua(nTotRec)
    (cAliasPed)->(dbGoTop())

    while (cAliasPed)->(!eof())

        IncProc("Processando registro "+alltrim(cValToChar(nRecAtu))+" de "+alltrim(cValToChar(nTotRec)))
        
        cFilAnt := cFilBkp
        FWSm0Util():setSm0PositionBycFilAnt()

        SC5->(dbGoTo((cAliasPed)->REGISTRO)) 
        RegToMemory("SC5", .F.)

		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+SC5->C5_FILIAL+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

        FillGetDados(4,"SC6",1,SC5->(C5_FILIAL+C5_NUM), {|| C6_FILIAL+C6_NUM },{{ {|| .T. }, {|| .T. }, {|| .T. }}},{},/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,{|| .T.},/*bBeforeCols*/,/*bAfterHeader*/,"SC6")
        //---------------------------------------------
        //Chamada do ponto de entrada M410STTS para
        //a gravação do armazém do cliente no pedido
        //---------------------------------------------
        U_M410STTS()
        
        nRecAtu++
        aSize(aCols,0)
        aSize(aHeader,0)
        (cAliasPed)->(dbSkip())
    enddo

    (cAliasPed)->(dbCloseArea())

    aEval(aAreas, {|aArea|restArea(aArea)})
    aSize(aAreas,0)

return
