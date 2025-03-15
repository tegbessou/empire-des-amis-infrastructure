# Ansible

Run Ansible: ANSIBLE_config=../ansible/ansible.cfg ANSIBLE_VAULT_PASSWORD_FILE=~/.empire_des_amis_vault_password.yml ansible-playbook -u root -i ./ansible/envs/dev/00_inventory.yml ./ansible/infrastructure_base.yml