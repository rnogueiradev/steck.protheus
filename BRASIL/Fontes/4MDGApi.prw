#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "TBICONN.CH"
#include "totvs.ch"
#include "FwMvcDef.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "fwlibversion.ch"
#Include 'ParmType.Ch'
#Include 'FileIO.Ch'
#Include 'XmlXFun.ch'
#Include 'Shell.Ch'

WSRESTFUL 4MDGAPI DESCRIPTION "API de Integração 4MDG"

WSMETHOD POST Fornecedores ;
    DESCRIPTION "Método de Cadastro de Fornecedores" ;
    WSSYNTAX "Fornecedores" ;
    PATH "Fornecedores" PRODUCES APPLICATION_JSON

WSMETHOD POST Produtos ;
    DESCRIPTION "Método de Cadastro de Produtos" ;
    WSSYNTAX "Produtos" ;
    PATH "Produtos" PRODUCES APPLICATION_JSON

WSMETHOD POST Clientes ;
    DESCRIPTION "Método de Cadastro de Clients" ;
    WSSYNTAX "Clientes" ;
    PATH "Clientes" PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD POST Fornecedores WSSERVICE 4MDGAPI

Local lRet          := .T.
Local nStatusCode   := 200
Local cMessage      := ""
Local oJForn        := JSonObject():New()
Local cBody         := ""
Local oJRet		    := Nil
Local oJRetItens    := Nil
Local nOperacao     := 0
Local lDeuCerto     := .F.
Local lLayout       := .F.
Local cCodigo       := ""
Local cA2Cod        := ""
Local cMensErro     := ""
Local aErro         := {}
Local aMensagem     := {}
Local aNomeFor      := {}
Local cMun          := ""
Local cEst          := ""
Local cSeparador    := ""
Local cConteudo     := ""
Local nConteudo     := 0
Local dConteudo     := STOD("        ")
Local cEmpAPI       := ""
Local cFilAPI       := ""

Private cTipo       := ""
Private cChave      := ""
Private lMsHelpAuto , lMsErroAuto, lMsFinalAuto := .F.
Private INCLUI      := .T.
Private ALTERA      := .F.
Private EXCLUI      := .F.

Self:SetContentType("application/json")

If Len(cFilant) <> TamSX3("A2_FILIAL")[1]
	ConOut( Replicate("R",80) )
	ConOut('['+DtoC(date())+' - '+Time()+'] FILIAL COM TAMANHO INCORRETO NA TRANSFERENCIA ==> '+ Alltrim(str(Len(cFilant))) + ' <== FILIAL ==> ' + cFilAnt + ' <== TAMANHO CORRETO ==> ' + Alltrim(str(TamSX3("A2_FILIAL")[1])))
	ConOut( Replicate("R",80) )

//	RpcClearEnv()

//	PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL padr(cFilOld,TamSX3("A2_FILIAL")[1]) MODULO "SIGACOM" TABLES "SA2"
Endif

