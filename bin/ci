#!/bin/bash
# This is where the CodeIgniter main folder is
ci_dir="/Users/aziz/Sites/source/CodeIgniter_1.7.2"

# The current date used for the default project name if no project name is submited
date=`date +"%Y-%m-%d_%H-%M-%S"`

# Create the main project folder
if [ -z $1 ]
then
    read -p "Choose a name for your project: [Default: ci-$date]" project_name
    if [ -z $project_name ]
    then
        \cp -R $ci_dir ./ci-$date
        project_name=ci-$date
    else
        \cp -R $ci_dir ./$project_name
        project_name=$project_name
    fi
else
    let "folder_exists= 1"
    while [ $folder_exists -eq 1 ]
    do
        if [ -d $1 ]
        then
            echo 'This directory already exists'
            read -p "Choose a name for your project: [Default: ci-$date]" project_name
            if [ -z $project_name ]
            then
                let "folder_exists= 0"
                \cp -R $ci_dir ./ci-$date
                project_name=ci-$date
            else
                if [ -d $project_name ]
                then
                    let "folder_exists= 1"
                else
                    let "folder_exists= 0"
                    \cp -R $ci_dir ./$project_name
                    project_name=$project_name
                fi
            fi
        else
            let "folder_exists= 0"
            \cp -R $ci_dir $1
            project_name=$1
        fi
    done
fi

# Ask the user if he wants to move the application folder outside the system folder
dir=`pwd`
echo "Project folder created in $dir/"
read -p "Do you want to move the application? [Default: y]"$'\n'"[y/n] " -n 1 choice
if [ -z $choice ] || [ $choice = 'y' ]
then
    \cd "$project_name"
    mv system/application application
    \cd -
    echo -e "\nApplication folder moved outside the system folder\n"
fi
read -p "Do you want to create a public folder in the application root? [Default: y]"$'\n'"[y/n] " -n 1 choice
if [ -z $choice ] || [ $choice = 'y' ]
then
  \cd "$project_name"
  \mkdir -p public/css public/js
  \cd -
  echo -e "\nplublic folder successfully generated"
fi
echo -e "\nProject generated successfully in $dir/$project_name"