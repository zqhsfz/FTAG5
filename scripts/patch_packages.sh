#!/usr/bin/env bash

set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py
patch $AODFIX < $JVC_PATCH

JVC_PATCH_HARDER=$TestArea/scripts/disable-jvc-harder.patch
LOAD_TOOLS=$TestArea/PhysicsAnalysis/JetTagging/JetTagAlgs/BTagging/python/BTaggingConfiguration_LoadTools.py
patch $LOAD_TOOLS < $JVC_PATCH_HARDER
