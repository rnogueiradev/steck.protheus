#INCLUDE "Rwmake.ch"
#INCLUDE "Topconn.ch"

/*====================================================================================\
|Programa  | COLCTB24        | Autor | CRISTIANO PEREIRA         | Data | 09/08/2018  |
|=====================================================================================|
|Descrição | Generación de movimientos de artículos y cabecera de saídas.            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COLCTB24()

    
    Local aParamBox 	:= {}
    Local aRet 			:= {}

	AADD(aParamBox,{1,"Data de",Ctod(Space(8)),"99/99/9999","","","",50,.F.})
	AADD(aParamBox,{1,"Data ate",Ctod(Space(8)),"99/99/9999","","","",50,.F.})

    ParamBox(aParamBox,"Generación de movimientos de artículos y cabecera de salidas",@aRet,,,.T.,,500)

    u_COLT24A()

return 

/*====================================================================================\
|Programa  | COLT24A      | Autor | CRISTIANO PEREIRA         | Data | 09/08/2018  |
|=====================================================================================|
|Descrição | Generación de movimientos de artículos y cabecera de entrada.            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
USer Function COLT24A()


Local cQuery := "" 

cQuery := " SELECT "
cQuery += "    SF2.*,SD2.* "
cQuery += " FROM "
cQuery += "    "+RetSQLName('SF2')+" SF2, "+RetSqlName("SD2")+" SD2 "
cQuery += " WHERE "
cQuery += "    SF2.F2_FILIAL = '"+FWxFilial('SF2')+"' "
cQuery += "    AND SF2.D_E_L_E_T_ <> '*'          AND "
cQuery += "    SF2.F2_FILIAL = SD2.D2_FILIAL      AND "
cQuery += "    SF2.F2_DOC    = SD2.D2_DOC         AND "
cQuery += "    SD2.D2_EMISSAO >='"+dtos(mv_par01)+"' and "
cQuery += "    SD2.D2_EMISSAO <='"+dtos(mv_par02)+"' and "
cQuery += "    SF2.F2_SERIE  = SD2.D2_SERIE       AND "
cQuery += "    SF2.F2_CLIENTE = SD2.D2_CLIENTE    AND "
cQuery += "    SF2.F2_LOJA    = SD2.D2_LOJA       AND "
cQuery += "    SD2.D_E_L_E_T_ <> '*'                  "


//Chama a função e um título
u_zQry2Excel(cQuery, "facturas salidas")


return


//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
  
/*/{Protheus.doc} zQry2Excel
Função que recebe uma consulta sql e gera um arquivo do excel, dinamicamente
@author Atilio
@since 16/05/2017
@version 1.0
    @param cQryAux, characters, Query que será executada
    @param cTitAux, characters, Título do Excel
    @example
    u_zQry2Excel("SELECT B1_COD, B1_DESC FROM SB1010")
    @obs Cuidado com colunas com mais de 200 caracteres, pode ser que o Excel dê erro ao abrir o XML
/*/
  
User Function zQry2Excel(cQryAux, cTitAux)
    Default cQryAux   := ""
    Default cTitAux   := "Título"
     
    Processa({|| fProcessa(cQryAux, cTitAux) }, "registro de procesamiento...")
Return
 
/*---------------------------------------------------------------------*
 | Func:  fProcessa                                                    |
 | Desc:  Função de processamento                                      |
 *---------------------------------------------------------------------*/
 
Static Function fProcessa(cQryAux, cTitAux)
    Local aArea       := GetArea()
    Local aAreaX3     := ""
    Local nAux        := 0
    Local oFWMsExcel
    Local oExcel
    Local cDiretorio  := GetTempPath()
    Local cArquivo    := 'zQry2Excel.xml'
    Local cArqFull    := cDiretorio + cArquivo
    Local cWorkSheet  := "pestaña principal"
    Local cTable      := ""
    Local aColunas    := {}
    Local aEstrut     := {}
    Local aLinhaAux   := {}
    Local cTitulo     := ""
    Local nTotal      := 0
    Local nAtual      := 0
    Default cQryAux   := ""
    Default cTitAux   := "Título"
     
    cTable := cTitAux
     
    //Se tiver a consulta
    If !Empty(cQryAux)
        TCQuery cQryAux New Alias "QRY_AUX"
         


        OpenSxs(,,,,cEmpAnt,"CT0SX3","SX3",,.F.)
        
        aAreaX3     :=   CT0SX3->(GetArea())
        
        CT0SX3->(DbSetOrder(2)) //X3_CAMPO
        
         
        //Percorrendo a estrutura
        aEstrut := QRY_AUX->(DbStruct())
        ProcRegua(Len(aEstrut))
        For nAux := 1 To Len(aEstrut)
            IncProc("Incluyendo columna "+cValToChar(nAux)+" hasta "+cValToChar(Len(aEstrut))+"...")
            cTitulo := ""
             
            //Se conseguir posicionar no campo
            If CT0SX3->(DbSeek(aEstrut[nAux][1]))
                cTitulo := Alltrim(CT0SX3->X3_TITULO)
                 
                //Se for tipo data, transforma a coluna
                If CT0SX3->X3_TIPO == 'D'
                    TCSetField("QRY_AUX", aEstrut[nAux][1], "D")
                EndIf
            Else
                cTitulo := Capital(Alltrim(aEstrut[nAux][1]))
            EndIf
             
            //Adicionando nas colunas
            aAdd(aColunas, cTitulo)
        Next
          
        //Criando o objeto que irá gerar o conteúdo do Excel
        oFWMsExcel := FWMSExcel():New()
        oFWMsExcel:AddworkSheet(cWorkSheet)
            oFWMsExcel:AddTable(cWorkSheet, cTable)
             
            //Adicionando as Colunas
            For nAux := 1 To Len(aColunas)
                oFWMsExcel:AddColumn(cWorkSheet, cTable, aColunas[nAux], 1, 1)
            Next
             
            //Definindo o total da barra
            DbSelectArea("QRY_AUX")
            QRY_AUX->(DbGoTop())
            Count To nTotal
            ProcRegua(nTotal)
            nAtual := 0
             
            //Percorrendo os produtos
            QRY_AUX->(DbGoTop())
            While !QRY_AUX->(EoF())
                nAtual++
                IncProc("registro de procesamiento "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
             
                //Criando a linha
                aLinhaAux := Array(Len(aColunas))
                For nAux := 1 To Len(aEstrut)
                    aLinhaAux[nAux] := &("QRY_AUX->"+aEstrut[nAux][1])
                Next
                  
                //Adiciona a linha no Excel
                oFWMsExcel:AddRow(cWorkSheet, cTable, aLinhaAux)
                  
                QRY_AUX->(DbSkip())
            EndDo
              
        //Ativando o arquivo e gerando o xml
        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cArqFull)
         
        //Se tiver o excel instalado
        If ApOleClient("msexcel")
            oExcel := MsExcel():New()
            oExcel:WorkBooks:Open(cArqFull)
            oExcel:SetVisible(.T.)
            oExcel:Destroy()
         
        Else
            //Se existir a pasta do LibreOffice 5
            If ExistDir("C:\Program Files (x86)\LibreOffice 5")
                WaitRun('C:\Program Files (x86)\LibreOffice 5\program\scalc.exe "'+cDiretorio+cArquivo+'"', 1)
             
            //Senão, abre o XML pelo programa padrão
            Else
                ShellExecute("open", cArquivo, "", cDiretorio, 1)
            EndIf
        EndIf
          
        QRY_AUX->(DbCloseArea())
    EndIf
     
    RestArea(aAreaX3)
    RestArea(aArea)
Return
