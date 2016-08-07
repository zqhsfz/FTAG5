#!/usr/bin/env bash

FILTER='merge\.AOD\..*(r7725|r7772)_r7676$'
for DSID in $(seq 301488 301507) $(seq 361020 361032); do
    rucio list-dids "mc15_13TeV.$DSID.*" --short | egrep $FILTER
done


