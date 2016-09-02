#!/usr/bin/env bash

set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py
patch $AODFIX < $JVC_PATCH

EXKT_PATCH=$TestArea/scripts/exkt.patch
DERIVATION_DIR=$TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag
patch -p0 -N -d $DERIVATION_DIR < $EXKT_PATCH
