//* ------------------------------------------------------------------
//* IEFBR14 = utilitario nulo. Nao processa registros; e usado com DD
//* para criar, catalogar ou excluir datasets (DS).
//* ------------------------------------------------------------------
//XXXXXX   JOB (JEFF),'CREATE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(1,1)),UNIT=SYSDA,
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)

//XXXXXX   JOB (JEFF),'DELETE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEFBR14
//DD1      DD DSN=XXXXXX.XXXXXX.XXXXXX,DISP=(OLD,DELETE)


//* ------------------------------------------------------------------
//* IEBGENER = copia sequencialmente registros de um dataset para outro.
//* Tambem pode gerar um dataset a partir de SYSIN, enviar para SYSOUT,
//* e concatenar varios datasets em um unico arquivo de saida.
//* Para copias de grande volume, ICEGENER (quando disponivel) normalmente
//* oferece melhor desempenho.
//* ------------------------------------------------------------------
//XXXXXX   JOB (JEFF),'COPIA DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)

//* IEBGENER = enviar o conteudo de um DS para a SYSOUT.
//XXXXXX   JOB (JEFF),'DS PARA SYSOUT',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD SYSOUT=*

//* IEBGENER = concatenar varios datasets em um unico arquivo de saida.
//XXXXXX   JOB (JEFF),'CONCAT DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//         DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//         DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0)


//* ------------------------------------------------------------------
//* IEBCOPY = copia e mantem bibliotecas particionadas PDS e PDSE.
//* Pode copiar todos os membros ou selecionar/excluir membros.
//* A compressao in-place e aplicavel a PDS; PDSE administra o espaco
//* automaticamente e nao precisa da mesma compressao.
//* ------------------------------------------------------------------
//* IEBCOPY = Copiar todos os membros de uma biblioteca.
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

//* IEBCOPY = Copiar somente membros selecionados.
//XXXXXX   JOB (JEFF),'COPY MEMBERS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  COPY INDD=SYSUT1,OUTDD=SYSUT2
  SELECT MEMBER=(MEMBRO1,MEMBRO2,MEMBRO3)
/*

//* IEBCOPY = Copiar todos, exceto membros selecionados.
//XXXXXX   JOB (JEFF),'EXCLUDE MEMBERS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  COPY INDD=SYSUT1,OUTDD=SYSUT2
  EXCLUDE MEMBER=(MEMBRO1,MEMBRO2)
/*

//* IEBCOPY = Comprimir uma biblioteca PDS no proprio dataset.
//XXXXXX   JOB (JEFF),'COMPRESS PDS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOPY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=OLD
//SYSIN    DD *
  COPY INDD=SYSUT1,OUTDD=SYSUT1
/*


//* ------------------------------------------------------------------
//* SORT/ICEMAN = classifica, junta, copia e filtra registros.
//* SYSIN contem os campos (posicao, tamanho e formato) usados na
//* classificacao. O nome do programa pode ser SORT ou ICEMAN conforme
//* a instalacao; DFSORT tambem aceita PGM=SORT.
//* ------------------------------------------------------------------
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
//* IEBCOMPR = compara dois datasets sequenciais ou duas bibliotecas
//* particionadas e informa diferencas no relatorio SYSPRINT.
//* ------------------------------------------------------------------
//XXXXXX   JOB (JEFF),'COMPARE DS',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IEBCOMPR
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSUT2   DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  COMPARE TYPORG=PS
/*


//* ------------------------------------------------------------------
//* IDCAMS = utilitario de catalogo e VSAM. Permite definir, listar,
//* excluir e alterar objetos catalogados, incluindo clusters VSAM e GDG.
//* ------------------------------------------------------------------
//XXXXXX   JOB (JEFF),'DELETAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE XX.XXXXXX.XXXXXX GDG FORCE
/*

//XXXXXX   JOB (JEFF),'CRIAR GDG',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE GDG (NAME(XX.XXXXXX.XXXXXX)
              LIMIT(10)
              NOEMPTY
              SCRATCH)
/*

//XXXXXX   JOB (JEFF),'LISTCAT',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  LISTCAT ENT(XX.XXXXXX.XXXXXX) ALL
/*

//XXXXXX   JOB (JEFF),'REPRO',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//IN       DD DSN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX,DISP=SHR
//OUT      DD DSN=XXXXXXXXXXXXXXXXXXXX,DISP=SHR
//SYSIN    DD *
  REPRO INFILE(IN) OUTFILE(OUT)
/*


//* ------------------------------------------------------------------
//* DFSERA10 = utilitario do IMS para leitura/copia de dados.
//* Neste exemplo, a copia para ao atingir a quantidade indicada em
//* STOPAFT; para copias simples, prefira IEBGENER ou ICEGENER.
//* ------------------------------------------------------------------
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
//* IKJEFT01 = executa comandos TSO em batch. E frequentemente usado
//* para rodar programas/utilitarios TSO, SQL via DSN (DB2), ou comandos
//* TSO. O conteudo de SYSTSIN depende do produto chamado.
//* ------------------------------------------------------------------
//XXXXXX   JOB (JEFF),'TSO BATCH',CLASS=A,MSGCLASS=X,REGION=6M
//STEP1    EXEC PGM=IKJEFT01
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  LISTCAT ENT(XX.XXXXXX.XXXXXX) ALL
/*

