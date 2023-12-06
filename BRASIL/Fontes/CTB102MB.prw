#Include "Protheus.ch" 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ÉÍÍÍ
ÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
±±±±ºPrograma  ³CTB102MB  ºAutor  ³Microsiga           º Data ³  15/12/09   º±±±±Ì
ÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±±º
Desc.     ³ Exemplo de ponto de entrada a ser utilizado para filtro na º±±±±º       
   ³ tela
 principal dos lanc cont automaticos (mbrowse)         º±±±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍ
 ÍÍÍÍÍÍÍÍÍÍÍ
 ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±±±ºUso       ³ AP                                                        
º±±±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßß*/


User Function CTB102MB()

Local cFiltro   := ""



If cusername$GetMV("ST_APCTBN1")

 If Pergunte("XCTB102",.T.,"Aprovação contábil")

     #IFDEF TOP	

      If MV_PAR03==1
       cFiltro := " CT2_FILIAL =='"+xFilial("CT2")+"' .AND. CT2_ROTINA=='CTBA102' .AND. CT2_TPSALD=='9' .And. CT2_DATA>='"+Dtos(mv_par01)+"' .And. CT2_DATA<='"+Dtos(mv_par02)+"'  "  
      ElseIf  MV_PAR03==2
       cFiltro := " CT2_FILIAL =='"+xFilial("CT2")+"' .AND. CT2_ROTINA=='CTBA102' .AND. CT2_TPSALD=='1' .And. CT2_DATA>='"+Dtos(mv_par01)+"' .And. CT2_DATA<='"+Dtos(mv_par02)+"'  "  
      Endif       
       //aqui usuario coloca a condicao desejada em sintaxe sql
     #ENDIF
 Endif

Endif

Return(cFiltro)
