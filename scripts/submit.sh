#!/usr/bin/env bash

set -eu

if ! git diff-index --quiet HEAD; then
    echo "ERROR: uncommitted changes in local area, please commit them" >&2
    exit 1
fi

# go to the run directory
HERE=$(pwd)
cd WorkArea/run

# set cleanup function
TARBALL=workarea.tar
function cleanup() {
    if [[ -f $TARBALL ]]; then
        echo "removing $TARBALL"
        rm -rf $TARBALL
    fi
}
trap cleanup EXIT

SCRIPTS=$HERE/scripts

# create tarball
DUMMY_FOR_TARBALL=$(head -n1 $SCRIPTS/ds-list-hbb.txt)
DUMMY_OUTPUT_DS=$($SCRIPTS/ftag5-grid-name.sh $DUMMY_FOR_TARBALL)
if [[ ! -f $TARBALL ]]; then
    pathena --trf "Reco_tf.py --outputDAODFile pool.root \
          --inputAODFile %IN --reductionConf FTAG5" \
            --inDS $DUMMY_FOR_TARBALL $DUMMY_OUTPUT_DS \
            --outTarBall=$TARBALL --noSubmit
fi

# submit jobs
DS_LISTS=$(echo $SCRIPTS/ds-list-{ttbar,wtz,hbb,jzw,nikola}.txt)
DATASETS=$(cat $DS_LISTS | sort -u)
echo "Submitting over $(echo $DATASETS | wc) files"
for INPUT_DS in $DATASETS
do
    OUTPUT_DS=$($HERE/scripts/ftag5-grid-name.sh $INPUT_DS)

	  # run the job
	  pathena \
	      --trf \
	      "Reco_tf.py \
	--preExec 'from BTagging.BTaggingFlags import BTaggingFlags;BTaggingFlags.CalibrationTag = \"BTagCalibRUN12-08-30\";BTaggingFlags.ForceMV2CalibrationAlias=False;' \
	--outputDAODFile pool.root \
	--inputAODFile %IN \
	--reductionConf FTAG5" \
	      --nFilesPerJob=1 \
        --inTarBall=$TARBALL \
	      --inDS $INPUT_DS \
        $OUTPUT_DS || true

done
