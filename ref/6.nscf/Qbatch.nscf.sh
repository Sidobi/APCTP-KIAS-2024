#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16      # Cores per node
#SBATCH --mem=191000
#SBATCH --partition=ice           # Partition Name
##
#SBATCH --job-name=PWSCFExample
##SBATCH --time=96:00:00           # Runtime: HH:MM:SS
#SBATCH -o tjob.%N.%j.out         # STDOUT
#SBATCH -e tjob.%N.%j.err         # STDERR
##

hostname
date

module purge
module add compiler/2022.1.0
module add mkl/2022.1.0
module add mpi/2021.6.0
module add QE/7.1


export OMP_NUM_THREADS=1
export RSH_COMMAND="/usr/bin/ssh -x"
export MPIARG="-genv I_MPI_DEBUG=5 "


# slurm: PWSCF FOR MULTI-NODES
# LOCATION OF INPUT FILE
## To use current dir, set INP_DIR="local", OUT_DIR="local"

INP_DIR="INPUT"
OUT_DIR="RESULT"
PWSCF_INPUT="nscf.in"

RUNBIN="/home/dshin/Install/qe-7.2/bin/pw.x"
##RUNBIN="/TGM/Apps/QE/7.1/bin/pw.x"

#Remove scratch (YES/NO)
RMSCRATCH="YES"
##
################################################################
#-------------------------------------------
# setup. check backup files.
#-------------------------------------------

NPROCS="${SLURM_NTASKS}"
basedir="${SLURM_SUBMIT_DIR}"

runlog="cal.log"

cd ${basedir}


   
   mpirun -np $NPROCS ${MPIARG} ${RUNBIN}  < ${PWSCF_INPUT} > nscf.out 

