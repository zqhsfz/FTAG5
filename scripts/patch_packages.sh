#!/usr/bin/env bash

set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py

EXKT_PATCH=$TestArea/scripts/exkt.patch
DISABLE_EXKT=$TestArea/scripts/disable-exkt.patch
DERIVATION_DIR=$TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag
FTAG5=$DERIVATION_DIR/share/FTAG5.py

## forward sequence
patch $AODFIX < $JVC_PATCH
patch -p0 -N -d $DERIVATION_DIR < $EXKT_PATCH
patch $FTAG5 < $DISABLE_EXKT

## reverse sequence
# patch -R $FTAG5 < $DISABLE_EXKT
# patch -p0 -R -d $DERIVATION_DIR < $EXKT_PATCH
# patch -R $AODFIX < $JVC_PATCH
