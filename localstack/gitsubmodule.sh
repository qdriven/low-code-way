#!/bin/bash
# save super directory
currentDir=`pwd`
# get all the git repos inside (except .) and format them 
# the way git does
gitDirs=`find -type d -name ".git" | sed -e 's|.git$||' -e 's|./||' -e 's|/$||' | grep -v "^$"`

for i in ${gitDirs[@]}
do
        echo "dealing with $i now"

        cd $i 
        # get the remote url for each submodule
        fetchUrl=`git remote -v | awk '/fetch/ {print $2}'`
        # for my purposes repos without remotes are useless
        # but you may have a different use case
        if [[ -z $fetchUrl ]]
        then
                echo "fetch url not found for this directory"
                continue
        else                                                      
                echo "got a fetch url of $fetchUrl for git repo $i"                                                                 
        fi                                                        

        cd $currentDir
        # make sure it isn't tracked as a submodule already                                                         
        existing=`grep -A5  $i ./.gitmodules | grep $fetchUrl`    

        if [[ -z $existing ]]                                     
        then                                                      
                echo "does not exist in .gitmodules yet, will create now"
                # if it doesn't exist yet then create it
                git submodule add $fetchUrl $i
        else
                echo "$i is already present as a submodule with fetch url: $fetchUrl"
                echo "The command we would have used is: git submodule add $fetchUrl $i"
        fi
done