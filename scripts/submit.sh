#!/usr/bin/env bash

PREFIX="group.phys-exotics"
SUFFIX="TTBAR"

declare -a INPUTFILEARRAY

INPUTFILEARRAY[0]=mc15_13TeV.410000.PowhegPythiaEvtGen_P2012_ttbar_hdamp172p5_nonallhad.recon.AOD.e3698_s2608_s2183_r7377_r7351

for i in `seq 0 0`;
do
	INPUT_DS=${INPUTFILEARRAY[$i]}
	TO_REMOVE_1="mc15_13TeV."
	TO_REMOVE_2="MadGraphPythia8EvtGen_A14NNPDF23LO_"
	TO_REMOVE_3="merge.AOD."
	TO_REMOVE_4="Pythia8EvtGen_A14NNPDF23LO_"
	STRIPPED_INPUT_DS=`echo $INPUT_DS | sed "s/$TO_REMOVE_1//" | sed "s/$TO_REMOVE_2//" | sed "s/$TO_REMOVE_3//" | sed "s/$TO_REMOVE_4//"`
	OUTPUT_DS=$PREFIX"."$STRIPPED_INPUT_DS"."$SUFFIX"/"
	echo $INPUT_DS
	echo $OUTPUT_DS

	# go to the run directory
	cd WorkArea/run

	# run the job
	pathena \
	--official \
	--voms atlas:/atlas/phys-exotics/Role=production \
	--trf \
	"Reco_tf.py \
	--preExec 'from BTagging.BTaggingFlags import BTaggingFlags;BTaggingFlags.CalibrationTag = \"BTagCalibRUN12-08-18\"' \
	--outputDAODFile pool.root \
	--inputAODFile %IN \
	--reductionConf FTAG5" \
	--nFilesPerJob=1 \
	--extOutFile DAOD_FTAG5.pool.root \
	--inDS $INPUT_DS \
	--outDS $OUTPUT_DS

	# go back
	cd ../..
done
