#INCLUDE "PROTHEUS.CH" 
#Include 'TOTVS.CH'
#Include 'TopConn.ch'

/*/{Protheus.doc} User Function GFEA0513
   PE no processamento do arquivo da trasnsportadora. 
    @type  Function
    @author Antonio Moura
    @since 30/08/2023
    /*/

#DEFINE SM0_CODFIL 2

User Function GFEA0513()


DBSELECTAREA('SD2')
DBSETORDER(3)
IF SD2->(DBSEEK(XFILIAL('SD2')+ALLTRIM(GWU->GWU_NRDC)+GWU->GWU_SERDC))
   SC5->(DBSETORDER(1))
   IF SC5->(DBSEEK(XFILIAL('SC5')+SD2->D2_PEDIDO)) .AND. SC5->C5_XTIPO=='2' // Tipo entrega 
      While ! SD2->(EOF()) .AND. ALLTRIM(SD2->D2_DOC) == ALLTRIM(GWU->GWU_NRDC);
         .AND. ALLTRIM(SD2->D2_SERIE) == ALLTRIM(GWU->GWU_SERDC)
         SC6->(DBSETORDER(1)) 
         IF SC6->(DBSEEK(SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
            IF SC6->C6_QTDVEN <= SC6->C6_QTDENT // Entrega total do Item 
               SC6->(RECLOCK('SC6',.F.))
               SC6->C6_ZDTENRE:=GWU->GWU_DTENT
               SC6->(MSUNLOCK())
            ENDIF    
         ENDIF   
         SD2->(DBSKIP())
      ENDDO  
   ENDIF
ENDIF   


RETURN()
