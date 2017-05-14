#! /bin/sh

SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
HERE=$(dirname "$SCRIPT")

# Get ansible installed
# ---------------------

if [ -f $HERE/.start_was_run ]; then
  echo "Start was run, /etc/ansible/hosts will be overwritten on rerun!"
  echo "Indiviual playbooks can be run with ansible-playbook"
  echo "Delete .start_was_run to allow this to run again" 
  exit 1 
fi

sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y

# TODO this command is overwriting...
sudo sh -c 'echo localhost ansible_connection=local > /etc/ansible/hosts'

# Setup playbook requirements
sudo ansible-galaxy install -r $HERE/requirements.yaml

# Run the Playbooks

cd $HERE

sed "s/git@github.com:/https:\/\/github.com\//" .gitmodules > .gitmodules_new
mv .gitmodules_new .gitmodules
git submodule init
git submodule update
ansible-playbook installation.yml --sudo -K -c local -i "localhost,"

#ansible-playbook zsh.yaml
#ansible-playbook neovim_deps.yaml
#ansible-playbook neovim.yaml
#ansible-playbook git.yaml
#ansible-playbook dotfiles.yaml

# Not sure how to do this with ansible.. set default shell
echo 'Set Zsh to default shell'
chsh -s $(which zsh)
echo 'some other steps still required'
echo 'sudo vi /etc/passwd'
echo 'Find the line with your username'
echo 'Replace bash with zsh'
echo ''

touch $HERE/.start_was_run

echo 'Fin'
