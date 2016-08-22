#!/usr/bin/env bash

set -eu

# compile everything
setupWorkArea.py
cd WorkArea/cmt
cmt bro cmt config
cmt bro cmt make

