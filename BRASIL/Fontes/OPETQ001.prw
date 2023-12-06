#Include "Protheus.ch"


/*/{Protheus.doc} OPETQ001
description
@type function
@version 
@author Valdemir Jose
@since 09/07/2020
@return return_type, return_description
 
/*/
User Function OPETQ001()
    Local aParam   := {}
    Local aConfig  := {}
    Private aModelo:= {"Abastecimento-1","Pallet-2","Blister"}
    Private _cProd := ""
    Private _nQtde := 0
    Private _cImpr := ""
    Private _nMode := 1
    Private nLin   := 0
    Private nCol   := 0

	aAdd(aParam,{1,"Produto:"		,Space(TamSx3("B1_COD")[1])	    ,"@!"     ,".T.","SB5","",70,.T.})
	aAdd(aParam,{1,"Qtde.Etiq.:"	,Space(4)	                    ,"@E 9999",".T.",""   ,"",70,.T.})
	aAdd(aParam,{1,"Impressora:"	,Space(6)	                    ,"@!"     ,".T.","CB5","",70,.T.})
    aAdd(aParam,{2,"Modelo Etiqueta","Abastecimento-1",aModelo,70,"",.T.})
	aAdd(aParam,{1,"Quantidade:"	,Space(4)	                    ,"@E 9999",".T.",""   ,"",70,.F.})
	aAdd(aParam,{1,"Volume:"    	,Space(4)	                    ,"@E 9999",".T.",""   ,"",70,.F.})

	If !ParamBox(aParam,"Impressão Etiqueta [ Filtro ]",@aConfig, {|| VLDINFOS()},,.F.,90,15)
		Return
	EndIf    

    FWMsgRun(,{|| OPETQPROC() },'Aguarde','Imprimindo Etiqueta')

Return


/*/{Protheus.doc} OPETQPROC
description
   Preparando dados para impressão
@type function
@version 
@author Valdemir Jose
@since 09/07/2020
@return return_type, return_description
/*/
Static Function OPETQPROC()
    Local cPorta                 := "LPT1"
    Local ccxmet
    Local i                      := 0
    Local _cCodEan14             := ""
    Local cdesc1, cdesc2, cdesc3 := ""
    Local nX
    
    _nMode := aScan(aModelo, {|X| X==MV_PAR04 })

    if ValType(_nMode) == "C"
       _nMode := Val(Right(_nMode,1))
    endif 
    
    if _nMode == 1
        DbSelectArea("SB5")
        DbSetOrder(1)
        If !DbSeek( xFilial("SB5") + _cProd )
            FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não Cadastrado na Tabela de Complementos.(SB5)")
            Return
        EndIf
    else 
        DbSelectArea("SB1")
        DbSetOrder(1)
        if !DbSeek( xFilial("SB1") + _cProd )
            FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não Cadastrado na Tabela de Produtos.(SB1)")
            Return        
        Endif

        if SB1->( FIELDPOS( 'B1_XQTDCAI' ) )==0
            MSGINFO( "Campo 'B1_XQTDCAI' não foi criado na tabela de Produtos(SB1)", "Atenção!" )
            Return 
        Endif 
        if SB1->( FIELDPOS( 'B1_XQDPCAI' ) )==0
            MSGINFO( "Campo 'B1_XQDPCAI' não foi criado na tabela de Produtos(SB1)", "Atenção!" )
            Return 
        Endif 
        if SB1->( FIELDPOS( 'B1_XSETOR' ) )==0
            MSGINFO( "Campo 'B1_XSETOR' não foi criado na tabela de Produtos(SB1)", "Atenção!" )
            Return 
        Endif 
        if SB1->( FIELDPOS( 'B1_XQTDPAL' ) )==0
            MSGINFO( "Campo 'B1_XQTDPAL' não foi criado na tabela de Produtos(SB1)", "Atenção!" )
            Return 
        Endif 

       if _nMode == 2
            DbSelectArea("SZ7")
            SZ7->(DBGOTOP())
            SZ7->(DBSETORDER(1))
            SZ7->(DBSEEK(XFILIAL("SZ7")+Alltrim(SB1->B1_COD)))
            if !DbSeek( xFilial("SB1") + _cProd )
                FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não Cadastrado na Tabela (SZ7) Codificação Schneider")
                Return        
            Endif
        Endif 
    Endif 

    if _nMode <= 2
        If !CB5SETIMP(mv_par03, IsTelNet())
            MsgAlert("Falha na comunicacao com a impressora.")
            Return(Nil)
        EndIf
    Endif

    nLin	:= 5
    nCol	:= 10    

    if _nMode == 1          // Etiqueta abastecimento de linha
        getMod1()
    elseif _nMode == 2      // etiquetas de Locais de Abastecimento.
        getMod2()
    elseif _nMode == 3
       For nX := 1 to val(MV_PAR02)
        //StaticCall (OPMNTBAL,ExecEtiq,"NHA4940502")
        u_ExecEtiq("NHA4940502")
       NEXT
    endif 
    if _nMode <= 2
	    MSCBCLOSEPRINTER()
    Endif 
    
