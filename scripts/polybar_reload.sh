#!/usr/bin/env sh

#Script to reload an instance of Polybar
if [[ -z $(pidof polybar) ]]; then
    launchpolybar &
else
    polybar-msg cmd restart
fi
