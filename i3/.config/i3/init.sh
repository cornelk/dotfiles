#!/bin/bash

tabbed=( 4)

for w in $tabbed; do
    i3-msg "workspace $w; layout tabbed"
done

i3-msg "workspace 1"
