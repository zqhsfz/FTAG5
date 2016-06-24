#!/bin/sh

# setup ATLAS
setupATLAS
asetup 20.7.6.1,AtlasDerivation,here
localSetupRucioClients -s
localSetupPandaClient
voms-proxy-init -voms atlas
