#!/usr/bin/env bash

# go to the run directory
cd WorkArea/run

Reco_tf.py \
--preExec 'from BTagging.BTaggingFlags import BTaggingFlags;BTaggingFlags.CalibrationTag = "BTagCalibRUN12-08-18"' \
--inputAODFile \
/afs/cern.ch/work/m/malanfer/public/training/AOD.root \
--outputDAODFile FTAG5.pool.root \
--reductionConf FTAG5 | tee log_FTAG5.dat
