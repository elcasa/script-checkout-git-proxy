#!/bin/bash

# command example: 
#    sh checkoutProject.sh "C:\dev\IdeaProjects" http://my-server:7990/my-project.git
#    sh checkoutProject.sh "C:\dev\IdeaProjects" http://my-server:7990/my-project.git develop

readonly PROXY=http://123.45.678.9:9876

#######################################
# Params

basePath=$1
cloneUrl=$2

echo "Param 1 basePath: $basePath"
echo "Param 2 cloneUrl: $cloneUrl"

branch=master
if [ "$3" ]
  then
    branch=$3
    echo "Param 3 branch: $branch"
  else 
    echo "Param 3 not supplied, branch set to default: $branch"
fi
echo ""

projectName=$(basename $cloneUrl .git)
path="$basePath\\$projectName"

echo "projectName: $projectName"
echo "path: $path"
echo "PROXY: $PROXY"

echo "Do you wish to checkout? Please answer 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
echo ""

#######################################
# Path

echo "Move to path"
mkdir -p "$basePath"
cd "$basePath"
if [ "$?" -ne "0" ]; then
  echo "cd $basePath KO"
  exit 1
fi

mkdir "$projectName"
cd "$projectName"
if [ "$?" -ne "0" ]; then
  echo "cd $projectName KO"
  exit 1
fi

#######################################
# Git

echo "Start checkout"

set -x #echo ON

git init
git remote add origin $cloneUrl
git config http.proxy $PROXY
git fetch
git checkout -f $branch

set +x
echo ""
echo "Finished OK"
