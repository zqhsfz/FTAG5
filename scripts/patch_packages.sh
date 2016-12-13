#!/usr/bin/env bash

# set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py

FTAG5=$TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/share/FTAG5.py
DISABLE_SKIM_PATCH=$TestArea/scripts/disable-skim.patch

## forward sequence
patch -N $AODFIX < $JVC_PATCH
# patch -N $FTAG5 < $DISABLE_SKIM_PATCH

## patches for substructure b-tagging
patch -N $TestArea/PhysicsAnalysis/JetTagging/JetTagTools/src/ExKtbbTagTool.cxx < $TestArea/scripts/ExKtbbTagTool_cxx.patch
patch -N $TestArea/PhysicsAnalysis/JetTagging/JetTagTools/JetTagTools/ExKtbbTagTool.h < $TestArea/scripts/ExKtbbTagTool_h.patch
patch -N $TestArea/Reconstruction/Jet/JetSubStructureUtils/Root/SubjetFinder.cxx < $TestArea/scripts/SubjetFinder_cxx.patch
patch -N $TestArea/Reconstruction/Jet/JetSubStructureUtils/JetSubStructureUtils/SubjetFinder.h < $TestArea/scripts/SubjetFinder_h.patch
patch -N $TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/python/HbbCommon.py < $TestArea/scripts/HbbCommon.patch
patch -N $TestArea/PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/share/FTAG5.py < $TestArea/scripts/FTAG5.patch

## reverse sequence
# patch -R $FTAG5 < $DISABLE_SKIM_PATCH
# patch -R $AODFIX < $JVC_PATCH
