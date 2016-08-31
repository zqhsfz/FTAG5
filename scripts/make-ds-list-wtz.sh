#!/usr/bin/env bash

FILTER='merge\.AOD\..*(r7725|r7772)_r7676$'
# first sequence is W' to qqqq, second is
for DSID in $(seq 301254 301287) $(seq 301322 301335); do
    rucio list-dids "mc15_13TeV.$DSID.*" --short | egrep $FILTER | tail -n1
done


