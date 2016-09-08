#!/usr/bin/env bash

set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py

FTAG5=$TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/share/FTAG5.py
DISABLE_SKIM_PATCH=$TestArea/scripts/disable-skim.patch

## forward sequence
patch -N $AODFIX < $JVC_PATCH
patch -N $FTAG5 < $DISABLE_SKIM_PATCH

## reverse sequence
# patch -R $FTAG5 < $DISABLE_SKIM_PATCH
# patch -R $AODFIX < $JVC_PATCH