Return 

/*/{Protheus.doc} VLDINFOS
    description
    Valida campos dos parametros
    @type function
    @version 
    @author Valdemir Jose
    @since 09/07/2020
    @return return_type, return_description
/*/
Static Function VLDINFOS()
    Local lRET := .t.
    
    _cProd := mv_par01
    _nQtde := VAL(mv_par02)
    _cImpr := mv_par03
    _nMode := mv_par04

    lRET := ( !( Empty(_cProd) .OR. (_nQtde = 0) .OR. Empty(_cImpr) ) )

    if !lRET 
       FWMsgRun(,{|| Sleep(4000)},'Atenção!','Os campos são obrigatórios')
    Endif 

    dbSelectArea("PE3")
    dbSetOrder(1)      // Indice por produto
    IF !dbSeek(xFilial('PE3')+_cProd)    
        FWMsgRun(,{|| Sleep(4000)},'Atenção!','Produto não encontrado')
        lRET := .f.
    Endif 

Return lRET


/*/{Protheus.doc} getMod1
description
  Etiqueta Modelo 1 ( abastecimento )
@type function
@version 
@author Valdemir Jose
@since 13/07/2020
@return return_type, return_description
/*/
Static Function getMod1()
    Local ctamG    := "023,044"
    Local ctamM    := "019,029"
    Local ctamP    := "020,018"
    Local ctamx    := "016,014"
    Local aAreaPE3 := GetArea()
    Local cQtdCaix := cValToChar(PE3->PE3_MAXCAI)
    Local cQuantid := cValToChar(PE3->PE3_QUANTI)
    Local cArmazem := PE3->PE3_LOCALD

    nLin	:= 5
    nCol	:= 10       

    MSCBBEGIN(_nQtde,1)
    MSCBSAY(008+nCol,011-nLin,_cProd				     ,"N","0",ctamM)
    MSCBSAYBAR(008+nCol,014-nLin,Alltrim(cArmazem)       ,"N","MB07",08,.T.,.T.,.F.,"B",2,1)
    MSCBSAY(053+nCol,015-nLin,cQtdCaix+" CAIXAS"		 ,"N","0",ctamP)
    MSCBSAY(053+nCol,018-nLin,cQuantid+" PEÇAS"			 ,"N","0",ctamP)
	MSCBEND()

    RestArea( aAreaPE3 )

return



