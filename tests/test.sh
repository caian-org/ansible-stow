#!/usr/bin/env bash

set -e

run_playbook() {
    ansible-playbook -i hosts stow.yml --extra-vars "state=$1" -vvv
}

test_target_file() {
    # test if the target file is a symbolic link
    test -h "$HOME/.config/foo/bar" || exit 1

    # test the file content
    grep -Fxq bar "$HOME/.config/foo/bar" || exit 1
}

# create the library directory and copy the module
mkdir library
cp ../stow library

# move the package to the home directory
mv package ~

# run the playbook and stow the package
figlet "state: present"
run_playbook "present"

# test
test_target_file

# run the playbook and unstow the package
figlet "state: absent"
run_playbook "absent"

# test if the target symlink were removed
test -h "$HOME/.config/foo/bar" && exit 1

# stow ,restow, unstow
figlet "state: latest"
run_playbook "present"
run_playbook "latest"
run_playbook "absent"

# create a file that should conflict with the package
mkdir -p "$HOME/.config/foo"
echo "wrong" >> "$HOME/.config/foo/bar"

# test if conflict
figlet "conflict"
run_playbook "present" && exit 1

# stow (and override); test again
run_playbook "supress"
test_target_file