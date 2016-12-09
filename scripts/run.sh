#!/usr/bin/env bash

set -eu

# go to the run directory
cd WorkArea/run

Reco_tf.py \
    --preExec 'from BTagging.BTaggingFlags import BTaggingFlags;BTaggingFlags.CalibrationTag = "BTagCalibRUN12-08-30";BTaggingFlags.ForceMV2CalibrationAlias=False;' \
    --inputAODFile \
    /afs/cern.ch/work/n/nwhallon/public/xAOD_samples/mc15_13TeV.301501.MadGraphPythia8EvtGen_A14NNPDF23LO_RS_G_hh_bbbb_c10_M1600.merge.AOD.e3820_s2608_s2183_r7772_r7676/AOD.08176602._000006.pool.root.1 \
           --outputDAODFile FTAG5.pool.root \
           --maxEvents 10 \
           --reductionConf FTAG5 | tee log_FTAG5.dat