/*/{Protheus.doc} getMod2
description
  Etiqueta Modelo 2 ( Locais de Abastecimento. )
@type function
@version 
@author Valdemir Jose
@since 13/07/2020
@return return_type, return_description
/*/
Static Function getMod2()
    Local ctamG                  := "023,044"
    Local ctamM                  := "019,029"
    Local ctamP                  := "020,018"
    Local ctamx                  := "016,014"

    nLin	:= 5
    nCol	:= 10      
    nAJ     := 0

    MSCBBEGIN(_nQtde,1)    

    MSCBSAY(003+nCol,005+nLin,LEFT(SB1->B1_DESC,25)	     ,"N","0",ctamG)
    MSCBSAY(003+nCol,016+nLin,"QTDE.PALLET"              ,"N","0",ctamM)
    MSCBSAY(028+nCol,016+nLin, MV_PAR05                  ,"N","0",ctamG)
    MSCBSAY(048+nCol,016+nLin,"Volume"                   ,"N","0",ctamM)
    MSCBSAY(063+nCol,016+nLin, MV_PAR06                  ,"N","0",ctamG)

    MSCBSAY(003+nCol,025+nLin,"Operador"	             ,"N","0",ctamM)
    MSCBSAY(003+nCol,030+nLin,'Valdemir Rabelo'          ,"N","0",ctamG)
    MSCBSAY(050+nCol,025+nLin,"Data Encerramento"        ,"N","0",ctamM)
    MSCBSAY(048+nCol,030+nLin,dtoc(dDatabase)            ,"N","0",ctamG)

    MSCBSAYBAR(003-nCol,049-nLin, MV_PAR05+'#'+MV_PAR06   ,"N","MB07",10,.T.,.T.,.F.,"B",4,1)
	MSCBEND()
return

User Function GETMod30()
    dbSelectArea("PE3")
    dbSetOrder(1)
    dbSeek(xFilial('PE3')+'W930119750211  ')
    u_getMod3(3000)
return 

/*/{Protheus.doc} getMod3
description
Rotina de Impressão Etiqueta KamBan
@type function
@version 
@author Valdemir Jose
@since 03/12/2020
@param pQtde, param_type, param_description
@return return_type, return_description
/*/
User Function getMod3(pQtde)
    Local aArea2      := GetArea()
    Local ctamG       := "023,044"
    Local ctamM       := "019,029"
    Local ctamP       := "020,018"
    Local ctamx       := "016,014"
    
    dbSelectArea("CB1")
    dbSetOrder(2)
    dbSeek(xFilial('CB1')+__cUserID)

    If !CB5SETIMP(CB1->CB1_CODOPE, IsTelNet())    // 
        MsgAlert("Falha na comunicacao com a impressora.")
        Return(Nil)
    EndIf

    _nQtde  := 1
    nLin	:= 5
    nCol	:= 10   

    MSCBInfoEti("KAMBAN","")
    MSCBBEGIN(_nQtde,1)    
    MSCBSAY(027-nCol,027-nLin,"MaxCaixaLocal: "+cValToChar(PE3->PE3_MAXCAI)	             ,"N","0",ctamP)
    MSCBSAY(047-nCol,027-nLin,"Local Destino: "+PE3->PE3_LOCALD	             ,"N","0",ctamP)

    MSCBSAY(027-nCol,030-nLin,"Qde.P/Caixas: "+cValToChar(PE3->PE3_QUANTI)             ,"N","0",ctamP)
    MSCBSAY(047-nCol,030-nLin,"Bancada: "+PE3->PE3_BANCAD   	           ,"N","0",ctamP)

    MSCBBOX(027-nCol,35-nLin,046-nCol,43-nLin,2)
    MSCBSAY(028-nCol,036-nLin,"Qde Separada"      ,"N","0",ctamP)
    MSCBSAY(030-nCol,039-nLin, cValToChar(pQtde)              ,"N","0",ctamP)
    MSCBSAYBAR(049-nCol,035-nLin,Alltrim(PE3->PE3_PRODUT)    ,"N","MB07",08,.T.,.T.,.F.,"B",2,1)
    MSCBSAY(027-nCol,048-nLin,dtoc(dDatabase)+" "+Left(Time(),5)+"    Rota: "+PE3->PE3_ROTA		 ,"N","0",ctamP)
	MSCBEND()
    MSCBCLOSEPRINTER()

    RestArea( aArea2 )
return
