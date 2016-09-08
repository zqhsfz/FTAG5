#!/usr/bin/env bash

set -eu

pkgco.py ParticleJetTools-00-03-33-08
pkgco.py DerivationFrameworkFlavourTag-00-01-60
cmt co -r MVAUtils-00-00-04 Reconstruction/MVAUtils

pkgco.py BTagging-00-07-63-01
pkgco.py JetTagTools-01-00-96-02

pkgco.py AODFix-00-03-26
