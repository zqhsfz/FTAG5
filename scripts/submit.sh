#!/usr/bin/env bash

set -eu

if ! git diff-index --quiet HEAD; then
    echo "ERROR: uncommitted changes in local area, please commit them" >&2
    exit 1
fi

HERE=$(pwd)
cd WorkArea/run

TARBALL=workarea.tar
pathena --trf "Reco_tf.py --outputDAODFile pool.root --inputAODFile %IN \
	--reductionConf FTAG5" --inDS dummy dummy \
        --outTarBall=$TARBALL --noSubmit


for INPUT_DS in $(cat $HERE/scripts/ds-list-wtz.txt);
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
        --inTarBall=$TARBALL \
	      --inDS $INPUT_DS \
        $OUTPUT_DS

done
