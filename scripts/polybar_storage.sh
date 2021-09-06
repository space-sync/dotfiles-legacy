#!/usr/bin/env zsh

_STORAGE_ROOT=$(df | awk '{print $0}' | grep '/$' | awk '{print $5}')
echo " /: $_STORAGE_ROOT"