# Raw data to variants

Raw fastq data was demultiplexed, and adapters removed. See [here](https://www.biorxiv.org/content/10.1101/427872v1) for methods

A new Rana temporaria genome was released by Sanger. We're using the first public version: aRanTem1_1.curated_primary.20200424.fa

The genome is available [here](ftp://ngs.sanger.ac.uk/scratch/project/grit/VGP/aRanTem1/) and was released to me 1 June 2020. This should be submitted to GenBank/ENA soon. 

Contact at Sanger = James Torrance. 


## 1. Map

These are short SE ddRAD reads generated on HiSeq. I will map to the Reference genome using bwa mem. 

See script [here](https://github.com/alexjvr1/Rtemp_AdaptationAcrossLatitude/blob/main/02a_MapwithBWAmem.ARRAY_SEaa.sh). 

We need to point to all the raw fastq files, but the array script can only run 100 parallel threads at once. First list all the fastq files
```
/newhome/bzzjrb/R.temp/SE193

ls *fastq.gz >> SE.names

split -l 100 SE.names

##move to the main folder where we'll run the script. 

cp SE.names* /newhome/bzzjrb/R.temp/

#modify each script to point to each SE.names file in turn. 
```


## 2. Index

The default samtools index uses .bai indexing on bam files which uses a default interval size of 2^14bp (= 16384bp). The maximum size for bai indexing is 2^29 (536870912bp) per contig (~536Mb). 

The smaller the query interval the more fine-grain the indexing, but the more computationally expensive it is to index. This approach is frequently applied in plants as they have very large chromosomes. 

R.temporaria chrs 1 and 2 are both larger than this max size, so we need to use .csi indexing. 

See BioStars comment [here](https://www.biostars.org/p/111984/)


```
/newhome/bzzjrb/R.temp/02a_SE_mapped

##list all bamfiles

ls *bam >> bamfiles

## I can submit a maximum of 100 jobs in parallel per array on the BlueCrystal server, so I need to split the bamfiles into several files with max 100 lines in each

split -l 100 bamfiles

#This creates two files: xaa, xab
#Modify the script (see link below) to point to each of these in turn
```

Script [02a_index.bamfiles.sh](https://github.com/alexjvr1/Rtemp_AdaptationAcrossLatitude/blob/main/02a_index.bamfiles.sh)



