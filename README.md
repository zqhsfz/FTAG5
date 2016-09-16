FTAG5 Derivation Setup
----------------------

Scripts to setup and run FTAG5 derivations

#### How to use ####

On `lxplus` you can set up with

```
git clone git@github.com:atlas-flavor-tagging-algo/FTAG5.git
cd FTAG5
. setup.sh
```

This should checkout, patch, and compile the required packages.

To run a test job, use `./scripts/run.sh`.

To run on the grid, run
```
. scripts/setup-grid.sh
./scripts/submit.sh
```

#### NOTES ####

 - Only `setup.sh` and `setup-grid.sh` should be sourced (they set
   environment variables), the **other scripts** are executable and
   **should not be sourced**.

 - On `lxplus` compilation will sometimes fail with a segfault. This
   seems to be random, if this happens you can usually recompile with
   `./scripts/compile.sh`.
