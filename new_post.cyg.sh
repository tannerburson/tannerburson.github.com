#!/bin/bash

for x in "$@"
do
 title="$title-$x"
done 

rake post[$title]
