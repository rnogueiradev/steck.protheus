#Include 'Protheus.ch'

//** Everson Santana
//** 05/10/2018
//** Executa rotinas Protheus

User Function EXECADVPL(CMD)
local cCmd:=SPACE(256)

oDlg1      := MSDialog():New( 362,542,433,955,"Executar",,,.F.,,,,,,.T.,,,.T. )
oGet1      := TGet():New( 012,004,{|u| If(PCount()>0,cCmd:=u,cCmd)},oDlg1,144,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCmd",,)
oBtn1      := TButton():New( 012,160,"Executar",oDlg1,{|| RUN(cCmd)},036,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return(NIL)



Static Function Run(cCmd) //Executa a Rotina
 
 IF at(cCmd,"(")==0
 	cCmd:=ALLTRIM(cCmd)+"("
 EndIF
 
 IF at(cCmd,")")==0
 	cCmd:=ALLTRIM(cCmd)+")"
 EndIF
 
&(cCmd) 

 Return 