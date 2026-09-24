//* ------------------------------------------------------------------
//* IEFBR14 = utilitario nulo. Nao processa registros; e usado com DD
//* para criar, catalogar ou excluir datasets (DS).
//* ------------------------------------------------------------------
//* IEFBR14 = Criar um DS.
//XXXXXX   JOB (JEFF),'CREATE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(1,1)),UNIT=SYSDA,
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)

//* IEFBR14 = Excluir um DS.
//XXXXXX   JOB (JEFF),'DELETE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(OLD,DELETE)


//* ------------------------------------------------------------------
//* IEBGENER = copia sequencialmente registros de um dataset para outro.
//* Tambem pode gerar um dataset a partir de SYSIN e fazer pequenas
//* alteracoes com parametros de controle. Para copias de grande volume,
//* ICEGENER (quando disponivel) normalmente oferece melhor desempenho.
//* ------------------------------------------------------------------
//* IEBGENER = Copiar um DS.
//XXXXXX   JOB (JEFF),'COPIA DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)


//* ------------------------------------------------------------------
//* ICEGENER = copia datasets usando o componente de copia do DFSORT.
//* E uma alternativa de alto desempenho ao IEBGENER. A sintaxe abaixo
//* usa SYSIN vazio, pois a operacao e uma copia simples.
//* ------------------------------------------------------------------
//* ICEGENER = Copiar um DS.
//XXXXXX   JOB (JEFF),'ICEGENER COPY',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=ICEGENER
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)


//* ------------------------------------------------------------------
//* SORT/ICEMAN = classifica, junta, copia e filtra registros.
//* SYSIN contem os campos (posicao, tamanho e formato) usados na
//* classificacao. O nome do programa pode ser SORT ou ICEMAN conforme
//* a instalacao; DFSORT tambem aceita PGM=SORT.
//* ------------------------------------------------------------------
//* SORT = Ordenar um DS por um campo crescente.
//XXXXXX   JOB (JEFF),'SORT DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SORTOUT  DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)
//SYSIN    DD *
  SORT FIELDS=(1,10,CH,A)
