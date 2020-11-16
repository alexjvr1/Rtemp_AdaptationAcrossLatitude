#!/bin/bash
#PBS -N angsd.SE.test  ##job name
#PBS -l nodes=1:ppn=1  #nr of nodes and processors per node
#PBS -l mem=16gb #RAM
#PBS -l walltime=20:00:00 ##wall time.  
#PBS -j oe  #concatenates error and output files (with prefix job1)
#PBS -t 1-13 #array job

#Set filters
N="193"
MININD="5"
MINMAF=""
MINQ="20"
minMAPQ="20"
minDP="2"
maxDP="621"
POP="SE"
C="50"
POPLIST="SE.poplist"
SPECIESDIR="/newhome/bzzjrb/R.temp"
PP=0 #use all reads. Flag 1 uses only proper pairs, but	MODC has	merged reads. NB to filter for proper pair reads in the bamfiles using samtools before this point

#run job in working directory
cd $PBS_O_WORKDIR 

#load modules
module load languages/gcc-6.1
angsd=~/bin/angsd/angsd

#Define variables
REGION=$(sed "${PBS_ARRAYID}q;d" regions)
#REGION="chr1"

#estimate SAF for modern expanding population using ANGSD

time $angsd -b $POP.$N.poplist -checkBamHeaders 1 -minQ 20 -minMapQ 20 -uniqueOnly 1 -remove_bads 1 \
-only_proper_pairs $PP -r ${REGION} \
-GL 1 -doSaf 1 -anc $SPECIESDIR/RefGenome/*fa -ref $SPECIESDIR/RefGenome/*fa \
-doCounts 1 -setMinDepthInd $minDP -setMaxDepth $maxDP -doMajorMinor 4\
 -out $SPECIESDIR/04b_ANGSD_FINAL/SFS_and_Fst/$POP.${REGION} -C $C -baq 1 -dumpCounts 2\
 -doDepth 1 -doGlf 2 -minInd $MININD
