#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STFAT703
@name STFAT703
@type User Function
@desc importa CSV para eliminação de residuo. 
@author Antonio Cordeiro Moura
@since 21/08/2023
/*/

User Function STFAT703()

	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aProc   := {}
	Local lErro    :=.F.
	Local cErro    :=""
	Local nx     :=0
	Local lContinua:=.T.
	Local _cUserEx  	:= GetMv('ST_ELIUSEX',,'000000/000301/000077/000651')+'000000/000645'
	Local _cUserx   	:= GetMv('ST_ELIUSER',,'000000')+'000000/000645'
    Private q      :=""
    Private z      :=""
	Private aErro  := {}
    Private cArquivo:=""
	Private nP       :=0

	If  !(__cuserid $ _cUserEx) .OR. !(__cuserid $  _cUserx)
		MsgInfo('Usuario sem Acesso!!!!!!')
		RETURN()
	Endif

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)


	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return()
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)

    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)
    _cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)

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

	        aDados[nx,1] := PADL(AllTrim(aDados[nx,1]),TAMSX3("C7_FILIAL")[1],"0")
		    aDados[nx,2] := PADL(AllTrim(aDados[nx,2]),TAMSX3("C7_NUM")[1],"0")
			
            //Valida se pedido existe. 
			SC5->(DBSETORDER(1))
			IF !SC5->(DBSEEK(aDados[nx,1]+aDados[nx,2]))
			   cErro+='Pedido não localizado'
			ELSE 
			   IF ! SC5->C5_NOTA == 'XXXXXXXXX'
			      aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3]})
			   ELSE 
                  cErro+='Pedido Residuo ja eliminado'
			   ENDIF	  
			ENDIF   
			
			if !Empty(cErro)
               GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],cErro)
			   lErro:=.T.
			else 
               GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],' - OK - ')
			endif   

		EndIf

		oFT:ft_fSkip()
	End While

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

    oFT:ft_fUse()

    if lErro
	   If Msgyesno('Houve erro na análise do CSV  - Continua ?...')
          lContinua:=.T.
	   ELSE 
	      lContinua:=.F.
	   ENDIF 
    ELSE 
	   If Msgyesno('CSV OK - Continua ?...')
          lContinua:=.T.
       ELSE 
	      lContinua:=.F.
	   ENDIF 
    ENDIF	   

 	IF lContinua    
	   oFT:ft_fUse()
       aSort(aProc, , , {|x,y| x[1]+x[2] < y[1]+y[2] } ) 
	   IF LEN(aProc)>0
	      ElimResiduo(aProc)
	   ELSE 
          FWAlertSuccess('Sem dados para processar!! ')
	   ENDIF

	   //For i:=1 to Len(aDados)  //ler linhas da array
	   //Next i
	   FT_FUSE()
    ENDIF 

	FWAlertSuccess('Finalizado com Sucesso!! ')

Return()



Static Function ElimResiduo(aDados)

Processa({|| RunProc(aDados) },"","Eliminando Residuo")

Return()


Static Function RunProc(aDados1)

Local cFilAtu:=""
Local lRet   :=.F.
Local nx:=0
Local _cArqProc:=""


cFilAtu:=cFilAnt

_cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)

z := fcreate(alltrim(_cArqProc))

ProcRegua(len(aDados1))

//Grava cabeçalho
GravaProc('FILIAL','PEDIDO','MOTIVO','RESULTADO')

For nx:=1 to len(aDados1)

  IncProc('Processando Registros!!')
  
  cFilAnt:=aDados1[nx,1]
  DbSelectArea("SC5")
  SC5->(DbSetOrder(1))
  IF SC5->(dbseek(aDados1[nx,1]+aDados1[nx,2]))
	
	  IF SC5->C5_NOTA == 'XXXXXXXXX'
	     GravaProc(aDados1[nx,1],aDados1[nx,2],aDados1[nx,3],' Residuo Já eliminado ')
	  ELSE 
	     lContinua := ExecBlock("M410VRES",.F.,.F.)
	     If lContinua
		   Begin Transaction
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Eliminacao de residuo                                ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   dbSelectArea("SC6")
		   dbSetOrder(1)
		   MsSeek(xFilial("SC6")+SC5->C5_NUM)
	
		   While ( !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== SC5->C5_NUM )
				lValido  := .T.
				If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
					If FindFunction("EECZERASALDO")
						lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					Else
						lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					EndIf
				EndIf
				If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
					MaResDoFat(,.T.,.F.)
				EndIf
				dbSelectArea("SC6")
				dbSkip()
		   EndDo
		   SC6->(MaLiberOk({SC5->C5_NUM},.T.))
           IF SC5->C5_NOTA=='XXXXXXXXX'
			  SC5->(RecLock("SC5",.F.))
			  SC5->C5_XMOTRES	:= aDados1[nx,3]
			  SC5->(MsUnLock())              
			  GravaProc(aDados1[nx,1],aDados1[nx,2],aDados1[nx,3],' Residuo eliminado com sucesso ')
		   ELSE 
              GravaProc(aDados1[nx,1],aDados1[nx,2],aDados1[nx,3],' ERRO!!! - FALHA NA ELIMINAÇÃO ')			
		   ENDIF   
		   End Transaction
		ENDIF   
	 EndIf
   EndIf
Next 


fclose(z)
incproc("Abrindo os dados em Excel.....")

If !ApOleClient( 'MsExcel' )
   MsgAlert( 'MsExcel não instalado')
   Return
else
   oExcel1 := MsExcel():New()
   oExcel1:WorkBooks:Open(alltrim(_cArqProc))
   oExcel1:SetVisible(.T.)
EndIf

//Restaura filial 
cFilAnt:=cFilAtu


Return(lRet)



Static Function GravaLog(cFil,cPed,cMotivo,cErro1)

q := CHR(160)+cFil+';';fwrite(z,q,len(q))
q := CHR(160)+cPed+';';fwrite(z,q,len(q))
q := CHR(160)+cMotivo+';';fwrite(z,q,len(q))
q := CHR(160)+cErro1+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()


Static Function GravaProc(cFil,cPed,cMotivo,cObs)

q := CHR(160)+cFil+';';fwrite(z,q,len(q))
q := CHR(160)+cPed+';';fwrite(z,q,len(q))
q := CHR(160)+cMotivo+';';fwrite(z,q,len(q))
q := CHR(160)+cObs+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()