/*

//* Exemplo de filtro: manter registros cujo campo 1-3 seja igual a ABC.
//* INCLUDE COND=(1,3,CH,EQ,C'ABC')
//* OMIT    COND=(1,3,CH,EQ,C'ABC')


//* ------------------------------------------------------------------
//* ICETOOL = interface do DFSORT para relatorios e operacoes de analise,
//* como contagem de registros, selecao e copia. COUNT gera um relatorio
//* com a quantidade de registros do dataset de entrada.
//* ------------------------------------------------------------------
//* ICETOOL = Contar registros de um DS.
//XXXXXX   JOB (JEFF),'ICETOOL COUNT',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=ICETOOL
//TOOLMSG  DD SYSOUT=*
//DFSMSG   DD SYSOUT=*
//IN       DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//TOOLIN   DD *
  COUNT FROM(IN) WRITE(OUTCNT)
//OUTCNT   DD SYSOUT=*
/*


//* ------------------------------------------------------------------
//* IEBCOPY = copia, comprime e mantem bibliotecas particionadas (PDS e
//* PDSE). Pode copiar todos os membros ou selecionar membros especificos.
//* ------------------------------------------------------------------
//* IEBCOPY = Copiar uma biblioteca PDS/PDSE.
//XXXXXX   JOB (JEFF),'COPY PDS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(5,1,20)),
//            DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=0)
//SYSIN    DD *
  COPY INDD=SYSUT1,OUTDD=SYSUT2
/*

//* Selecionar membros: substitua MEM1 e MEM2 pelos membros desejados.
//* SELECT MEMBER=(MEM1,MEM2)


//* ------------------------------------------------------------------
//* IEBCOMPR = compara dois datasets sequenciais ou duas bibliotecas
//* particionadas e informa diferencas no relatorio SYSPRINT.
//* ------------------------------------------------------------------
//* IEBCOMPR = Comparar dois DS.
//XXXXXX   JOB (JEFF),'COMPARE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOMPR
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  COMPARE TYPORG=PS
/*


//* ------------------------------------------------------------------
//* IEBUPDTE = cria ou atualiza membros de uma biblioteca PDS/PDSE a
//* partir de entrada sequencial. E util para aplicar pequenas alteracoes
//* em membros, embora ISPF ou ferramentas de controle de versao sejam
//* preferiveis no desenvolvimento diario.
//* ------------------------------------------------------------------
//* IEBUPDTE = Criar/atualizar membro de uma biblioteca.
//XXXXXX   JOB (JEFF),'UPDATE MEMBER',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBUPDTE,PARM=NEW
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
./ ADD NAME=MEMBRO1
CONTEUDO DO MEMBRO AQUI
/*


//* ------------------------------------------------------------------
//* IDCAMS = utilitario de catalogo e VSAM. Permite definir, listar,
//* excluir e alterar objetos catalogados, incluindo clusters VSAM e GDG.
//* ------------------------------------------------------------------
//* IDCAMS = Excluir um GDG Base.
//XXXXXX   JOB (JEFF),'DELETAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE XX.XXXXXX.XXXXXX GDG FORCE
/*

//* IDCAMS = Criar um GDG Base.
//XXXXXX   JOB (JEFF),'CRIAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE GDG (NAME(XX.XXXXXX.XXXXXX)
              LIMIT(10)
              NOEMPTY
              SCRATCH)
/*

//* IDCAMS = Listar atributos de um dataset ou cluster.
//XXXXXX   JOB (JEFF),'LISTCAT',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  LISTCAT ENT(XX.XXXXXX.XXXXXX) ALL
/*

//* IDCAMS = Copiar um VSAM ou PS com REPRO.
//XXXXXX   JOB (JEFF),'REPRO',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//IN       DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//OUT      DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  REPRO INFILE(IN) OUTFILE(OUT)
/*


//* ------------------------------------------------------------------
//* DFSERA10 = utilitario historico do IMS para leitura/copia de dados.
//* Neste exemplo, a copia para ao atingir a quantidade indicada em
//* STOPAFT. A disponibilidade e o comportamento podem variar por
//* instalacao; para copias simples, prefira IEBGENER ou ICEGENER.
//* ------------------------------------------------------------------
//* DFSERA10 = Copiar um DS ate determinada linha.
//XXXXXX   JOB (JEFF),'COPIA',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=DFSERA10,TIME=100
//SYSPRINT DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)
//SYSIN    DD *
  CONTROL CNTL STOPAFT=XXXX
/*


//* ------------------------------------------------------------------
//* ADRDSSU = DFSMShsm Data Set Services. Faz dump, restore e copia de
//* datasets/volumes, preservando atributos conforme as opcoes usadas.
//* Requer autorizacao e deve ser usado conforme as politicas do storage.
//* ------------------------------------------------------------------
//* ADRDSSU = Copiar um DS para outro nome.
//XXXXXX   JOB (JEFF),'DSS COPY',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=ADRDSSU
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  COPY DATASET(INCLUDE(XX.XXXXXX.ORIGEM)) -
       OUTDATASET(XX.XXXXXX.DESTINO) -
       TOL(ENQF)
/*


//* ------------------------------------------------------------------
//* IKJEFT01 = executa comandos TSO em batch. E frequentemente usado
//* para rodar programas/utilitarios TSO, SQL via DSN (DB2), ou comandos
//* TSO. O conteudo de SYSTSIN depende do produto chamado.
//* ------------------------------------------------------------------
//* IKJEFT01 = Executar comando TSO em batch.
//XXXXXX   JOB (JEFF),'TSO BATCH',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IKJEFT01
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  LISTCAT ENT(XX.XXXXXX.XXXXXX) ALL
/*


//* Observacoes:
//* - Ajuste nomes, volumes, unidades, espaco, DCB e classes ao ambiente.
//* - DISP=(NEW,CATLG,DELETE) exclui o dataset se o step falhar antes da
//*   catalogacao; valide a politica desejada antes de executar em producao.
//* - SYSUT1/SYSUT2 sao DD names convencionais; SYSIN contem o controle
//*   do utilitario e SYSPRINT/SYSOUT normalmente recebem as mensagens.
//* - ICEGENER, SORT/ICEMAN e ICETOOL dependem da instalacao do DFSORT.
//* - Teste sempre em datasets temporarios e confira o retorno do job.
