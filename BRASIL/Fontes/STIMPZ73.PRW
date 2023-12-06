#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STIMPZ73
@name STIMPZ73
@type User Function
@desc importa contratos z73 e z74
@author Renato Nogueira
@since 06/04/2023
/*/

User Function STIMPZ73()

	Local cArq    := "C:\arquivos_protheus\sb1.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\"
	Local n		  := 0
	Local i		  := 0
	Local oDlg
	Local _cAlias1 	:= GetNextAlias()
	Local _cQuery1 	:= ""
    Local nP       :=0
	Local lErro    :=.F.
	Local nPreco   :=0
	Local nPerc    :=0
	Local cErro    :=""
	Local cEntidade:=''
	Local cProduto :=""
	Local cGrupo   :=""
	Local cFamilia :=""
	Local cCliente :=""
	Local cLoja    :=""
	local nDescMax :=0
	Private nx     :=0
	Private ny     :=0
    Private q      :=""
    Private z      :=""
	Private lErro  :=.F.
	Private aErro  := {}



	//RpcSetType( 3 )
	//RpcSetEnv("11","01",,,"FAT")

	nDescMax :=SuperGetMv("ES_DESCMAX",.F.,80)

    DBSELECTAREA('SB1') 
	SB1->(DBSETORDER(1))
	DBSELECTAREA('SBM') 
	SBM->(DBSETORDER(1))
	DBSELECTAREA('Z92') 
	Z92->(DBSETORDER(1))
	DBSELECTAREA('SA1') 
    SA1->(DBSETORDER(1))

	_cLog:= "RELATÓRIO DE PRODUTOS NÃO ENCONTRADOS "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)
    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)

    z := fcreate(alltrim(_cArquivo))

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	While !( oFT:ft_fEof() )
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
            For nx:=1 to len(aCampos)
                q+=ALLTRIM(aCampos[nx])+'";'
            next 
            q+='Log Erro'+'";'
            q+=chr(13)+chr(10)
            fwrite(z,q,len(q))
		Else
			cErro:=""
			AADD(aDados,Separa(cLinha,";",.T.))
			nx:=len(aDados)

            //Valida cliente. 
		    cCliente:= PADL(AllTrim(aDados[nx,1]),6,"0")
		    cLoja   := PADL(AllTrim(aDados[nx,2]),2,"0")		
			IF !SA1->(DBSEEK(XFILIAL('SA1')+cCliente+cLoja))	
			   cErro+=' Cliente - loja não localizados : '
		    ENDIF   
 			
			// Valida digitaçao de preço e percentual na linha deve ser um ou outro. 
			nPreco:=Val(StrTran(StrTran(aDados[nx,8],".",""),",","."))
			nPerc :=Val(StrTran(StrTran(aDados[nx,9],".",""),",","."))
			if nPreco<>0 .and. nPerc<>0 
               cErro:=' Informar % ou Preço não os 2: Preço: '+alltrim(str(nPreco,17,2))+' %  '+alltrim(str(nPerc,17,2))
               lErro:=.T.        
			endif	

            //Valida as entidades Produto ou Grupo ou Familia. 
			cEntidade:=""
			cEntidade+=iif(!empty(aDados[nx,5]),'P','')
			cEntidade+=iif(!empty(aDados[nx,6]),'G','')
			cEntidade+=iif(!empty(aDados[nx,7]),'F','')
			if len(cEntidade)<>1
               cErro+=' / Informar 1 entidade:  Produto, Grupo ou Familia '
			   lErro:=.T.        
			else 
               aDados[nx,5]:=UPPER(aDados[nx,5])
			   aDados[nx,6]:=UPPER(aDados[nx,6])
			   aDados[nx,7]:=UPPER(aDados[nx,7])
			   
			   IF cEntidade=='P' // Valida produto 
				  IF ! SB1->(DBSEEK(XFILIAL('SB1')+alltrim(aDados[nx,5])))
				     cErro+= ' / Produto não localizado: '+alltrim(aDados[nx,5])
					 lErro:=.T.        
                  ENDIF
			   ELSEIF cEntidade=='G' // Valida grupo 
				  IF !Empty(AllTrim(aDados[nx,6]))
				     cGrupo:=PADL(AllTrim(aDados[nx,6]),3,"0")
				  ELSE
                     cGrupo:=""
				  ENDIF	 
				  IF ! SBM->(DBSEEK(XFILIAL('SBM')+cGrupo))
				     cErro+= ' / Grupo não localizado: '+cGrupo
					 lErro:=.T.        
                  ENDIF
			   ELSEIF cEntidade=='F' // Valida familia 
				  IF ! Z92->(DBSEEK(XFILIAL('Z92')+alltrim(aDados[nx,7])))
				     cErro+= ' / Familia não localizada: '+alltrim(aDados[nx,7])
					 lErro:=.T.        
                  ENDIF
               ENDIF
			endif   


			// Valida desconto maximo. 
			nPerc :=Val(StrTran(StrTran(aDados[nx,9],".",""),",","."))
			if nPerc > nDescMax
               cErro:=' Desconto: '+alltrim(STR(nPerc,10,6))+' excedeu o máximo permitido '+alltrim(str(nDescMax))+' Parâmetro ES_DESCMAX' 
               lErro:=.T.        
			endif	

			
			if !Empty(cErro)
               GravaLog(aDados[nx],cErro)
			else 
               GravaLog(aDados[nx],'ok')
			endif   

		EndIf

		oFT:ft_fSkip()
	End While

    if lErro
	   //FWAlertSuccess('Houve erro na importação - nenhum registro foi gravado ')
	   Alert(' Houve erro na importação - nenhum registro foi gravado ')
       fclose(z)
       incproc("Abrindo os dados em Excel.....")
       If !ApOleClient( 'MsExcel' )
	      MsgAlert( 'MsExcel não instalado')
	      Return
       else
	      oExcel1 := MsExcel():New()
	      oExcel1:WorkBooks:Open(alltrim(_cArquivo))
	      oExcel1:SetVisible(.T.)
       EndIf
	   Return()
	endif   

	oFT:ft_fUse()
	DbSelectArea("Z73")
	Z73->(DbSetOrder(1))
	DbSelectArea("Z74")
	Z74->(DbSetOrder(1))

	_cCodCont := ""
	_cCliente := ""
    //Ordena o array por cliente 
    aSort(aDados, , , {|x,y| x[1]+x[2] < y[1]+y[2] } ) 

	//return()

	For i:=1 to Len(aDados)  //ler linhas da array

		aDados[i,1] := PADL(AllTrim(aDados[i,1]),6,"0")
		aDados[i,2] := PADL(AllTrim(aDados[i,2]),2,"0")

		If !(_cCliente==aDados[i,1]+aDados[i,2]) //Se for diferente zera
			_cCodCont := ""
		EndIf

		If Empty(_cCodCont)

			_cCliente := aDados[i,1]+aDados[i,2]

			_cCodCont := GetSxeNum("Z73","Z73_CODIGO")
			Z73->(ConfirmSX8())

			//Encerra contrato atual inicio
			_cQuery1 := " SELECT Z73.R_E_C_N_O_ Z73REC
			_cQuery1 += " FROM Z73110 Z73
			_cQuery1 += " WHERE Z73.D_E_L_E_T_=' '
			_cQuery1 += " AND Z73_CODCLI='"+aDados[i,1]+"' AND Z73_LOJCLI='"+aDados[i,2]+"'
			_cQuery1 += " AND '"+DTOS(Date())+"' BETWEEN Z73_DTDE AND Z73_DTATE

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())

				While (_cAlias1)->(!Eof())

					Z73->(DbGoTo((_cAlias1)->Z73REC))

					If Z73->(!Eof())
						Z73->(RecLock("Z73",.F.))
						Z73->Z73_DTATE := Date()-1
						Z73->(MsUnLock())
					EndIf

					(_cAlias1)->(DbSkip())
				EndDo
			EndIf

			(_cAlias1)->(DbCloseArea())

			//Encerra contrato atual fim

			Z73->(RecLock("Z73",.T.))
			Z73->Z73_CODIGO := _cCodCont
			Z73->Z73_CODCLI := aDados[i,1]
			Z73->Z73_LOJCLI := aDados[i,2]
			Z73->Z73_NOMCLI := Posicione("SA1",1,xFilial("SA1")+_cCliente,"A1_NOME")
			Z73->Z73_DTDE	:= Date() //Próximo dia
			Z73->Z73_DTATE	:= CTOD(aDados[i,4])
            
			Z73->(MsUnLock())

		EndIf

		Z74->(RecLock("Z74",.T.))
		Z74->Z74_CODIGO := _cCodCont
		Z74->Z74_PROD   := aDados[i,5]
		IF !EMPTY(AllTrim(aDados[i,6]))
		   cGrupo:=PADL(AllTrim(aDados[i,6]),3,"0")
		   Z74->Z74_GRUPO  := cGrupo
        ENDIF		   
        Z74->Z74_FAMILI := aDados[i,7]
		Z74->Z74_PRECO 	:= Val(StrTran(StrTran(aDados[i,8],".",""),",","."))
		Z74->Z74_DESCON	:= Val(StrTran(StrTran(aDados[i,9],".",""),",","."))

		Z74->(MsUnLock())

	Next i

	FT_FUSE()

    FWAlertSuccess('Finalizado com Sucesso!! ')


Return



Static Function GravaLog(aDados1,cErro1)

Local ny:=0

for ny:=1 to len(aDados1)
    if ny==1
       q := CHR(160)+ PADL(AllTrim(aDados1[ny]),6,"0")+';';fwrite(z,q,len(q))
	elseif ny==2
       q := CHR(160)+ PADL(AllTrim(aDados1[ny]),2,"0")+';';fwrite(z,q,len(q))
	else 
	   q := CHR(160)+aDados1[ny]+';';fwrite(z,q,len(q))
	endif	  
Next
q := CHR(160)+cErro1+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''


Return()
