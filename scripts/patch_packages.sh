#!/usr/bin/env bash

set -eu

JVC_PATCH=$TestArea/scripts/disable-jvc.patch
AODFIX=$TestArea/Reconstruction/AODFix/python/AODFix_r207.py
patch $AODFIX < $JVC_PATCH
