#!/usr/bin/env bash

set -eu

patch ../Reconstruction/AODFix/python/AODFix_r207.py < disable-jvc.patch
