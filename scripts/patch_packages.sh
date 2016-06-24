#!/usr/bin/env bash

# copy the job options
cp scripts/FTAG5.py PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/share

# patch the packages
patch PhysicsAnalysis/DerivationFramework/DerivationFrameworkCore/python/DerivationFrameworkProdFlags.py < scripts/DerivationFrameworkProdFlags.patch
