#!/bin/bash
#PBS -N E3.SEaa_BWA  ##job name
#PBS -l nodes=1:ppn=1  #nr of nodes and processors per node
#PBS -l mem=16gb #RAM
#PBS -l walltime=10:00:00 ##wall time.  
#PBS -j oe  #concatenates error and output files (with prefix job1)
#PBS -t 1-100

#run job in working directory
cd $PBS_O_WORKDIR 

#Load modules
module load apps/bwa-0.7.15
module load apps/samtools-1.9

#Define variables

RefSeq=aRanTem1_1.curated_primary.20200424.fa
DIR1=/newhome/bzzjrb/R.temp/SE193
DIR2=/newhome/bzzjrb/R.temp/02a_SE_mapped

NAME=$(sed "${PBS_ARRAYID}q;d" SE.namesaa)

echo "mapping started" >> map.log
echo "---------------" >> map.log

##Check if Ref Genome is indexed by bwa
if [[ ! RefGenome/$RefSeq.fai ]]
then 
	echo $RefSeq" not indexed. Indexing now"
	bwa index RefGenome/$RefSeq
else
	echo $RefSeq" indexed"
fi


##Map with BWA MEM and output sorted bam file

sample_name=`echo ${NAME} | awk -F ".fq" '{print $1}'`
echo "[mapping running for] $sample_name"
printf "\n"
echo "time bwa mem RefGenome/$RefSeq $DIR1/${NAME} | samtools sort -o $DIR2/${NAME}.bam" >> map.log
time bwa mem RefGenome/$RefSeq $DIR1/${NAME}| samtools sort -o $DIR2/${NAME}.bam
