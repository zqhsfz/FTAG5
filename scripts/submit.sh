#!/usr/bin/env bash

if ! git diff-index --quiet HEAD; then
    echo "ERROR: uncommitted changes in local area, please commit them" >&2
    exit 1
fi

HERE=$(pwd)
cd WorkArea/run
for INPUT_DS in $(cat $HERE/scripts/messed-up-aods.txt);
do
    OUTPUT_DS=$($HERE/scripts/ftag5-grid-name.sh $INPUT_DS)
	  # echo $INPUT_DS
	  # echo $OUTPUT_DS

	  # go to the run directory

	  # run the job
	  pathena \
	      --trf \
	      "Reco_tf.py \
	--preExec 'from BTagging.BTaggingFlags import BTaggingFlags;BTaggingFlags.CalibrationTag = \"BTagCalibRUN12-08-18\"' \
	--outputDAODFile pool.root \
	--inputAODFile %IN \
	--reductionConf FTAG5" \
	      --nFilesPerJob=1 \
	      --inDS $INPUT_DS \
        $OUTPUT_DS

done