If Len(Self:aURLParms) > 0

    cBody := Self:GetContent()
    cBody := Replace( cBody, "null", '""' )

    If !Empty( cBody )

		//FWJsonDeserialize(Upper(cBody),@oJForn)
        oJForn    := JSonObject():New()
        cParse    := oJForn:fromJson( cBody )
        aNomeFor  := oJForn:GetNames()
        
        If AllTrim( Upper( ValType( oJForn ) ) ) == "O" .Or. AllTrim( Upper( ValType( oJForn ) ) ) == "J"
            // Valida se Layout existe e está preenchido...
            dbSelectArea("Z9A")
            dbSetOrder(1)
            Z9A->( dbGoTop() )
            If !Z9A->( Eof() ) .And. AllTrim( Z9A->Z9A_ATIVO ) == "S"
                dbSelectArea("Z9B")
                dbSetOrder(1)
                If Z9B->( dbSeek( xFilial("Z9B") + "SA2" ) )
                    dbSelectArea("Z9C")
                    dbSetOrder(1)
                    If Z9C->( dbSeek( xFilial("Z9C") + "SA2" ) )
                        lLayout := .T.
                    Else
                        lLayout := .F.
                    EndIf
                Else
                    lLayout := .F.
                EndIf
            Else
                lLayout := .F.
            EndIf

            If lLayout
                // Tratar compartilhamento do cadastro antes de iniciar processo...
                cEmpAPI := cEmpAnt
                cFilAPI := cFilAnt

                If !Empty( Z9B->Z9B_TAGGRU ) .Or. !Empty( Z9B->Z9B_TAGEMP ) .Or. !Empty( Z9B->Z9B_TAGUNI ) .Or. !Empty( Z9B->Z9B_TAGFIL )
                    If !Empty( Z9B->Z9B_TAGGRU )
                        If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGGRU ) } ) > 0
                            cEmpAPI := oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGGRU ) )
                        EndIf
                        cFilAPI := ""
                        If !Empty( Z9B->Z9B_TAGEMP )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                                cFilAPI += oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                            EndIf
                        EndIf
                        If !Empty( Z9B->Z9B_TAGUNI )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGUNI ) } ) > 0
                                cFilAPI += oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGUNI ) )
                            EndIf
                        EndIf
                        If !Empty( Z9B->Z9B_TAGFIL )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                cFilAPI += oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                            EndIf
                        EndIf
                    ElseIf !Empty( Z9B->Z9B_TAGEMP )
                        If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                            cEmpAPI := oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                        EndIf
                        If !Empty( Z9B->Z9B_TAGFIL )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                cFilAPI := oJForn:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                            EndIf
                        EndIf
                    EndIf

                    If AllTrim( cEmpAPI ) <> AllTrim( cEmpAnt ) .Or. AllTrim( cFilAPI ) <> AllTrim( cFilAnt )
                        cEmpAnt := cEmpAPI
                        cFilAnt := cFilAPI
                        //PREPARE ENVIRONMENT EMPRESA cEmpAPI FILIAL cFilAPI MODULO "SIGACOM" TABLES "SA2"
                    EndIf
                EndIf

                Begin Sequence 
                    oJRet 	        :=  JsonObject():New()
                    oJRet["itens"]  := {}     

                    cChave := ""
                    cMun   := ""
                    cEst   := ""
                    ConOut( Replicate( "-", 60 ) )
                    ConOut( "Data " + DTOC( dDataBase ) + " Time " + Time() )

                    // Busca chave pelo Índice Primário do Layout... (CNPJ)
                    dbSelectArea("SA2")
                    dbSetOrder( Z9B->Z9B_INDICE )
                    If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_CHVIN1 ) } ) > 0
                        ConOut( "Chave CNPJ: " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) )
                        oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) := Replace(Replace(Replace(oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ),".",""),"/",""),"-","")
                        cChave := oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) )
                        If SA2->( dbSeek( xFilial("SA2") + oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) ) )
                            ConOut("CNPJ encontrado " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ))
                            nOperacao := 4
                            INCLUI    := .F.
                            ALTERA    := .T.
                            cCodigo   := SA2->A2_COD
                            cTipo     := SA2->A2_TIPO
                            ConOut( "001 - Código..: " + SA2->A2_COD )
                            ConOut( "001 - Loja....: " + SA2->A2_LOJA )
                            ConOut( "001 - cCodigo.......: " + cCodigo )
                        Else
                            ConOut("CNPJ não encontrado " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ))
                            nOperacao := 3
                            INCLUI    := .T.
                            ALTERA    := .F.
                            cCodigo   := ""
                            cTipo     := "J"
                        EndIf
                    EndIf

                    // Busca chave pelo Índice Alternativo do Layout... (CPF)
                    If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_ALTIN1 ) } ) > 0 .And. Empty( cChave )
                        If !Empty( oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                            ConOut( "Chave CPF: " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                            oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) := Replace(Replace(Replace(oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ),".",""),"/",""),"-","")
                            cChave := oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) )
                            If dbSeek(xFilial("SA2") + oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                                ConOut("CPF encontrado " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ))
                                nOperacao := 4
                                INCLUI    := .F.
                                ALTERA    := .T.
                                cCodigo   := SA2->A2_COD
                                cTipo     := SA2->A2_TIPO
                                ConOut( "002 - Código..: " + SA2->A2_COD )
                                ConOut( "002 - Loja....: " + SA2->A2_LOJA )
                                ConOut( "002 - cCodigo.......: " + cCodigo )
                            Else
                                ConOut("CPF não encontrado " + oJForn:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ))
                                nOperacao := 3
                                INCLUI    := .T.
                                ALTERA    := .F.
                                cCodigo   := ""
                                cTipo     := "F"
                            EndIf
                        Else
                            nOperacao := 3
                            cCodigo   := ""
                            cTipo     := "X"
                        EndIf
                    EndIf

                    ConOut( "003 - cCodigo.......: " + cCodigo )
                    ConOut( "003 - nOperacao.....: " + Str(nOperacao) )

                    //Pegando o modelo de dados, setando a operação de inclusão
                    oModel := FWLoadModel("MATA020M")
                    oModel:SetOperation(nOperacao)
                    oModel:Activate()

                    dbSelectArea("Z9C")
                    dbSetOrder(1)
                    Z9C->( dbSeek( xFilial("Z9C") + "SA2" ) )

                    //Pegando o model dos campos da SA2
                    oSA2Mod:= oModel:getModel("SA2MASTER")

                    If nOperacao <> 4
                        If !Empty( cCodigo )
                            oSA2Mod:setValue("A2_COD"    , cCodigo           )
                        Else
                            If AllTrim( cTipo ) == "J"
                                If Len( AllTrim( cChave ) ) == 14
                                    oSA2Mod:setValue("A2_LOJA"   , SubStr( cChave, 11, 2))
                                Else
                                    oSA2Mod:setValue("A2_LOJA"   , "01"           )
                                EndIf
                            Else
                                oSA2Mod:setValue("A2_LOJA"   , "01"           )
                            EndIf
                        EndIf
                    EndIf
                    oSA2Mod:setValue("A2_CGC"    , cChave )
                    oSA2Mod:setValue("A2_TIPO"   , cTipo )

                    ConOut( "004 - cCodigo.......: " + cCodigo )
                    ConOut( "004 - nOperacao.....: " + Str(nOperacao) )
                    ConOut( "004 - cChave........: " + cChave )

                    Do While !Z9C->( Eof() ) .And. AllTrim( Z9C->Z9C_CADAST ) == "SA2"
                        cSeparador := IIf( Z9C->Z9C_SEPARA == "T", "-", IIf( Z9C->Z9C_SEPARA == "B", "/", IIf( Z9C->Z9C_SEPARA == "V", ", ", IIf( Z9C->Z9C_SEPARA == "P", ";", ""))))

                        If AllTrim( Z9C->Z9C_CAMPO ) <> AllTrim( Z9B->Z9B_CPODEF ) .And. AllTrim( Z9C->Z9C_TRATAM ) <> "CHAVE" ;
                                    .And. AllTrim( Z9C->Z9C_TRATAM ) <> "GRUPO_EMPRESA"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "EMPRESA" ;
                                    .And. AllTrim( Z9C->Z9C_TRATAM ) <> "UNIDADE_NEGOCIO"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "FILIAL"
                            ConOut(Z9C->Z9C_CAMPO)
                            ConOut(Z9C->Z9C_CPO4MD)
                            If AllTrim( Z9C->Z9C_CPO4MD ) <> "FIXO"
                                // Se membro não existir, pular o registro...
                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } ) > 0
                                    dbSelectArea("SX3")
                                    dbSetOrder(2)
                                    If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                        If SX3->X3_TIPO == "C"
                                            If !Empty( Z9C->Z9C_TRATAM )
                                                cConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                oSA2Mod:setValue( Z9C->Z9C_CAMPO, Padr( cConteudo, SX3->X3_TAMANHO) )
                                            Else
                                                // Se caractere, truncar pois dá erro se conteúdo for maior que X3_TAMANHO...
                                                If Empty( Z9C->Z9C_CPOCOM )
                                                    oSA2Mod:setValue( Z9C->Z9C_CAMPO, Padr( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO) )
                                                Else
                                                    oSA2Mod:setValue( Z9C->Z9C_CAMPO, Padr( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO) )
                                                EndIf
                                            EndIf
                                        ElseIf SX3->X3_TIPO == "N"
                                            If !Empty( Z9C->Z9C_TRATAM )
                                                nConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                oSA2Mod:setValue( Z9C->Z9C_CAMPO, nConteudo )
                                            Else
                                                oSA2Mod:setValue( Z9C->Z9C_CAMPO, oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                            EndIf
                                        ElseIf SX3->X3_TIPO == "D"
                                            If !Empty( Z9C->Z9C_TRATAM )
                                                dConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                oSA2Mod:setValue( Z9C->Z9C_CAMPO, dConteudo )
                                            Else
                                                oSA2Mod:setValue( Z9C->Z9C_CAMPO, oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                            EndIf
                                        Else
                                            oSA2Mod:setValue( Z9C->Z9C_CAMPO, oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                        EndIf
                                    EndIf
                                    ConOut(oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ))
                                Else
                                    ConOut("Membro da Tag não existe")
                                EndIf
                            Else
                                If !Empty( Z9C->Z9C_TRATAM )
                                    If Left( AllTrim( Upper( Z9C->Z9C_TRATAM ) ), 4) == "CMD:"
                                        oSA2Mod:setValue( Z9C->Z9C_CAMPO, &( Replace( Z9C->Z9C_TRATAM, "CMD:", "") ) )
                                        ConOut(&(Replace( Z9C->Z9C_TRATAM, "CMD:", "")))
                                    Else
                                        oSA2Mod:setValue( Z9C->Z9C_CAMPO, &( Z9C->Z9C_TRATAM ) )
                                        ConOut(&(Z9C->Z9C_TRATAM))
                                    EndIf
                                EndIf
                            EndIf
                        EndIf

                        //Tratar código do município...
                        If AllTrim( Z9C->Z9C_CAMPO ) == "A2_MUN"
                            cMun := oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                        ElseIf AllTrim( Z9C->Z9C_CAMPO ) == "A2_EST"
                            cEst := oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                        EndIf

                        Z9C->( dbSkip() )
                    EndDo

                    ConOut( "005 - cCodigo.......: " + cCodigo )
                    ConOut( "005 - nOperacao.....: " + Str(nOperacao) )
                    ConOut( "005 - cChave........: " + cChave )
                    ConOut( "005 - cMun..........: " + cMun )
                    ConOut( "005 - cEst..........: " + cEst )

                    // Inclui campo Código do Município se encontrar...
                    If !Empty( cMun ) .And. !Empty( cEst )
                        cQuery := "SELECT CC2_CODMUN FROM " + RetSqlName("CC2") + " WHERE CC2_FILIAL = '" + xFilial("CC2") + "' AND CC2_EST = '" + cEst + "' AND CC2_MUN LIKE '%" + cMun + "%' AND D_E_L_E_T_ = ' '"
                        TCQuery cQuery New Alias "TMPCC2"
                        dbSelectArea("TMPCC2")
                        TMPCC2->( dbGoTop() )
                        If !TMPCC2->( Eof() )
                            oSA2Mod:setValue( "A2_COD_MUN", TMPCC2->CC2_CODMUN )
                        EndIf
                        TMPCC2->( dbCloseArea() )
                    EndIf

                    If nOperacao == 4
                        //oSA2Mod:setValue( "A2_COD", SA2->A2_COD )
                        //oSA2Mod:setValue( "A2_LOJA", SA2->A2_LOJA )
                        ConOut( "003 - Código..: " + SA2->A2_COD )
                        ConOut( "003 - Loja....: " + SA2->A2_LOJA )
                        ConOut( "006 - cCodigo.......: " + cCodigo )
                        ConOut( "006 - nOperacao.....: " + Str(nOperacao) )
                        ConOut( "006 - cChave........: " + cChave )
                    EndIf

                    //Se conseguir validar as informações
                    If oModel:VldData()
                        //Tenta realizar o Commit
                        If oModel:CommitData()
                            lDeuCerto := .T.
                            dbSelectArea("SA2")
                            dbSetOrder( Z9B->Z9B_INDICE )
                            If SA2->( dbSeek( xFilial("SA2") + cChave ) )
                                cA2Cod := SA2->A2_COD
                            EndIf
//                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA2Cod,cCodigo),IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso"),SA2->A2_LOJA})
                            aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA2Cod,cCodigo) + " - " + SA2->A2_LOJA,IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso"),SA2->A2_LOJA})
                            ConOut( "DEU CERTO!" )
                            ConOut( "004 - Código..: " + SA2->A2_COD )
                            ConOut( "004 - Loja....: " + SA2->A2_LOJA )
                        //Se não deu certo, altera a variável para false
                        Else
                            lDeuCerto := .F.
                            ConOut( "005 - Código..: " + SA2->A2_COD )
                            ConOut( "005 - Loja....: " + SA2->A2_LOJA )
                        EndIf
                    //Se não conseguir validar as informações, altera a variável para false
                    Else
                        lDeuCerto := .F.
                        ConOut( "006 - Código..: " + SA2->A2_COD )
                        ConOut( "006 - Loja....: " + SA2->A2_LOJA )
                    EndIf

                    ConOut( "007 - cCodigo.......: " + cCodigo )
                    ConOut( "007 - nOperacao.....: " + Str(nOperacao) )
                    ConOut( "007 - cChave........: " + cChave )

                    //Se não deu certo a inclusão, mostra a mensagem de erro
                    If ! lDeuCerto
                        //Busca o Erro do Modelo de Dados
                        aErro := oModel:GetErrorMessage()
                        //Monta o Texto que será mostrado na tela
                        AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
                        AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
                        AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
                        AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
                        AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
                        AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
                        AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
                        AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
                        AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
                        ConOut( VarInfo( "", aErro ) )
                        ConOut( nOperacao )
                        ConOut( cCodigo )
                        ConOut( SA2->A2_COD )
                        ConOut( "nOperacao == 4 .And. cCodigo == SA2->A2_COD" )
                        ConOut( nOperacao == 4 .And. cCodigo == SA2->A2_COD )
                        If nOperacao == 4 .And. cCodigo == SA2->A2_COD
                            RecLock("SA2", .F.)
                                dbSelectArea("Z9C")
                                dbSetOrder(1)
                                Z9C->( dbSeek( xFilial("Z9C") + "SA2" ) )
                                Do While !Z9C->( Eof() ) .And. AllTrim( Z9C->Z9C_CADAST ) == "SA2"
                                    cSeparador := IIf( Z9C->Z9C_SEPARA == "T", "-", IIf( Z9C->Z9C_SEPARA == "B", "/", IIf( Z9C->Z9C_SEPARA == "V", ", ", IIf( Z9C->Z9C_SEPARA == "P", ";", ""))))

                                    If AllTrim( Z9C->Z9C_CAMPO ) <> AllTrim( Z9B->Z9B_CPODEF ) .And. AllTrim( Z9C->Z9C_TRATAM ) <> "CHAVE" ;
                                            .And. AllTrim( Z9C->Z9C_TRATAM ) <> "GRUPO_EMPRESA"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "EMPRESA" ;
                                            .And. AllTrim( Z9C->Z9C_TRATAM ) <> "UNIDADE_NEGOCIO"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "FILIAL"
                                        If AllTrim( Z9C->Z9C_CPO4MD ) <> "FIXO"
                                            // Se membro não existir, pular o registro...
                                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } ) > 0
                                                dbSelectArea("SX3")
                                                dbSetOrder(2)
                                                If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                                    If SX3->X3_TIPO == "C"
                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                            cConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                            &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( cConteudo, SX3->X3_TAMANHO)
                                                        Else
                                                            If Empty( Z9C->Z9C_CPOCOM )
                                                                &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO)
                                                            Else
                                                                &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO)
                                                            EndIf
                                                        EndIf
                                                    ElseIf SX3->X3_TIPO == "N"
                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                            nConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                            &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := nConteudo
                                                        Else
                                                            &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                        EndIf
                                                    ElseIf SX3->X3_TIPO == "D"
                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                            dConteudo := fTratar( oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                            &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := dConteudo
                                                        Else
                                                            &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                        EndIf
                                                    Else
                                                        &( "SA2->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJForn:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                    EndIf
                                                EndIf
                                            EndIf
                                        EndIf
                                    EndIf
                                    Z9C->( dbSkip() )
                                EndDo
                            MsUnLock()
                            ConOut( Replicate("*", 60))
                            ConOut( VarInfo("", oSA2Mod, , .F.) )
                            ConOut( Replicate("*", 60))
                            ConOut( "RECNO NO ALTER FORCE!" )
                            lDeuCerto := .T.
                            cA2Cod := SA2->A2_COD
                            //aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA2Cod,cCodigo),IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso"),SA2->A2_LOJA})
                            aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA2Cod,cCodigo) + " - " + SA2->A2_LOJA,IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso"),SA2->A2_LOJA})
                            ConOut( "DEU CERTO!" )
                            ConOut( "004 - Código..: " + SA2->A2_COD )
                            ConOut( "004 - Loja....: " + SA2->A2_LOJA )
                        Else
                            //Mostra a mensagem de Erro
                            cCompErro := DTOS( MsDate() ) + Replace( Time(), ":", "")
                            MostraErro("\system\","INTFOR4MDG" + cCompErro + ".txt")
                            cMensErro := MemoRead("\system\INTFOR4MDG" + cCompErro + ".txt")
                            aAdd( aMensagem, {"Erro gravação",cCodigo,cMensErro,""})
                            nStatusCode := 400
                            ConOut( "DEU ERRO!" )
                        EndIf
                    EndIf

                    ConOut( Replicate( "-", 60 ) )

                    //Desativa o modelo de dados
                    oModel:DeActivate()
                End Sequence
            Else
                aAdd( aMensagem, {"Layout Integracao Nao definida","","Efetuar cadastro de layout do metodo fornecedor",""})
                lRet 		:= .F.
                nStatusCode	:= 400
                cMessage    := "Dados inválidos!"
            EndIf
		EndIf
    Else
        aAdd( aMensagem, {"Não há dados","","Body vazia",""})
		lRet 		:= .F.
		nStatusCode	:= 400
		cMessage    := "Não há dados!"
	EndIf
EndIf

ConOut( "Len(aMensagem): " + StrZero( Len(aMensagem), 3) )
ConOut( VarInfo("", aMensagem, , .F.) )

If Len( aMensagem ) == 0
    aAdd( aMensagem, {"Dados Inválido","","Falta membros obrigatórios na body"})
EndIf

oJRetItens  :=  JsonObject():New()
oJRetItens["ajuda"]        := aMensagem[1][1]
oJRetItens["numero"]       := aMensagem[1][2]
oJRetItens["loja"]         := aMensagem[1][4]
oJRetItens["mensagem"]     := aMensagem[1][3]
oJRetItens["logdata"]      := DTOC( MsDate() ) + " " + Time()
oJRetItens["empresa"]      := cEmpAnt
oJRetItens["filial"]       := cFilAnt
oJRetItens["nome_empresa"] := AllTrim( SM0->M0_NOMECOM )

If ValType( oJRet ) <> "O" .And. ValType( oJRet ) <> "J"
	oJRet 	        :=  JsonObject():New()
	oJRet["itens"]  := {}     
EndIf

If ValType( oJRet["itens"] ) <> "A" .And. ValType( oJRet["itens"] ) <> "O"
	oJRet["itens"]  := {}
EndIf

aAdd(oJRet["itens"], oJRetItens)

oJRet["total"]      := Len(oJRet["itens"])
oJRet["hasNext"]    := .F. //"false"
oJRet["statusCode"] := nStatusCode //"false"

ConOut( VarInfo("", oJRet, , .F.) )

If lRet
	self:SetResponse(EncodeUTF8(oJRet:toJSON()))
Else
	SetRestFault( nStatusCode, EncodeUTF8("") )
	self:SetResponse(EncodeUTF8(oJRet:toJSON()))
Endif

ConOut("SetResponse..: " + EncodeUTF8(oJRet:toJSON()))
ConOut("lRet.........: " + IIf( lRet, ".T.", ".F."))
ConOut("nStatusCode..: " + StrZero( nStatusCode, 6))

If ValType(oJRet) == "O"
	FreeObj(oJRet)
	oJRet := Nil
Endif

Return lRet

Static Function fTratar( uConteudo, cCondicao )

Local uRetorno
Local nPosAbre := 0
Local nPosFech := 0
Local aArea    := GetArea()
Local aAreaSB1 := SB1->( GetArea() )
Local aAreaSX5 := SX5->( GetArea() )

Do Case
    Case AllTrim( cCondicao ) == "CONVERT_CHAR"
        uRetorno := CVALTOCHAR( uConteudo )
    Case AllTrim( cCondicao ) == "CHAR_TO_VALOR"
        uRetorno := VAL( uConteudo )
    Case AllTrim( cCondicao ) == "VALOR_TO_CHAR"
        uRetorno := ALLTRIM(STR( uConteudo ))
    Case AllTrim( cCondicao ) == "STRING_TO_DATA"
        uRetorno := STOD( uConteudo )
    Case AllTrim( cCondicao ) == "CHAR_TO_DATA"
        uRetorno := CTOD( uConteudo )
    Case AllTrim( cCondicao ) == "DATA_TO_STRING"
        uRetorno := DTOS( uConteudo )
    Case AllTrim( cCondicao ) == "DATA_TO_CHAR"
        uRetorno := DTOC( uConteudo )
    Case AllTrim( cCondicao ) == "N_ZERO_TO_C_NS"
        uRetorno := IIf( uConteudo == 0, "N", "S" )
    Case AllTrim( cCondicao ) == "N_ZERO_TO_C_12"
        uRetorno := IIf( uConteudo == 0, "2", "1" )
    Case AllTrim( cCondicao ) == "C_ZERO_TO_C_NS"
        uRetorno := IIf( uConteudo == "0", "N", "S" )
    Case AllTrim( cCondicao ) == "C_ZERO_TO_C_12"
        uRetorno := IIf( uConteudo == "0", "2", "1" )
    Case AllTrim( cCondicao ) == "C_UM_TO_C_SN"
        uRetorno := IIf( uConteudo == "1", "S", "N" )
    Case AllTrim( cCondicao ) == "APROPRIACAO"
        uRetorno := IIf( Left( AllTrim( uConteudo ), 1) == "I", "I", "D" )
    Case AllTrim( cCondicao ) == "CRIACB"
        uRetorno := IIf( uConteudo == "1", "S", IIf( uConteudo == "2", "N", "C" ) )
    Case AllTrim( cCondicao ) == "UNIDADE"
        dbSelectArea("SAH")
        dbSetOrder(1)
        If !SAH->( dbSeek( xFilial("SAH") + uConteudo ) )
            uRetorno := "UN"
        Else
            uRetorno := uConteudo
        EndIf
    Case AllTrim( cCondicao ) == "SO_DDD"
        nPosAbre := At( "(", uConteudo)
        nPosFech := At( ")", uConteudo)
        If nPosAbre > 0 .And. nPosFech > 0 .And. nPosAbre < nPosFech
            uRetorno := AllTrim( Replace( Replace( SubStr( uConteudo, nPosAbre + 1, nPosFech - nPosAbre), "(", ""), ")", "") )
            uRetorno := StrZero( Val( uRetorno ), 3)
        Else
            uRetorno := ""
        EndIf
    Case AllTrim( cCondicao ) == "TIRA_DDD"
        nPosFech := At( ")", uConteudo)
        If nPosFech > 0
            uRetorno := AllTrim( Replace( Replace( Replace( SubStr( uConteudo, nPosFech + 1), "(", ""), ")", ""), "-", "") )
        Else
            uRetorno := AllTrim( Replace( uConteudo, "-", "") )
        EndIf
    Case AllTrim( cCondicao ) == "TIRA_MASCARA"
        uRetorno := Replace(Replace(Replace(uConteudo,".",""),"/",""),"-","")
    Case Left( AllTrim( Upper( cCondicao ) ), 4) == "CMD:"
        cCondicao := Replace( cCondicao, "CMD:", "")
        uRetorno := &( cCondicao )
    Case AllTrim( cCondicao ) == "ORIGEM"
        dbSelectArea("SX5")
        dbSetOrder(1)
        If !SX5->( dbSeek( xFilial("SX5") + Padr( "S0", TamSX3("X5_TABELA")[1]) + uConteudo ) )
            // Verifica se existe na filial compartilhada...
            If !SX5->( dbSeek( Space( Len(SX5->X5_FILIAL) ) + Padr( "S0", TamSX3("X5_TABELA")[1]) + uConteudo ) )
                uRetorno := "0"
            Else
                uRetorno := uConteudo
            EndIf
        Else
            uRetorno := uConteudo
        EndIf
    Case AllTrim( cCondicao ) == "GRPTRIBUTACAO"
        dbSelectArea("SX5")
        dbSetOrder(1)
        If !SX5->( dbSeek( xFilial("SX5") + Padr( "21", TamSX3("X5_TABELA")[1]) + uConteudo ) )
            // Verifica se existe na filial compartilhada...
            If !SX5->( dbSeek( Space( Len(SX5->X5_FILIAL) ) + Padr( "21", TamSX3("X5_TABELA")[1]) + uConteudo ) )
                uRetorno := ""
            Else
                uRetorno := uConteudo
            EndIf
        Else
            uRetorno := uConteudo
        EndIf
    Case AllTrim( cCondicao ) == "FORNECEDOR_PADRAO"
        dbSelectArea("SA2")
        dbSetOrder(1)
        If !SA2->( dbSeek( xFilial("SA2") + Padr( uConteudo, 6) ) )
            uRetorno := ""
        Else
            uRetorno := Padr( uConteudo, 6)
        EndIf
    Case AllTrim( cCondicao ) == "ALTERNATIVO"
        dbSelectArea("SB1")
        dbSetOrder(1)
        If !SB1->( dbSeek( xFilial("SB1") + Padr( uConteudo, TamSX3("B1_COD")[1]) ) )
            uRetorno := ""
        Else
            uRetorno := uConteudo
        EndIf
    Case AllTrim( cCondicao ) == "ROTEIRO"
        dbSelectArea("SG2")
        dbSetOrder(1)
        If !SG2->( dbSeek( xFilial("SG2") + Padr( cChave, TamSX3("B1_COD")[1]) + uConteudo ) )
            uRetorno := ""
        Else
            uRetorno := uConteudo
        EndIf
    Otherwise
        uRetorno := uConteudo
EndCase

SX5->( RestArea( aAreaSX5 ) )
SB1->( RestArea( aAreaSB1 ) )
RestArea( aArea )

Return uRetorno

WSMETHOD POST Produtos WSSERVICE 4MDGAPI

Local oJProd
Local oJSub
Local lRet          := .T.
Local nStatusCode   := 201
Local cMessage      := ""
Local cBody         := ""
Local oJRet		    := Nil
Local oJRetItens    := Nil
Local nOperacao     := 0
Local lDeuCerto     := .F.
Local lLayout       := .F.
Local cCodigo       := ""
Local cCodBar       := ""
Local cB1Desc       := ""
Local cGrTrib       := ""
Local cCodGTIN      := ""
Local cDescCxEsp    := ""
Local cLogoS        := ""
Local cB1Cod        := ""
Local cMensErro     := ""
Local cQuery        := ""
Local cProximo      := ""
Local aErro         := {}
Local aMensagem     := {}
Local aNomeProd     := {}
Local aNomeSub      := {}
Local aSubs         := {}
Local aCampos       := {}
Local cSeparador    := ""
Local cConteudo     := ""
Local nConteudo     := 0
Local dConteudo     := STOD("        ")
Local cEmpAPI       := ""
Local cFilAPI       := ""
Local nLin          := 0
Local nPosCod       := 0
Local nPosSub       := 0
Local nSub          := 0
Local nLinSub       := 0
Local lSub          := .F.
Local cData         := ""

Private cTipo       := ""
Private cChave      := ""
Private lMsHelpAuto , lMsErroAuto, lMsFinalAuto := .F.
Private INCLUI      := .T.
Private ALTERA      := .F.
Private EXCLUI      := .F.
Private aRotAuto    := {}
Private nOpc        := 0

Self:SetContentType("application/json")

ConOut( "Empresa...: " + cEmpAnt )
ConOut( "Filial....: " + cFilAnt )
ConOut( "Usuario...: " + __cUserId )

__cUserId := "000000"

aSubs := {}
aAdd( aSubs, {"empresa_mkt_sub"})
aAdd( aSubs, {"empresa_eng_sub"})
aAdd( aSubs, {"empresa_pcp_sub"})
aAdd( aSubs, {"empresa_contabilidade_sub"})
aAdd( aSubs, {"empresa_solicitante_sub"})
aAdd( aSubs, {"empresa_controladoria_sub"})
aAdd( aSubs, {"empresa_pi_sub"})
aAdd( aSubs, {"empresa_cta_sub"})
aAdd( aSubs, {"pdm_sub_PA"})
aAdd( aSubs, {"mkt_sub_PA"})
aAdd( aSubs, {"eng_sub_PA"})
aAdd( aSubs, {"pcp_sub_PA"})
aAdd( aSubs, {"cta_sub_PA"})
aAdd( aSubs, {"qualidade_sub_PA"})
aAdd( aSubs, {"fiscal_sub_PA"})

ConOut(Self:aURLParms)

If Len(Self:aURLParms) > 0
    cBody := Self:GetContent()
    cBody := Replace( cBody, "null", '""' )
    ConOut(cBody)
    cBody     := DeCodeUTF8( cBody )
//    cBody     := EnCodeUTF8( cBody )
//    cBody     := NoAcento( cBody )
//	cBody := NoAcento( EncodeUTF8( SpecialChar( cBody ) ) )

    ConOut("Fabio e Leandro, ver Body depois da conversao de caracteres especiais")
    ConOut(cBody)

    If !Empty( cBody )
        oJProd    := JSonObject():New()
        cParse    := oJProd:fromJson( cBody )
        aNomeProd := oJProd:GetNames()

        If AllTrim( Upper( ValType( oJProd ) ) ) == "O" .Or. AllTrim( Upper( ValType( oJProd ) ) ) == "J"
            nPosCod := aScan( aNomeProd, {|x| Alltrim( Lower( x ) ) == "codigo" } )

            // Alimentar subs que não foram previstas
            For nPosSub := 1 To Len( aNomeProd )
                If AllTrim( aNomeProd[nPosSub] ) <> "pdm_materiais_sub"
                    If At( "_sub", aNomeProd[nPosSub] ) > 0
                        If aScan( aSubs, { |a| AllTrim( a[1] ) == AllTrim( aNomeProd[nPosSub] ) }) == 0
                            aAdd( aSubs, { AllTrim( aNomeProd[nPosSub] ) } )
                        EndIf
                    EndIf
                EndIf
            Next

            If nPosCod > 0
                // Valida se Layout existe e está preenchido...
                dbSelectArea("Z9A")
                dbSetOrder(1)
                Z9A->( dbGoTop() )
                If !Z9A->( Eof() ) .And. AllTrim( Z9A->Z9A_ATIVO ) == "S"
                    dbSelectArea("Z9B")
                    dbSetOrder(1)
                    If Z9B->( dbSeek( xFilial("Z9B") + "SB1" ) )
                        dbSelectArea("Z9C")
                        dbSetOrder(1)
                        If Z9C->( dbSeek( xFilial("Z9C") + "SB1" ) )
                            lLayout := .T.
                        Else
                            lLayout := .F.
                        EndIf
                    Else
                        lLayout := .F.
                    EndIf
                Else
                    lLayout := .F.
                EndIf

                If lLayout
                    // Tratar compartilhamento do cadastro antes de iniciar processo...
                    cEmpAPI := cEmpAnt
                    cFilAPI := cFilAnt

                    If !Empty( Z9B->Z9B_TAGGRU ) .Or. !Empty( Z9B->Z9B_TAGEMP ) .Or. !Empty( Z9B->Z9B_TAGUNI ) .Or. !Empty( Z9B->Z9B_TAGFIL )
                        If !Empty( Z9B->Z9B_TAGGRU )
                            If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGGRU ) } ) > 0
                                cEmpAPI := oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGGRU ) )
                            EndIf
                            cFilAPI := ""
                            If !Empty( Z9B->Z9B_TAGEMP )
                                If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                                    cFilAPI += oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                                EndIf
                            EndIf
                            If !Empty( Z9B->Z9B_TAGUNI )
                                If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGUNI ) } ) > 0
                                    cFilAPI += oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGUNI ) )
                                EndIf
                            EndIf
                            If !Empty( Z9B->Z9B_TAGFIL )
                                If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                    cFilAPI += oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                                EndIf
                            EndIf
                        ElseIf !Empty( Z9B->Z9B_TAGEMP )
                            If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                                cEmpAPI := oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                            EndIf
                            If !Empty( Z9B->Z9B_TAGFIL )
                                If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                    cFilAPI := oJProd:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                                EndIf
                            EndIf
                        EndIf
                        If AllTrim( cEmpAPI ) <> AllTrim( cEmpAnt ) .Or. AllTrim( cFilAPI ) <> AllTrim( cFilAnt )
                            cEmpAnt := cEmpAPI
                            cFilAnt := cFilAPI
                        EndIf
                    EndIf

                    Begin Sequence 
                        oJRet 	        :=  JsonObject():New()
                        oJRet["itens"]  := {}     

                        cChave     := ""
                        cTipo      := ""
                        cProximo   := ""
                        cCodBar    := ""
                        cB1Desc    := ""
                        cCodGTIN   := ""
                        cDescCxEsp := ""
                        cLogoS     := ""
                        cGrTrib    := ""

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "numero_do_codigo_barras" } ) > 0
                            cCodBar := AllTrim( oJProd:GetJsonText( "numero_do_codigo_barras" ) )
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "descricao_curta_pdm" } ) > 0
                            cB1Desc := AllTrim( oJProd:GetJsonText( "descricao_curta_pdm" ) )
                            cB1Desc := NoAcento(cB1Desc)
                        EndIf

                        If Empty( cCodBar )
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "codigo_barras_schneider" } ) > 0
                                cCodBar := AllTrim( oJProd:GetJsonText( "codigo_barras_schneider" ) )
                            EndIf
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "grupo_tributacao" } ) > 0
                            cGrTrib := AllTrim( oJProd:GetJsonText( "grupo_tributacao" ) )
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "gtin" } ) > 0
                            cCodGTIN := AllTrim( oJProd:GetJsonText( "gtin" ) )
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "desc_cx_espa" } ) > 0
                            cDescCxEsp := AllTrim( oJProd:GetJsonText( "desc_cx_espa" ) )
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "se_logo_s" } ) > 0
                            cLogoS := AllTrim( oJProd:GetJsonText( "se_logo_s" ) )
                        EndIf

                        If aScan( aNomeProd, {|x| Alltrim( x ) == "pdm_materiais_sub" } ) > 0
                            cTipo := "PA"
                        EndIf
                        If aScan( aNomeProd, {|x| Alltrim( x ) == "produto_intermediario_ou_materia-prima" } ) > 0 .Or. aScan( aNomeProd, {|x| Alltrim( x ) == "produto_intermediario_ou_materia-prima?" } ) > 0
                            If AllTrim( oJProd:GetJsonText( "produto_intermediario_ou_materia-prima" ) ) == "2" .And. aScan( aNomeProd, {|x| Alltrim( x ) == "produto_intermediario_ou_materia-prima" } ) > 0
                                cTipo := "MP"
                            ElseIf AllTrim( oJProd:GetJsonText( "produto_intermediario_ou_materia-prima?" ) ) == "2" .And. aScan( aNomeProd, {|x| Alltrim( x ) == "produto_intermediario_ou_materia-prima?" } ) > 0
                                cTipo := "MP"
                            Else
                                cTipo := "PI"
                            EndIf
                        EndIf
                        If aScan( aNomeProd, {|x| Alltrim( x ) == "pdm_servicos_sub" } ) > 0
                            cTipo := "SV"
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "codigo" } ) == 0
                                cDefServ := "SERV11000"
                                cDefSeLi := "SERV1ZZZZ"
 
                                cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 9 "
                                cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                TCQuery cQuery New Alias "CODPROD"
                                dbSelectArea("CODPROD")

                                If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                    cProximo := cDefServ
                                Else
                                    cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 9 )
                                EndIf

                                CODPROD->( dbCloseArea() )
                            Else
                                If Empty( oJProd:GetJsonText( "codigo" ) )
                                    cDefServ := "SERV11000"
                                    cDefSeLi := "SERV1ZZZZ"

                                    cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                    cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                    cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                    cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 9 "
                                    cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                    TCQuery cQuery New Alias "CODPROD"
                                    dbSelectArea("CODPROD")

                                    If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                        cProximo := cDefServ
                                    Else
                                        cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 9 )
                                    EndIf

                                    CODPROD->( dbCloseArea() )
                                EndIf
                            EndIf
                        EndIf
                        If aScan( aNomeProd, {|x| Alltrim( x ) == "pdm_consumo_sub" } ) > 0
                            cTipo    := "MC"
                            cDefServ := "E500000"
                            cDefSeLi := "E5ZZZZZ"
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "validar_o_codigo_u_ou_e?" } ) > 0
                                If AllTrim( oJProd:GetJsonText( "validar_o_codigo_u_ou_e?" ) ) == "1"
                                    cDefServ := "E500000"
                                    cDefSeLi := "E5ZZZZZ"
                                Else
                                    cDefServ := "U500000"
                                    cDefSeLi := "U5ZZZZZ"
                                EndIf
                            EndIf
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "validar_o_codigo_u_ou_e" } ) > 0
                                If AllTrim( oJProd:GetJsonText( "validar_o_codigo_u_ou_e" ) ) == "1"
                                    cDefServ := "E500000"
                                    cDefSeLi := "E5ZZZZZ"
                                Else
                                    cDefServ := "U500000"
                                    cDefSeLi := "U5ZZZZZ"
                                EndIf
                            EndIf
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "codigo" } ) == 0
                                cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 7 "
                                cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                TCQuery cQuery New Alias "CODPROD"
                                dbSelectArea("CODPROD")

                                If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                    cProximo := cDefServ
                                Else
                                    cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 7 )
                                EndIf

                                CODPROD->( dbCloseArea() )
                            Else
                                If Empty( oJProd:GetJsonText( "codigo" ) )
                                    cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                    cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                    cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                    cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 7 "
                                    cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                    TCQuery cQuery New Alias "CODPROD"
                                    dbSelectArea("CODPROD")

                                    If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                        cProximo := cDefServ
                                    Else
                                        cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 7 )
                                    EndIf

                                    CODPROD->( dbCloseArea() )
                                EndIf
                            EndIf
                        EndIf
                        If aScan( aNomeProd, {|x| Alltrim( x ) == "pdm_ativo_sub" } ) > 0
                            cTipo := "AI"
                                cDefServ := "E500000"
                                cDefSeLi := "E5ZZZZZ"
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "validar_o_codigo_u_ou_e?" } ) > 0
                                If AllTrim( oJProd:GetJsonText( "validar_o_codigo_u_ou_e?" ) ) == "1"
                                    cDefServ := "E500000"
                                    cDefSeLi := "E5ZZZZZ"
                                Else
                                    cDefServ := "U500000"
                                    cDefSeLi := "U5ZZZZZ"
                                EndIf
                            EndIf
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "validar_o_codigo_u_ou_e" } ) > 0
                                If AllTrim( oJProd:GetJsonText( "validar_o_codigo_u_ou_e" ) ) == "1"
                                    cDefServ := "E500000"
                                    cDefSeLi := "E5ZZZZZ"
                                Else
                                    cDefServ := "U500000"
                                    cDefSeLi := "U5ZZZZZ"
                                EndIf
                            EndIf
                            If aScan( aNomeProd, {|x| Alltrim( x ) == "codigo" } ) == 0
                                cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 7 "
                                cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                TCQuery cQuery New Alias "CODPROD"
                                dbSelectArea("CODPROD")

                                If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                    cProximo := cDefServ
                                Else
                                    cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 7 )
                                EndIf

                                CODPROD->( dbCloseArea() )
                            Else
                                If Empty( oJProd:GetJsonText( "codigo" ) )
                                    cQuery   := "SELECT MAX(B1_COD) CODIGO FROM " + RetSqlName("SB1") + " SB1 "
                                    cQuery   += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
                                    cQuery   += "AND B1_COD BETWEEN '" + cDefServ + "' AND '" + cDefSeLi + "' "
                                    cQuery   += "AND LENGTH(RTRIM(LTRIM(B1_COD))) = 7 "
                                    cQuery   += "AND SB1.D_E_L_E_T_ = ' ' "

                                    TCQuery cQuery New Alias "CODPROD"
                                    dbSelectArea("CODPROD")

                                    If CODPROD->( Eof() ) .Or. Empty( CODPROD->CODIGO )
                                        cProximo := cDefServ
                                    Else
                                        cProximo := Soma1( AllTrim( CODPROD->CODIGO ), 7 )
                                    EndIf

                                    CODPROD->( dbCloseArea() )
                                EndIf
                            EndIf
                        EndIf

                        If !Empty( cProximo )
                            ConOut( "Proximo " + cProximo )
                        EndIf

                        // Busca chave pelo Índice Primário do Layout...
                        If !Empty( cProximo )
                            dbSelectArea("SB1")
                            dbSetOrder( 1 )
                            cChave := AllTrim( cProximo )
                            If SB1->( dbSeek( xFilial("SB1") + cChave ) )
                                ConOut("Produto encontrado " + cChave)
                                nOperacao := 4
                                INCLUI    := .F.
                                ALTERA    := .T.
                                cCodigo   := SB1->B1_COD
                            Else
                                ConOut("Produto não encontrado " + cChave)
                                nOperacao := 3
                                INCLUI    := .T.
                                ALTERA    := .F.
                                cCodigo   := cChave
                            EndIf
                        Else
                            dbSelectArea("SB1")
                            dbSetOrder( Z9B->Z9B_INDICE )
                            If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_CHVIN1 ) } ) > 0
                                ConOut( "Chave Codigo: " + oJProd:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) )
                                cChave := AllTrim( oJProd:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) )
                                If SB1->( dbSeek( xFilial("SB1") + cChave ) )
                                    ConOut("Produto encontrado " + cChave)
                                    nOperacao := 4
                                    INCLUI    := .F.
                                    ALTERA    := .T.
                                    cCodigo   := SB1->B1_COD
                                Else
                                    ConOut("Produto não encontrado " + cChave)
                                    nOperacao := 3
                                    INCLUI    := .T.
                                    ALTERA    := .F.
                                    cCodigo   := cChave
                                EndIf
                            EndIf
                        EndIf

                        ConOut( "nOperacao.....: " + Str(nOperacao) )

                        dbSelectArea("Z9C")
                        dbSetOrder(1)
                        Z9C->( dbSeek( xFilial("Z9C") + "SB1" ) )

                        Do While !Z9C->( Eof() ) .And. AllTrim( Z9C->Z9C_CADAST ) == "SB1"
                            cSeparador := IIf( Z9C->Z9C_SEPARA == "T", "-", IIf( Z9C->Z9C_SEPARA == "B", "/", IIf( Z9C->Z9C_SEPARA == "V", ", ", IIf( Z9C->Z9C_SEPARA == "P", ";", ""))))

                            If AllTrim( Z9C->Z9C_CAMPO ) <> AllTrim( Z9B->Z9B_CPODEF ) .And. AllTrim( Z9C->Z9C_TRATAM ) <> "CHAVE" ;
                                     .And. AllTrim( Z9C->Z9C_TRATAM ) <> "GRUPO_EMPRESA"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "EMPRESA" ;
                                     .And. AllTrim( Z9C->Z9C_TRATAM ) <> "UNIDADE_NEGOCIO"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "FILIAL"

                                If (nOperacao == 4 .And. AllTrim( Z9C->Z9C_CAMPO ) <> "B1_COD") .Or. nOperacao <> 4
                                    If AllTrim( Z9C->Z9C_CPO4MD ) <> "FIXO"
                                        // Se membro não existir, pular o registro...
                                        If aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } ) > 0
                                            dbSelectArea("SX3")
                                            dbSetOrder(2)
                                            If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                                If SX3->X3_TIPO == "C"
                                                    If !Empty( Z9C->Z9C_TRATAM )
                                                        cConteudo := fTratar( oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( cConteudo, SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                    Else
                                                        // Se caractere, truncar pois dá erro se conteúdo for maior que X3_TAMANHO...
                                                        If Empty( Z9C->Z9C_CPOCOM )
                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                        Else
                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                        EndIf
                                                    EndIf
                                                ElseIf SX3->X3_TIPO == "N"
                                                    If !Empty( Z9C->Z9C_TRATAM )
                                                        nConteudo := fTratar( oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, nConteudo, AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                    Else
                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                    EndIf
                                                ElseIf SX3->X3_TIPO == "D"
                                                    If !Empty( Z9C->Z9C_TRATAM )
                                                        dConteudo := fTratar( oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, dConteudo, AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                    Else
                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                    EndIf
                                                Else
                                                    aAdd( aCampos, { Z9C->Z9C_CAMPO, oJProd:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                EndIf
                                            EndIf
                                        Else
                                            // Verificar as Subs... Arrays com Tags...
                                            lSub := .F.
                                            For nSub := 1 To Len( aSubs )
                                                nLinSub := 0
                                                nPosSub := aScan( aNomeProd, {|x| Alltrim( x ) == AllTrim( aSubs[nSub][1] ) } )
                                                If nPosSub > 0
                                                    oJSub := JsonObject():New()
                                                    oJSub := oJProd:GetJsonObject( aSubs[nSub][1] )
                                                    For nLinSub := 1 To Len( oJSub )
                                                        aNomeSub := oJSub[nLinSub]:GetNames()
                                                        If aScan( aNomeSub, {|x| Alltrim( x ) == "empresa" } ) > 0 .And. aScan( aNomeSub, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                            If AllTrim( oJSub[nLinSub]:GetJsonText( "empresa" ) ) == AllTrim( cEmpAnt )
                                                                dbSelectArea("SX3")
                                                                SX3->( dbSetOrder(2) )
                                                                SX3->( dbGoTop() )
                                                                If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                                                    If SX3->X3_TIPO == "C"
                                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                                            cConteudo := fTratar( oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( cConteudo, SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                        Else
                                                                           // Se caractere, truncar pois dá erro se conteúdo for maior que X3_TAMANHO...
                                                                            If Empty( Z9C->Z9C_CPOCOM )
                                                                                aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                            Else
                                                                                aAdd( aCampos, { Z9C->Z9C_CAMPO, Padr( oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                            EndIf
                                                                        EndIf
                                                                    ElseIf SX3->X3_TIPO == "N"
                                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                                            nConteudo := fTratar( oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, nConteudo, AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                        Else
                                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                        EndIf
                                                                    ElseIf SX3->X3_TIPO == "D"
                                                                        If !Empty( Z9C->Z9C_TRATAM )
                                                                            dConteudo := fTratar( oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, dConteudo, AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                        Else
                                                                            aAdd( aCampos, { Z9C->Z9C_CAMPO, oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                        EndIf
                                                                    Else
                                                                        aAdd( aCampos, { Z9C->Z9C_CAMPO, oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                                                    EndIf
                                                                Else
                                                                    ConOut("Sem SX3 - Campo Protheus da Sub: " + Z9C->Z9C_CAMPO)
                                                                    ConOut("Sem SX3 - Tag da Sub: " + Z9C->Z9C_CPO4MD)
                                                                    ConOut("Sem SX3 - Subs: " + oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ))
                                                                EndIf
                                                                lSub := .T.
                                                            Else
                                                                ConOut("Sem Empresa - Campo Protheus da Sub: " + Z9C->Z9C_CAMPO)
                                                                ConOut("Sem Empresa - Tag da Sub: " + Z9C->Z9C_CPO4MD)
                                                                ConOut("Sem Empresa - Subs: " + oJSub[nLinSub]:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ))
                                                            EndIf
                                                        EndIf
                                                    Next
                                                    //FreeObj( oJSub )
                                                    oJSub := Nil
                                                EndIf
                                            Next
                                            If !lSub
                                                ConOut("Tag Nao existe......: " + AllTrim( Z9C->Z9C_CPO4MD ) )
                                            EndIf
                                        EndIf
                                    Else
                                        If !Empty( Z9C->Z9C_TRATAM )
                                            If Left( AllTrim( Upper( Z9C->Z9C_TRATAM ) ), 4) == "CMD:"
                                                aAdd( aCampos, { Z9C->Z9C_CAMPO, &( Replace( Z9C->Z9C_TRATAM, "CMD:", "") ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                            Else
                                                aAdd( aCampos, { Z9C->Z9C_CAMPO, &( Z9C->Z9C_TRATAM ), AllTrim( Z9C->Z9C_CPO4MD ) } )
                                            EndIf
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf

                            Z9C->( dbSkip() )
                        EndDo

                        //Pegando o modelo de dados, setando a operação de inclusão
                        oModel := FWLoadModel("MATA010")
                        oModel:SetOperation(nOperacao)
                        oModel:Activate()

                        //Pegando o model dos campos da SB1
                        oSB1Mod := oModel:getModel("SB1MASTER")
                        If nOperacao == 3
                            If !Empty( cCodigo )
                                oSB1Mod:setValue("B1_COD"    , cCodigo           )
                            EndIf
                        EndIf

                        /* --> Será adicionado no layout e no 4MDG dentro das subs das empresas...
                        If !Empty( cTipo )
                            oSB1Mod:setValue("B1_TIPO"   , cTipo )
                        Else
                            oSB1Mod:setValue("B1_TIPO"   , "PA" )
                        EndIf
                        */
                        If aScan( aCampos, {|x| AllTrim( x[1] ) == "B1_TIPO" } ) == 0 // Somente se tag não estiver no layout...
                            If !Empty( cTipo )
                                oSB1Mod:setValue("B1_TIPO"   , cTipo )
                            Else
                                oSB1Mod:setValue("B1_TIPO"   , "PA" )
                            EndIf
                        EndIf

                        For nLin := 1 To Len( aCampos )
                            If !(AllTrim( aCampos[nLin][1] ) == "B1_COD" .And. AllTrim( aCampos[nLin][3] ) == "codigo") //.And. AllTrim( aCampos[nLin][1] ) <> "B1_TIPO"
                                // Se código de barras Schneider traz cCodBar
                                If AllTrim( aCampos[nLin][1] ) == "B1_CODBAR" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "numero_do_codigo_barras" .And. !Empty( cCodBar )
                                    oSB1Mod:setValue( aCampos[nLin][1], cCodBar )
                                ElseIf AllTrim( aCampos[nLin][1] ) == "B1_CODGTIN" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "gtin" .And. !Empty( cCodGTIN )
                                    oSB1Mod:setValue( aCampos[nLin][1], cCodGTIN )
                                ElseIf AllTrim( aCampos[nLin][1] ) == "B1_XSHDE5" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "desc_cx_espa" .And. !Empty( cDescCxEsp )
                                    oSB1Mod:setValue( aCampos[nLin][1], cDescCxEsp )
                                ElseIf AllTrim( aCampos[nLin][1] ) == "B1_XSTLOG" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "se_logo_s" .And. !Empty( cLogoS )
                                    oSB1Mod:setValue( aCampos[nLin][1], cLogoS )
                                ElseIf AllTrim( aCampos[nLin][1] ) == "B1_GRTRIB" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "grupo_tributacao" .And. !Empty( cGrTrib )
                                    oSB1Mod:setValue( aCampos[nLin][1], cGrTrib )
                                ElseIf AllTrim( aCampos[nLin][1] ) == "B1_DESC" .And. Empty( aCampos[nLin][2] ) .And. AllTrim( aCampos[nLin][3] ) == "descricao_curta_pdm" .And. !Empty( cB1Desc )
                                    oSB1Mod:setValue( aCampos[nLin][1], cB1Desc )
                                Else
                                    If ValType( aCampos[nLin][2] ) == "C"
                                        oSB1Mod:setValue( aCampos[nLin][1], aCampos[nLin][2] )
                                    Else
                                        oSB1Mod:setValue( aCampos[nLin][1], aCampos[nLin][2] )
                                    EndIf
                                EndIf
                            EndIf
                        Next

                        //Se conseguir validar as informações
                        If oModel:VldData()
                            //Tenta realizar o Commit
                            If oModel:CommitData()
                                lDeuCerto := .T.
                                dbSelectArea("SB1")
                                dbSetOrder( Z9B->Z9B_INDICE )
                                If SB1->( dbSeek( xFilial("SB1") + cChave ) )
                                    cB1Cod := SB1->B1_COD
                                EndIf
                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cB1Cod,cCodigo),IIf(Empty(cCodigo),"Produto incluido com sucesso","Produto alterado com sucesso")})
                                nStatusCode	:= 200
                                cMessage    := "Integracao Sucesso"
                                ConOut( "DEU CERTO MVC!" )
                            //Se não deu certo, altera a variável para false
                            Else
                                lDeuCerto := .F.
                            EndIf
                        //Se não conseguir validar as informações, altera a variável para false
                        Else
                            lDeuCerto := .F.
                        EndIf
 
                        //Se não deu certo a inclusão, mostra a mensagem de erro
                        If ! lDeuCerto
                            //Busca o Erro do Modelo de Dados
                            aErro := oModel:GetErrorMessage()
                            //Monta o Texto que será mostrado na tela
                            AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
                            AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
                            AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
                            AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
                            AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
                            AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
                            AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
                            AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
                            AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')

                            //Mostra a mensagem de Erro
                            cCompErro := DTOS( MsDate() ) + Replace( Time(), ":", "")
                            MostraErro("\system\","INTFOR4MDG" + cCompErro + ".txt")
                            cMensErro := MemoRead("\system\INTFOR4MDG" + cCompErro + ".txt")
                            aAdd( aMensagem, {"Erro gravação",cCodigo,cMensErro})
                            lRet 		:= .F.
                            nStatusCode	:= 500
                            cMessage    := "Erro na integracao ver mensagem!"
                            ConOut( "DEU ERRO!" )
/*
//                            nOpc := nOperacao
//
//                            For nLin := 1 To Len( aCampos )
//                                If !(AllTrim( aCampos[nLin][1] ) == "B1_COD" .And. nOperacao == 4)
//                                    aAdd( aRotAuto, { aCampos[nLin][1], aCampos[nLin][2], Nil})
//                                EndIf
//                            Next
//
//                        	MSExecAuto( {|x,y| MATA010(x,y)}, aRotAuto, nOpc )
//
//                            If lMsErroAuto
//                                //MostraErro("LOGS","PRODUTO_"+Alltrim(aRotAuto[1][2])+".log")
//                                DisarmTransaction()
//                                break
//                                aErroExcAut := GetAutoGRLog()	 
//                                cErroAut    := ""
//                                For nLin := 1 to Len(aErroExcAut)
//                                    cErroAut += " "+aErroExcAut[nLin]
//                                    If nLin > 5
//                                        Exit
//                                    EndIf
//                                Next

//                                ConOut( "ERRO AUTO: " + cErroAut )

                                If nOperacao == 3
                                    RecLock("SB1", .T.)
                                Else
                                    dbSelectArea("SB1")
                                    dbSetOrder(1)
                                    SB1->( dbSeek( xFilial("SB1") + cCodigo ) )
                                    RecLock("SB1", .F.)
                                EndIf
                                For nLin := 1 To Len( aCampos )
                                    If !(AllTrim( aCampos[nLin][1] ) == "B1_COD" .And. nOperacao == 4)
                                        &(aCampos[nLin][1]) := aCampos[nLin][2]
                                        ConOut( "Recno - Campo.......: " + aCampos[nLin][1] )
                                        ConOut( aCampos[nLin][2] )
                                    EndIf
                                Next
                                SB1->( MsUnLock() )
                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cB1Cod,cCodigo),IIf(Empty(cCodigo),"Produto incluido com sucesso","Produto alterado com sucesso")})
                                nStatusCode	:= 200
                                cMessage    := "Integracao Sucesso"
                                ConOut( "DEU CERTO!" )
//                            Else
//                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cB1Cod,cCodigo),IIf(Empty(cCodigo),"Produto incluido com sucesso","Produto alterado com sucesso")})
//                                nStatusCode	:= 200
//                                cMessage    := "Integracao Sucesso"
//                                ConOut( "DEU CERTO AUTO!" )
//                            EndIf
*/
                        Else
                            dbSelectArea("SB1")
                            dbSetOrder(1)
                            SB1->( dbSeek( xFilial("SB1") + cCodigo ) )
                            RecLock("SB1", .F.)
                            For nLin := 1 To Len( aCampos )
                                If !(AllTrim( aCampos[nLin][1] ) == "B1_COD")
                                    &(aCampos[nLin][1]) := aCampos[nLin][2]
                                    ConOut( "Recno - Campo.......: " + aCampos[nLin][1] )
                                    ConOut( aCampos[nLin][2] )
                                EndIf
                            Next
                            SB1->( MsUnLock() )
                        EndIf

                        ConOut( Replicate( "-", 60 ) )

                        //Desativa o modelo de dados
                        oSB1Mod:DeActivate()
                    End Sequence
                Else
                    aAdd( aMensagem, {"Layout Integracao Nao definida","","Efetuar cadastro de layout do metodo produtos"})
                    lRet 		:= .F.
                    nStatusCode	:= 400
                    cMessage    := "Dados inválidos!"
                EndIf
        	Else
                aAdd( aMensagem, {"Dados Inválido","","Falta membros obrigatórios na body"})
				lRet 		:= .F.
				nStatusCode	:= 400
				cMessage    := "Dados inválidos!"
			EndIf
		EndIf
    Else
        ConOut("8")

        aAdd( aMensagem, {"Não há dados","","Body vazia"})
		lRet 		:= .F.
		nStatusCode	:= 400
		cMessage    := "Não há dados!"
	EndIf
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If SB1->( dbSeek( xFilial("SB1") + cCodigo ) )
    If !Empty( SB1->B1_CODBAR )
        cCodBar := AllTrim( SB1->B1_CODBAR )
    Else
        If Empty( SB1->B1_CODBAR ) .And. !Empty( cCodBar )
            RecLock("SB1", .F.)
                SB1->B1_CODBAR := cCodBar
            MsUnLock()
        EndIf
    EndIf
    If !Empty( cCodGTIN )
        If AllTrim( SB1->B1_CODGTIN ) <> AllTrim( cCodGTIN )
            RecLock("SB1", .F.)
                SB1->B1_CODGTIN := cCodGTIN
            MsUnLock()
        EndIf
    EndIf
    If !Empty( cB1Desc )
        If AllTrim( SB1->B1_DESC ) <> AllTrim( cB1Desc )
            RecLock("SB1", .F.)
                SB1->B1_DESC := cB1Desc
            MsUnLock()
        EndIf
    EndIf

    If !Empty( cGrTrib )
        If AllTrim( SB1->B1_GRTRIB ) <> AllTrim( cGrTrib )
            RecLock("SB1", .F.)
                SB1->B1_GRTRIB := cGrTrib
            MsUnLock()
        EndIf
    EndIf
    If !Empty( cDescCxEsp )
        If AllTrim( SB1->B1_XSHDE5 ) <> AllTrim( cDescCxEsp )
            RecLock("SB1", .F.)
                SB1->B1_XSHDE5 := cDescCxEsp
            MsUnLock()
        EndIf
    EndIf
    If !Empty( cLogoS )
        If AllTrim( SB1->B1_XSTLOG ) <> AllTrim( cLogoS )
            RecLock("SB1", .F.)
                SB1->B1_XSTLOG := cLogoS
            MsUnLock()
        EndIf
    EndIf
EndIf

If ValType( oJRet ) <> "O" .And. ValType( oJRet ) <> "J"
	oJRet 	        :=  JsonObject():New()
	oJRet["itens"]  := {}     
EndIf

If ValType( oJRet["itens"] ) <> "A" .And. ValType( oJRet["itens"] ) <> "O"
	oJRet["itens"]  := {}
EndIf

ConOut( "Len(aMensagem): " + StrZero( Len(aMensagem), 3) )
ConOut( VarInfo("", aMensagem, , .F.) )

oJRetItens  :=  JsonObject():New()
oJRetItens["ajuda"]                          := aMensagem[1][1]
oJRetItens["numero"]                         := aMensagem[1][2]
oJRetItens["mensagem"]                       := aMensagem[1][3]
oJRetItens["codigo_gerado"]                  := cCodigo
oJRetItens["numero_do_codigo_barras_gerado"] := cCodBar
oJRetItens["empresa"]                        := cEmpAnt
oJRetItens["filial"]                         := cFilAnt
oJRetItens["nome_empresa"]                   := AllTrim( SM0->M0_NOMECOM )

aAdd(oJRet["itens"], oJRetItens)

cData := DTOS( MsDate() )

If Len( aMensagem ) == 0
    oJRet["total"]   := Len(oJRet["itens"])
    oJRet["hasNext"]                                             := .F. //"false"
    oJRet["status_da_integracao"]                                := "500"
    oJRet["mensagem_do_retorno_de_integracao_com_o_protheus"]    := cJsonRet
    oJRet["data_e_hora_do_retorno_da_integracao_com_o_protheus"] := Right( cDAta, 2) + "/" + SubStr( cData, 5, 2) + "/" + Left( cData, 4) + " " + Time()
Else
    oJRet["total"]   := Len(oJRet["itens"])
    oJRet["hasNext"]                                             := .F. //"false"
    oJRet["status_da_integracao"]                                := AllTrim( Str( nStatusCode ) )
    oJRet["mensagem_do_retorno_de_integracao_com_o_protheus"]    := aMensagem[1][3]
    oJRet["data_e_hora_do_retorno_da_integracao_com_o_protheus"] := Right( cDAta, 2) + "/" + SubStr( cData, 5, 2) + "/" + Left( cData, 4) + " " + Time()
EndIf

//ConOut( VarInfo("", oJRet, , .F.) )

If lRet
    cJsonRet := EncodeUTF8(oJRet:toJSON())
    Self:SetResponse(cJsonRet)
Else
//    cJsonRet := EncodeUTF8(oJRet:toJSON())
//    SetRestFault(500,cJsonRet,.T.,/* nStatus */,/* cDetailMsg */,,)
    cJsonRet := EncodeUTF8(oJRet:toJSON())
    Self:SetResponse(cJsonRet)
    lRet := .T.
Endif

// criar campo de retorno de erro tratado...

ConOut("SetResponse..: " + EncodeUTF8(oJRet:toJSON()))
ConOut("lRet.........: " + IIf( lRet, ".T.", ".F."))
ConOut("nStatusCode..: " + StrZero( nStatusCode, 3))

If AllTrim( Upper( ValType(oJRet) ) ) == "O" .Or. AllTrim( Upper( ValType(oJRet) ) ) == "J"
	FreeObj(oJRet)
	oJRet := Nil
Endif

Return lRet

WSMETHOD POST Clientes WSSERVICE 4MDGAPI

Local lRet          := .T.
Local nStatusCode   := 201
Local cMessage      := ""
Local oJCliente        := JSonObject():New()
Local cBody         := ""
Local oJRet		    := Nil
Local oJRetItens    := Nil
Local nOperacao     := 0
Local lDeuCerto     := .F.
Local lLayout       := .F.
Local cCodigo       := ""
Local cA1Cod        := ""
Local cMensErro     := ""
Local aErro         := {}
Local aMensagem     := {}
Local aNomeFor      := {}
Local cMun          := ""
Local cEst          := ""
Local cSeparador    := ""
Local cConteudo     := ""
Local nConteudo     := 0
Local dConteudo     := STOD("        ")
Local cEmpAPI       := ""
Local cFilAPI       := ""

Private cTipo       := ""
Private cChave      := ""
Private lMsHelpAuto , lMsErroAuto, lMsFinalAuto := .F.
Private INCLUI      := .T.
Private ALTERA      := .F.
Private EXCLUI      := .F.

Self:SetContentType("application/json")

If Len(cFilant) <> TamSX3("A1_FILIAL")[1]
	ConOut( Replicate("R",80) )
	ConOut('['+DtoC(date())+' - '+Time()+'] FILIAL COM TAMANHO INCORRETO NA TRANSFERENCIA ==> '+ Alltrim(str(Len(cFilant))) + ' <== FILIAL ==> ' + cFilAnt + ' <== TAMANHO CORRETO ==> ' + Alltrim(str(TamSX3("A1_FILIAL")[1])))
	ConOut( Replicate("R",80) )

//	RpcClearEnv()

//	PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL padr(cFilOld,TamSX3("A1_FILIAL")[1]) MODULO "SIGACOM" TABLES "SA1"
Endif

If Len(Self:aURLParms) > 0

    cBody := Self:GetContent()
    cBody := Replace( cBody, "null", '""' )

    If !Empty( cBody )

		//FWJsonDeserialize(Upper(cBody),@oJCliente)
        oJCliente    := JSonObject():New()
        cParse    := oJCliente:fromJson( cBody )
        aNomeFor  := oJCliente:GetNames()
        
        If AllTrim( Upper( ValType( oJCliente ) ) ) == "O" .Or. AllTrim( Upper( ValType( oJCliente ) ) ) == "J"

            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( "dados_cliente_fornecedor_ambos" ) } ) > 0
                // Valida se Layout existe e está preenchido...
                dbSelectArea("Z9A")
                dbSetOrder(1)
                Z9A->( dbGoTop() )
                If !Z9A->( Eof() ) .And. AllTrim( Z9A->Z9A_ATIVO ) == "S"
                    dbSelectArea("Z9B")
                    dbSetOrder(1)
                    If Z9B->( dbSeek( xFilial("Z9B") + "SA1" ) )
                        dbSelectArea("Z9C")
                        dbSetOrder(1)
                        If Z9C->( dbSeek( xFilial("Z9C") + "SA1" ) )
                            lLayout := .T.
                        Else
                            lLayout := .F.
                        EndIf
                    Else
                        lLayout := .F.
                    EndIf
                Else
                    lLayout := .F.
                EndIf

                If lLayout
                    // Tratar compartilhamento do cadastro antes de iniciar processo...
                    cEmpAPI := cEmpAnt
                    cFilAPI := cFilAnt

                    If !Empty( Z9B->Z9B_TAGGRU ) .Or. !Empty( Z9B->Z9B_TAGEMP ) .Or. !Empty( Z9B->Z9B_TAGUNI ) .Or. !Empty( Z9B->Z9B_TAGFIL )
                        If !Empty( Z9B->Z9B_TAGGRU )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGGRU ) } ) > 0
                                cEmpAPI := oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGGRU ) )
                            EndIf
                            cFilAPI := ""
                            If !Empty( Z9B->Z9B_TAGEMP )
                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                                    cFilAPI += oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                                EndIf
                            EndIf
                            If !Empty( Z9B->Z9B_TAGUNI )
                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGUNI ) } ) > 0
                                    cFilAPI += oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGUNI ) )
                                EndIf
                            EndIf
                            If !Empty( Z9B->Z9B_TAGFIL )
                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                    cFilAPI += oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                                EndIf
                            EndIf
                        ElseIf !Empty( Z9B->Z9B_TAGEMP )
                            If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGEMP ) } ) > 0
                                cEmpAPI := oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGEMP ) )
                            EndIf
                            If !Empty( Z9B->Z9B_TAGFIL )
                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_TAGFIL ) } ) > 0
                                    cFilAPI := oJCliente:GetJsonText( AllTrim( Z9B->Z9B_TAGFIL ) )
                                EndIf
                            EndIf
                        EndIf

                        If AllTrim( cEmpAPI ) <> AllTrim( cEmpAnt ) .Or. AllTrim( cFilAPI ) <> AllTrim( cFilAnt )
                            cEmpAnt := cEmpAPI
                            cFilAnt := cFilAPI
                        	//PREPARE ENVIRONMENT EMPRESA cEmpAPI FILIAL cFilAPI MODULO "SIGACOM" TABLES "SA1"
                        EndIf
                    EndIf

                    Begin Sequence 
                        oJRet 	        :=  JsonObject():New()
                        oJRet["itens"]  := {}     

                        cChave := ""
                        cMun   := ""
                        cEst   := ""
                        ConOut( Replicate( "-", 60 ) )
                        ConOut( "Data " + DTOC( dDataBase ) + " Time " + Time() )

                        // Busca chave pelo Índice Primário do Layout... (CNPJ)
                        dbSelectArea("SA1")
                        dbSetOrder( Z9B->Z9B_INDICE )
                        If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_CHVIN1 ) } ) > 0
                            ConOut( "Chave CNPJ: " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) )
                            oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) := Replace(Replace(Replace(oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ),".",""),"/",""),"-","")
                            cChave := oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) )
                            If SA1->( dbSeek( xFilial("SA1") + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ) ) )
                                ConOut("CNPJ encontrado " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ))
                                nOperacao := 4
                                INCLUI    := .F.
                                ALTERA    := .T.
                                cCodigo   := SA1->A1_COD
                                cTipo     := SA1->A1_TIPO
                                ConOut( "001 - Código..: " + SA1->A1_COD )
                                ConOut( "001 - Loja....: " + SA1->A1_LOJA )
                                ConOut( "001 - cCodigo.......: " + cCodigo )
                            Else
                                ConOut("CNPJ não encontrado " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_CHVIN1 ) ))
                                nOperacao := 3
                                INCLUI    := .T.
                                ALTERA    := .F.
                                cCodigo   := ""
                                cTipo     := "J"
                            EndIf
                        EndIf

                        // Busca chave pelo Índice Alternativo do Layout... (CPF)
                        If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9B->Z9B_ALTIN1 ) } ) > 0 .And. Empty( cChave )
                            If !Empty( oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                                ConOut( "Chave CPF: " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                                oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) := Replace(Replace(Replace(oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ),".",""),"/",""),"-","")
                                cChave := oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) )
                                If dbSeek(xFilial("SA1") + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ) )
                                    ConOut("CPF encontrado " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ))
                                    nOperacao := 4
                                    INCLUI    := .F.
                                    ALTERA    := .T.
                                    cCodigo   := SA1->A1_COD
                                    cTipo     := SA1->A1_TIPO
                                    ConOut( "002 - Código..: " + SA1->A1_COD )
                                    ConOut( "002 - Loja....: " + SA1->A1_LOJA )
                                    ConOut( "002 - cCodigo.......: " + cCodigo )
                                Else
                                    ConOut("CPF não encontrado " + oJCliente:GetJsonText( AllTrim( Z9B->Z9B_ALTIN1 ) ))
                                    nOperacao := 3
                                    INCLUI    := .T.
                                    ALTERA    := .F.
                                    cCodigo   := ""
                                    cTipo     := "F"
                                EndIf
                            Else
                                nOperacao := 3
                                cCodigo   := ""
                                cTipo     := "X"
                            EndIf
                        EndIf

                        ConOut( "003 - cCodigo.......: " + cCodigo )
                        ConOut( "003 - nOperacao.....: " + Str(nOperacao) )

                        //Pegando o modelo de dados, setando a operação de inclusão
                        oModel := FWLoadModel("MATA030")
                        oModel:SetOperation(nOperacao)
                        oModel:Activate()

                        dbSelectArea("Z9C")
                        dbSetOrder(1)
                        Z9C->( dbSeek( xFilial("Z9C") + "SA1" ) )

                        //Pegando o model dos campos da SA1
                        oSA1Mod:= oModel:getModel("SA1MASTER")

                        If !Empty( cCodigo )
                            oSA1Mod:setValue("A1_COD"    , cCodigo           )
                        Else
                            oSA1Mod:setValue("A1_LOJA"   , "01"           )
                        EndIf
                        oSA1Mod:setValue("A1_CGC"    , cChave )
                        oSA1Mod:setValue("A1_TIPO"   , cTipo )

                        ConOut( "004 - cCodigo.......: " + cCodigo )
                        ConOut( "004 - nOperacao.....: " + Str(nOperacao) )
                        ConOut( "004 - cChave........: " + cChave )

                        Do While !Z9C->( Eof() ) .And. AllTrim( Z9C->Z9C_CADAST ) == "SA1"
                            cSeparador := IIf( Z9C->Z9C_SEPARA == "T", "-", IIf( Z9C->Z9C_SEPARA == "B", "/", IIf( Z9C->Z9C_SEPARA == "V", ", ", IIf( Z9C->Z9C_SEPARA == "P", ";", ""))))

                            If AllTrim( Z9C->Z9C_CAMPO ) <> AllTrim( Z9B->Z9B_CPODEF ) .And. AllTrim( Z9C->Z9C_TRATAM ) <> "CHAVE" ;
                                     .And. AllTrim( Z9C->Z9C_TRATAM ) <> "GRUPO_EMPRESA"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "EMPRESA" ;
                                     .And. AllTrim( Z9C->Z9C_TRATAM ) <> "UNIDADE_NEGOCIO"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "FILIAL"
                                ConOut(Z9C->Z9C_CAMPO)
                                ConOut(Z9C->Z9C_CPO4MD)
                                If AllTrim( Z9C->Z9C_CPO4MD ) <> "FIXO"
                                    // Se membro não existir, pular o registro...
                                    If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } ) > 0
                                        dbSelectArea("SX3")
                                        dbSetOrder(2)
                                        If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                            If SX3->X3_TIPO == "C"
                                                If !Empty( Z9C->Z9C_TRATAM )
                                                    cConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                    oSA1Mod:setValue( Z9C->Z9C_CAMPO, Padr( cConteudo, SX3->X3_TAMANHO) )
                                                Else
                                                    If Empty( Z9C->Z9C_CPOCOM )
                                                        oSA1Mod:setValue( Z9C->Z9C_CAMPO, Padr( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO) )
                                                    Else
                                                        oSA1Mod:setValue( Z9C->Z9C_CAMPO, Padr( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO) )
                                                    EndIf
                                                EndIf
                                            ElseIf SX3->X3_TIPO == "N"
                                                If !Empty( Z9C->Z9C_TRATAM )
                                                    nConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                    oSA1Mod:setValue( Z9C->Z9C_CAMPO, nConteudo )
                                                Else
                                                    oSA1Mod:setValue( Z9C->Z9C_CAMPO, oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                                EndIf
                                            ElseIf SX3->X3_TIPO == "D"
                                                If !Empty( Z9C->Z9C_TRATAM )
                                                    dConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                    oSA1Mod:setValue( Z9C->Z9C_CAMPO, dConteudo )
                                                Else
                                                    oSA1Mod:setValue( Z9C->Z9C_CAMPO, oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                                EndIf
                                            Else
                                                oSA1Mod:setValue( Z9C->Z9C_CAMPO, oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) )
                                            EndIf
                                        EndIf
                                        ConOut(oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ))
                                    Else
                                        ConOut("Membro da Tag não existe")
                                    EndIf
                                Else
                                    If !Empty( Z9C->Z9C_TRATAM )
                                        If Left( AllTrim( Upper( Z9C->Z9C_TRATAM ) ), 4) == "CMD:"
                                            oSA1Mod:setValue( Z9C->Z9C_CAMPO, &( Replace( Z9C->Z9C_TRATAM, "CMD:", "") ) )
                                            ConOut(&(Replace( Z9C->Z9C_TRATAM, "CMD:", "")))
                                        Else
                                            oSA1Mod:setValue( Z9C->Z9C_CAMPO, &( Z9C->Z9C_TRATAM ) )
                                            ConOut(&(Z9C->Z9C_TRATAM))
                                        EndIf
                                    EndIf
                                EndIf
                            EndIf

                            //Tratar código do município...
                            If AllTrim( Z9C->Z9C_CAMPO ) == "A1_MUN"
                                cMun := oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                            ElseIf AllTrim( Z9C->Z9C_CAMPO ) == "A1_EST"
                                cEst := oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                            EndIf

                            Z9C->( dbSkip() )
                        EndDo

                        ConOut( "005 - cCodigo.......: " + cCodigo )
                        ConOut( "005 - nOperacao.....: " + Str(nOperacao) )
                        ConOut( "005 - cChave........: " + cChave )

                        // Inclui campo Código do Município se encontrar...
                        If !Empty( cMun ) .And. !Empty( cEst )
                            cQuery := "SELECT CC2_CODMUN FROM " + RetSqlName("CC2") + " WHERE CC2_FILIAL = '" + xFilial("CC2") + "' AND CC2_EST = '" + cEst + "' AND CC2_MUN LIKE '%" + cMun + "%' AND D_E_L_E_T_ = ' '"
                            TCQuery cQuery New Alias "TMPCC2"
                            dbSelectArea("TMPCC2")
                            TMPCC2->( dbGoTop() )
                            If !TMPCC2->( Eof() )
                                oSA1Mod:setValue( "A1_COD_MUN", TMPCC2->CC2_CODMUN )
                            EndIf
                            TMPCC2->( dbCloseArea() )
                        EndIf

                        If nOperacao == 4
                            //oSA1Mod:setValue( "A1_COD", SA1->A1_COD )
                            //oSA1Mod:setValue( "A1_LOJA", SA1->A1_LOJA )
                            ConOut( "003 - Código..: " + SA1->A1_COD )
                            ConOut( "003 - Loja....: " + SA1->A1_LOJA )
                            ConOut( "006 - cCodigo.......: " + cCodigo )
                            ConOut( "006 - nOperacao.....: " + Str(nOperacao) )
                            ConOut( "006 - cChave........: " + cChave )
                        EndIf

                        //Se conseguir validar as informações
                        If oModel:VldData()
                            //Tenta realizar o Commit
                            If oModel:CommitData()
                                lDeuCerto := .T.
                                dbSelectArea("SA1")
                                dbSetOrder( Z9B->Z9B_INDICE )
                                If SA1->( dbSeek( xFilial("SA1") + cChave ) )
                                    cA1Cod := SA1->A1_COD
                                EndIf
                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA1Cod,cCodigo),IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso")})
                                ConOut( "DEU CERTO!" )
                                ConOut( "004 - Código..: " + SA1->A1_COD )
                                ConOut( "004 - Loja....: " + SA1->A1_LOJA )
                            //Se não deu certo, altera a variável para false
                            Else
                                lDeuCerto := .F.
                                ConOut( "005 - Código..: " + SA1->A1_COD )
                                ConOut( "005 - Loja....: " + SA1->A1_LOJA )
                            EndIf
                        //Se não conseguir validar as informações, altera a variável para false
                        Else
                            lDeuCerto := .F.
                            ConOut( "006 - Código..: " + SA1->A1_COD )
                            ConOut( "006 - Loja....: " + SA1->A1_LOJA )
                        EndIf
 
                        ConOut( "007 - cCodigo.......: " + cCodigo )
                        ConOut( "007 - nOperacao.....: " + Str(nOperacao) )
                        ConOut( "007 - cChave........: " + cChave )

                       //Se não deu certo a inclusão, mostra a mensagem de erro
                        If ! lDeuCerto
                            //Busca o Erro do Modelo de Dados
                            aErro := oModel:GetErrorMessage()
                            //Monta o Texto que será mostrado na tela
                            AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
                            AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
                            AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
                            AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
                            AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
                            AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
                            AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
                            AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
                            AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
                            If nOperacao == 4 .And. cCodigo == SA1->A1_COD
                                RecLock("SA1", .F.)
                                    dbSelectArea("Z9C")
                                    dbSetOrder(1)
                                    Z9C->( dbSeek( xFilial("Z9C") + "SA1" ) )
                                    Do While !Z9C->( Eof() ) .And. AllTrim( Z9C->Z9C_CADAST ) == "SA1"
                                        cSeparador := IIf( Z9C->Z9C_SEPARA == "T", "-", IIf( Z9C->Z9C_SEPARA == "B", "/", IIf( Z9C->Z9C_SEPARA == "V", ", ", IIf( Z9C->Z9C_SEPARA == "P", ";", ""))))

                                        If AllTrim( Z9C->Z9C_CAMPO ) <> AllTrim( Z9B->Z9B_CPODEF ) .And. AllTrim( Z9C->Z9C_TRATAM ) <> "CHAVE" ;
                                                .And. AllTrim( Z9C->Z9C_TRATAM ) <> "GRUPO_EMPRESA"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "EMPRESA" ;
                                                .And. AllTrim( Z9C->Z9C_TRATAM ) <> "UNIDADE_NEGOCIO"  .And. AllTrim( Z9C->Z9C_TRATAM ) <> "FILIAL"
                                            If AllTrim( Z9C->Z9C_CPO4MD ) <> "FIXO"
                                                // Se membro não existir, pular o registro...
                                                If aScan( aNomeFor, {|x| Alltrim( x ) == AllTrim( Z9C->Z9C_CPO4MD ) } ) > 0
                                                    dbSelectArea("SX3")
                                                    dbSetOrder(2)
                                                    If SX3->( dbSeek( Z9C->Z9C_CAMPO ) )
                                                        If SX3->X3_TIPO == "C"
                                                            If !Empty( Z9C->Z9C_TRATAM )
                                                                cConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( cConteudo, SX3->X3_TAMANHO)
                                                            Else
                                                                // Se caractere, truncar pois dá erro se conteúdo for maior que X3_TAMANHO...
                                                                If Empty( Z9C->Z9C_CPOCOM )
                                                                    &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), SX3->X3_TAMANHO)
                                                                Else
                                                                    &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := Padr( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ) + cSeparador + oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPOCOM ) ), SX3->X3_TAMANHO)
                                                                EndIf
                                                            EndIf
                                                        ElseIf SX3->X3_TIPO == "N"
                                                            If !Empty( Z9C->Z9C_TRATAM )
                                                                nConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := nConteudo
                                                            Else
                                                                &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                            EndIf
                                                        ElseIf SX3->X3_TIPO == "D"
                                                            If !Empty( Z9C->Z9C_TRATAM )
                                                                dConteudo := fTratar( oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) ), AllTrim( Z9C->Z9C_TRATAM ))
                                                                &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := dConteudo
                                                            Else
                                                                &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                            EndIf
                                                        Else
                                                            &( "SA1->" + AllTrim( Z9C->Z9C_CAMPO ) ) := oJCliente:GetJsonText( AllTrim( Z9C->Z9C_CPO4MD ) )
                                                        EndIf
                                                    EndIf
                                                EndIf
                                            EndIf
                                        EndIf
                                        Z9C->( dbSkip() )
                                    EndDo
                                MsUnLock()
                                ConOut( Replicate("*", 60))
                                ConOut( VarInfo("", oSA1Mod, , .F.) )
                                ConOut( Replicate("*", 60))
                                ConOut( "RECNO NO ALTER FORCE!" )
                                lDeuCerto := .T.
                                cA1Cod := SA1->A1_COD
                                aAdd( aMensagem, {"Integracao Sucesso",IIf(Empty(cCodigo),cA1Cod,cCodigo),IIf(Empty(cCodigo),"Fornecedor incluido com sucesso","Fornecedor alterado com sucesso")})
                                ConOut( "DEU CERTO!" )
                                ConOut( "004 - Código..: " + SA1->A1_COD )
                                ConOut( "004 - Loja....: " + SA1->A1_LOJA )
                            Else
                                //Mostra a mensagem de Erro
                                cCompErro := DTOS( MsDate() ) + Replace( Time(), ":", "")
                                MostraErro("\system\","INTFOR4MDG" + cCompErro + ".txt")
                                cMensErro := MemoRead("\system\INTFOR4MDG" + cCompErro + ".txt")
                                aAdd( aMensagem, {"Erro gravação",cCodigo,cMensErro})
                                ConOut( "DEU ERRO!" )
                            EndIf
                        EndIf

                        ConOut( Replicate( "-", 60 ) )

                        //Desativa o modelo de dados
                        oModel:DeActivate()
                    End Sequence
                Else
                    aAdd( aMensagem, {"Layout Integracao Nao definida","","Efetuar cadastro de layout do metodo fornecedor"})
                    lRet 		:= .F.
                    nStatusCode	:= 400
                    cMessage    := "Dados inválidos!"
                EndIf
        	Else
                aAdd( aMensagem, {"Dados Inválido","","Falta membros obrigatórios na body"})
				lRet 		:= .F.
				nStatusCode	:= 400
				cMessage    := "Dados inválidos!"
			EndIf
		EndIf
    Else
        aAdd( aMensagem, {"Não há dados","","Body vazia"})
		lRet 		:= .F.
		nStatusCode	:= 400
		cMessage    := "Não há dados!"
	EndIf
EndIf

ConOut( "Len(aMensagem): " + StrZero( Len(aMensagem), 3) )
ConOut( VarInfo("", aMensagem, , .F.) )

oJRetItens  :=  JsonObject():New()
oJRetItens["ajuda"]      := aMensagem[1][1]
oJRetItens["numero"]     := aMensagem[1][2]
oJRetItens["mensagem"]   := aMensagem[1][3]
aAdd(oJRet["itens"], oJRetItens)

oJRet["total"]   := Len(oJRet["itens"])
oJRet["hasNext"] := .F. //"false"

ConOut( VarInfo("", oJRet, , .F.) )

If lRet
	self:SetResponse(EncodeUTF8(oJRet:toJSON()))
Else
	SetRestFault( nStatusCode, EncodeUTF8("") )
	self:SetResponse(EncodeUTF8(oJRet:toJSON()))
Endif

ConOut("SetResponse..: " + EncodeUTF8(oJRet:toJSON()))
ConOut("lRet.........: " + IIf( lRet, ".T.", ".F."))
ConOut("nStatusCode..: " + StrZero( nStatusCode, 6))

If ValType(oJRet) == "O"
	FreeObj(oJRet)
	oJRet := Nil
Endif

Return lRet

Static Function NoAcento( cString, lMoeda )

Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

Default lMoeda := .F.

If ValType( cString ) <> "C"
    Return cString
EndIf

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0          
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString 
	cString := strTran( cString, cMaior, "" ) 
EndIf
If cMenor$ cString 
	cString := strTran( cString, cMenor, "" )
EndIf
cString := StrTran( cString, CRLF, " " )

cString := StrTran(cString,"ISO-8859-1","UTF-8")
cString := StrTran(cString,"AƒASAƒAu","co")
cString := StrTran(cString,"AƒA¡","a")
cString := StrTran(cString,"AƒAS","c")
cString := StrTran(cString,"AƒA£","a")
cString := StrTran(cString,"AƒA3","o")
cString := StrTran(cString,"AƒA©","e")
cString := StrTran(cString,"AƒA-","i")
cString := StrTran(cString,"AƒA'","o")
cString := StrTran(cString,"AƒAS","c")
cString := StrTran(cString,"AƒA3","o")
cString := StrTran(cString,"AƒAu","o")
cString := StrTran(cString,"AƒAS","c")
cString := StrTran(cString,"ASAu","co")
cString := StrTran(cString,"ASAÂ£","ca")
cString := StrTran(cString,"AÂ¡","a")
cString := StrTran(cString,"AÂ£","a")
cString := StrTran(cString,"AÂ¢","a")
cString := StrTran(cString,"AÂ©","o")
cString := StrTran(cString,"A-","i")
cString := StrTran(cString,"á","a")
cString := StrTran(cString,"Á","A")
cString := StrTran(cString,"à","a")
cString := StrTran(cString,"À","A")
cString := StrTran(cString,"ã","a")
cString := StrTran(cString,"Ã","A")
cString := StrTran(cString,"â","a")
cString := StrTran(cString,"Â","A")
cString := StrTran(cString,"ä","a")
cString := StrTran(cString,"Ä","A")
cString := StrTran(cString,"é","e")
cString := StrTran(cString,"É","E")
cString := StrTran(cString,"ë","e")
cString := StrTran(cString,"Ë","E")
cString := StrTran(cString,"ê","e")
cString := StrTran(cString,"Ê","E")
cString := StrTran(cString,"í","i")
cString := StrTran(cString,"Í","I")
cString := StrTran(cString,"ï","i")
cString := StrTran(cString,"Ï","I")
cString := StrTran(cString,"î","i")
cString := StrTran(cString,"Î","I")
cString := StrTran(cString,"ý","y")
cString := StrTran(cString,"Ý","y")
cString := StrTran(cString,"ÿ","y")
cString := StrTran(cString,"ó","o")
cString := StrTran(cString,"Ó","O")
cString := StrTran(cString,"õ","o")
cString := StrTran(cString,"Õ","O")
cString := StrTran(cString,"ö","o")
cString := StrTran(cString,"Ö","O")
cString := StrTran(cString,"ô","o")
cString := StrTran(cString,"Ô","O")
cString := StrTran(cString,"ò","o")
cString := StrTran(cString,"Ò","O")
cString := StrTran(cString,"ú","u")
cString := StrTran(cString,"Ú","U")
cString := StrTran(cString,"ù","u")
cString := StrTran(cString,"Ù","U")
cString := StrTran(cString,"ü","u")
cString := StrTran(cString,"Ü","U")
cString := StrTran(cString,"ç","c")
cString := StrTran(cString,"Ç","C")
cString := StrTran(cString,"º","o")
cString := StrTran(cString,"°","o")
cString := StrTran(cString,"ª","a")
cString := StrTran(cString,"ñ","n")
cString := StrTran(cString,"Ñ","N")
cString := StrTran(cString,"²","2")
cString := StrTran(cString,"³","3")
cString := StrTran(cString,"’","'")
cString := StrTran(cString,"§","S")
cString := StrTran(cString,"±","+")
cString := StrTran(cString,"­","-")
cString := StrTran(cString,"´","'")
cString := StrTran(cString,"o","o")
cString := StrTran(cString,"µ","u")
cString := StrTran(cString,"¼","1/4")
cString := StrTran(cString,"½","1/2")
cString := StrTran(cString,"¾","3/4")
cString := StrTran(cString,"&","e") 
cString := StrTran(cString,"þ","b")
cString := StrTran(cString,"¿",".")
cString := StrTran(cString,"ø","o")
cString := StrTran(cString,"Ø","O")
cString := StrTran(cString,"*",".")
cString := StrTran(cString,"AƒASAƒAu","co")
cString := StrTran(cString,"AƒA¡","a")
cString := StrTran(cString,"AƒAS","c")
cString := StrTran(cString,"AƒA£","a")
cString := StrTran(cString,"AƒA3","o")
cString := StrTran(cString,"AƒA©","e")
cString := StrTran(cString,"AƒA-","i")
cString := StrTran(cString,"AƒA'","o")
cString := StrTran(cString,"AƒAS","c")
cString := StrTran(cString,"AƒA3","o")
cString := StrTran(cString,"AƒAu","o")
cString := StrTran(cString,"AƒAS","ç")
cString := StrTran(cString,"ASAu","ço")
cString := StrTran(cString,"ASAÂ£","çõ")
cString := StrTran(cString,"AÂ¡","a")
cString := StrTran(cString,"AÂ£","a")
cString := StrTran(cString,"AÂ¢","a")
cString := StrTran(cString,"AÂ©","o")
cString := StrTran(cString,"A-","i")
cString := StrTran(cString,"AƒA¢","a")
cString := StrTran(cString,"AƒAa","e")
cString := StrTran(cString,"AƒAo","u")
cString := StrTran(cString,"AƒA","a")
cString := StrTran(cString,"ƒa€¡","Ç")
cString := StrTran(cString,"AƒÆ ","A")
cString := StrTran(cString,"  "," ")
cString := Replace(cString,"'"," ")
cString := StrTran(cString,"Aƒa€¡AƒÆ ","ÇÃ")
cString := StrTran(cString,"ƒa€¡AƒÆ ","ÇÃ")
If lMoeda
    cString := StrTran(cString,"A¡","a")
    cString := StrTran(cString,"Ao","u")
    cString := StrTran(cString,"A3","o")
    cString := StrTran(cString,"A3","o")
    cString := StrTran(cString,"A£","a")
    cString := StrTran(cString,"Aa","e")
    cString := StrTran(cString,"A©","e")
    cString := StrTran(cString,"AS","c")
    cString := StrTran(cString,"A¢","a")
EndIf
cString := StrTran(cString,"ACAƒÆ ","CA")
cString := StrTran(cString,"ACAƒÆ","CA")
cString := StrTran(cString,"ACAƒa€¢","CO")
cString := StrTran(cString,"AƒÅ ","E")
cString := StrTran(cString,"Aƒ.","I")
cString := StrTran(cString,"Aƒ.","A")
cString := StrTran(cString,"AƒÆ ","A")
cString := StrTran(cString,"MIQUINAS ","MAQUINAS")
cString := StrTran(cString,"Aƒa€œ","U")
cString := StrTran(cString,"A‚Ao","o.")
cString := StrTran(cString,"Aƒa€œ","O")
cString := StrTran(cString,"Aƒa€o","E")
cString := StrTran(cString,"Aƒa€š","A")
cString := StrTran(cString,"AƒEœ","Ø")
cString := StrTran(cString,"MUDULO","MODULO")
cString := StrTran(cString,"MUD.","MOD.")
cString := StrTran(cString,"MUD ","MOD ")
cString := StrTran(cString,"BOTAƒa€¢ES","BOTOES")
cString := StrTran(cString,"CUDIGO","CODIGO")
//cString := StrTran(cString,'""','"')
cString := StrTran(cString,"TRIFISICA","TRIFÁSICA")
cString := StrTran(cString,"A¢a‚¬a€œ","-")
cString := StrTran(cString,"AA¢a‚¬Å¡A2","2")
cString := StrTran(cString,"MMA‚A2","MM2")
cString := StrTran(cString," iB "," A-B ")
cString := StrTran(cString,"1.25A-2A","1,25~2A")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"0i0","0A-0"),"0i1","0A-1"),"0i2","0A-2"),"0i3","0A-3"),"0i4","0A-4"),"0i5","0A-5"),"0i6","0A-6"),"0i7","0A-7"),"0i8","0A-8"),"0i9","0A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"1i0","1A-0"),"1i1","1A-1"),"1i2","1A-2"),"1i3","1A-3"),"1i4","1A-4"),"1i5","1A-5"),"1i6","1A-6"),"1i7","1A-7"),"1i8","1A-8"),"1i9","1A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"2i0","2A-0"),"2i1","2A-1"),"2i2","2A-2"),"2i3","2A-3"),"2i4","2A-4"),"2i5","2A-5"),"2i6","2A-6"),"2i7","2A-7"),"2i8","2A-8"),"2i9","2A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"3i0","3A-0"),"3i1","3A-1"),"3i2","3A-2"),"3i3","3A-3"),"3i4","3A-4"),"3i5","3A-5"),"3i6","3A-6"),"3i7","3A-7"),"3i8","3A-8"),"3i9","3A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"4i0","4A-0"),"4i1","4A-1"),"4i2","4A-2"),"4i3","4A-3"),"4i4","4A-4"),"4i5","4A-5"),"4i6","4A-6"),"4i7","4A-7"),"4i8","4A-8"),"4i9","4A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"5i0","5A-0"),"5i1","5A-1"),"5i2","5A-2"),"5i3","5A-3"),"5i4","5A-4"),"5i5","5A-5"),"5i6","5A-6"),"5i7","5A-7"),"5i8","5A-8"),"5i9","5A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"6i0","6A-0"),"6i1","6A-1"),"6i2","6A-2"),"6i3","6A-3"),"6i4","6A-4"),"6i5","6A-5"),"6i6","6A-6"),"6i7","6A-7"),"6i8","6A-8"),"6i9","6A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"7i0","7A-0"),"7i1","7A-1"),"7i2","7A-2"),"7i3","7A-3"),"7i4","7A-4"),"7i5","7A-5"),"7i6","7A-6"),"7i7","7A-7"),"7i8","7A-8"),"7i9","7A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"8i0","8A-0"),"8i1","8A-1"),"8i2","8A-2"),"8i3","8A-3"),"8i4","8A-4"),"8i5","8A-5"),"8i6","8A-6"),"8i7","8A-7"),"8i8","8A-8"),"8i9","8A-9")
cString := StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cString,"9i0","9A-0"),"9i1","9A-1"),"9i2","9A-2"),"9i3","9A-3"),"9i4","9A-4"),"9i5","9A-5"),"9i6","9A-6"),"9i7","9A-7"),"9i8","9A-8"),"9i9","9A-9")
cString := StrTran(cString,"LIGiDESLIGi8","LIGA-DESLIGA-8")
cString := StrTran(cString,"AUTOM-20iFIX","AUTOM-20A-FIX")
cString := StrTran(cString,"PLISTIC","PLASTIC")
cString := StrTran(cString,"METILIC","METALIC")
cString := StrTran(cString,"METAA‚.LIC","METALIC")
cString := StrTran(cString," IGUA "," AGUA ")
cString := StrTran(cString,"OPERAÇAƒa€¢ES","OPERACOES")
cString := StrTran(cString,"Aƒa€¢","O")
cString := StrTran(cString,",",".")

//cString := StrTran(cString,"CAO","ÇAO")
//cString := StrTran(cString,"COES","ÇOES")
//cString := StrTran(cString,"cao","çao")
//cString := StrTran(cString,"coes","ções")

//cString := StrTran(cString,"AACAO","AÇAO")
//cString := StrTran(cString,"AACOES","AÇOES")

cString := StrTran(cString,"AÇ","Ç")

Return cString

Static Function SpecialChar( cString )

Local nX     := 0
Local aChar  := {}

Default cString := ""

If !Empty( cString )
    aAdd( aChar, 129)
    aAdd( aChar, 141)
    aAdd( aChar, 143)
    aAdd( aChar, 144)
    aAdd( aChar, 157)
    For nX := 1 To len(aChar)
        cString := StrTran( cString, Chr( aChar[nX] ), "." )
    Next
EndIf

Return cString

