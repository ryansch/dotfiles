#!/bin/bash

KEYNAME=
keybase pgp verify -d ${KEYNAME:?}.sig -i ${KEYNAME:?} -S 1password
