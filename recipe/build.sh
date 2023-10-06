#!/usr/bin/env bash

# TELEMAC home directory
export HOMETEL=$SRC_DIR/telemac-mascaret
# Configuration file
export SYSTELCFG=$HOMETEL/configs/systel.cfg

# Configure PATH and PYTHONPATH
export PATH=$HOMETEL/scripts/python3:$PATH
export PYTHONPATH=$HOMETEL/scripts/python3 #:$PYTHONPATH

rm -rf $HOMETEL/configs/*
#linux
if [[ $(uname) == Linux ]]; then
   cp $SRC_DIR/systel.linux.cfg $SYSTELCFG
#OSX
elif [[ $(uname) == Darwin ]]; then
   cp $SRC_DIR/systel.macos.cfg $SYSTELCFG
   export USETELCFG=gfort-mpich
fi
# Set TELEMAC version in systel.cfg
sed -i "/^modules:/a version:    $TELEMAC_VERSION" "$SYSTELCFG"

# Name of the configuration to use
export LD_LIBRARY_PATH=$HOMETEL/builds/$USETELCFG/wrap_api/lib:$HOMETEL/builds/$USETELCFG/lib

compile_telemac.py

mkdir -p $PREFIX/telemac-mascaret/configs                        #1 Copy configs
mkdir -p $PREFIX/telemac-mascaret/builds                         #2 Copy builds
mkdir -p $PREFIX/telemac-mascaret/scripts                        #3 Copy scripts
mkdir -p $PREFIX/telemac-mascaret/sources                        #4 Copy sources
cp -r $SYSTELCFG $PREFIX/telemac-mascaret/configs             #1
cp -r $HOMETEL/builds/* $PREFIX/telemac-mascaret/builds       #2
cp -r $HOMETEL/scripts/* $PREFIX/telemac-mascaret/scripts     #3
cp -r $HOMETEL/sources/* $PREFIX/telemac-mascaret/sources     #4

# AUTO activate /deactivate environments variables for TELEMAC
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done