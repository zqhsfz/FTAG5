#!/usr/bin/env bash

# compile everything
setupWorkArea.py
cd WorkArea/cmt
cmt bro cmt config
cmt bro cmt make

