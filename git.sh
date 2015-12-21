#!/bin/bash
git add . --all
git commit -a -m 'update'
git push
jekyll build
cd _site
#rm Gem*
#rm git.sh
git init
git add .
git commit -m 'update'
git remote add origin git@github.com:Ethanol/ethanol.github.com.git
git push -f
