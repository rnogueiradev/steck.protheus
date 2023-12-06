#Include "Protheus.ch"
#Include "Rwmake.ch"


/*/{Protheus.doc} User Function MA261D3
    (long_description)
    Ponto de Entrada para gravação do Campo customizado
    @author user
    Valdemir Rabelo - SigaMat
    @since 22/10/2019
/*/
User Function MA261D3()

Local _aArea  	:= GetArea()
Local _nPosUso	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_XUSUSOL"})         // Valdemir Rabelo 22/10/2019

if _nPosUso > 0
    RecLock("SD3",.F.)
    SD3->D3_XUSUSOL     := aCols[n,_nPosUso]
    MsUnlock()
    
Endif

Restarea(_aArea)

Return