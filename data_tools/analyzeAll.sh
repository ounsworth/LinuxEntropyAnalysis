#!/bin/bash

read -p "Descend into all subfolders, analyzing \"entropyExperiment.data\" [y/N]? " yn
case $yn in
    [Yy]* ) : ;;
    * ) exit;;
esac

for f in ./* ; do
  if [[ -d $f ]]; then
    echo ; echo ; echo "****** Descending into $f ******"
    pushd $f
    analyzeData.sh entropyExperiment.data | tee analyzeData.log
    popd
  fi
done;
