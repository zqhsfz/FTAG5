#!/usr/bin/env bash

set -eu

pkgco.py DerivationFrameworkFlavourTag-00-01-55
cmt co -r MVAUtils-00-00-04 Reconstruction/MVAUtils
pkgco.py BTagging-00-07-64
pkgco.py JetTagTools-01-00-96-branch
pkgco.py AODFix-00-03-26
