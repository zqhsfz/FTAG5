#!/bin/sh

# copy the job options
cp FTAG5.py PhysicsAnalysis/DerivationFramework/DerivationFrameworkFlavourTag/share

# patch the packages
patch PhysicsAnalysis/DerivationFramework/DerivationFrameworkCore/python/DerivationFrameworkProdFlags.py < DerivationFrameworkProdFlags.patch
