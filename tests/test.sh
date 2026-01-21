#!/usr/bin/env bash

set -e

run_playbook() {
    local state=$1
    local fail_if_changed=$2
    local folding=${3-}
    local extra_vars="state=$state fail_if_changed=$fail_if_changed"

    if [ -n "$folding" ]; then
        extra_vars="$extra_vars folding=$folding"
    fi

    ansible-playbook -i hosts stow.yml --extra-vars "$extra_vars" -v
}

# create the library directory and copy the module
mkdir -p library
cp ../stow library

# move the package to the home directory
cp -r package ~

# run the playbook and stow the package
figlet "state: present"
run_playbook "present"

# test if the target file is a symbolic link
test -h "$HOME/.config/foo" || exit 1

# test the file content
grep -Fxq bar "$HOME/.config/foo/bar" || exit 1

# run the playbook and unstow the package
figlet "state: absent"
run_playbook "absent"

# test if the target symlink were removed
test -h "$HOME/.config/foo" && exit 1

# stow ,restow, unstow
figlet "state: latest"
run_playbook "present"
run_playbook "latest"
run_playbook "latest" "yes"
run_playbook "latest" "yes"
run_playbook "absent"

# create a file that should conflict with the package
mkdir -p "$HOME/.config/foo"
echo "wrong" >> "$HOME/.config/foo/bar"

# test if conflict
figlet "conflict"
run_playbook "present" && exit 1

# stow (and override); test again
run_playbook "supress"

# test the file content (again)
grep -Fxq bar "$HOME/.config/foo/bar" || exit 1

# test `--no-folding`
figlet "folding"
run_playbook "absent" # clean the directory
run_playbook "present" "no" "false"

# test if the directories were actually created and not symlinked
test -d "$HOME/.config" || exit 1
test -d "$HOME/.config/foo" || exit 1
test -L "$HOME/.config/foo/bar" || exit 1
