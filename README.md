# ansible_practice
# ansible_practice


### ansible.builtin.copy
# Ansible Copy Module Parameters

## 1. File Attributes & Ownership
- **attributes (attr):** Set file attributes (same order as `lsattr`).
- **directory_mode:** Permissions for newly created directories.
- **mode:** Permissions (`0644`, `u+rwx`, `preserve`).
- **owner:** Set file owner (`chown`).
- **group:** Set file group (`chown`).

## 2. File Transfer & Content Handling
- **src:** Local path of file/directory to copy.
- **dest (required):** Remote absolute path where the file should be copied.
- **content:** Directly set file content (instead of using `src`).
- **backup:** Keep a timestamped backup before overwriting (`true`/`false`).
- **checksum:** SHA1 hash for verification of copied file.
- **remote_src:** If `true`, `src` is already on the remote machine.
- **follow:** Follow symlinks in the destination (`true`/`false`).
- **local_follow:** Follow symlinks in the source (`true`/`false`).
- **force:** Always replace if contents differ (`true`/`false`).
- **unsafe_writes:** Allow non-atomic writes (useful for Docker-mounted files) (`true`/`false`).

## 3. Security & Validation
- **decrypt:** Auto-decrypt files using Ansible Vault (`true`/`false`).
- **validate:** Run a command before saving (`%s` placeholder required).
- **SELinux Attributes:**  
  - **seuser:** SELinux user.
  - **serole:** SELinux role.
  - **setype:** SELinux type.
  - **selevel:** SELinux security level.

##  Quickly Recall These
- **"Ownership & Attributes"** → `attr`, `mode`, `owner`, `group`, `directory_mode`
- **"Transfer & Content"** → `src`, `dest`, `content`, `backup`, `checksum`, `force`
- **"Security & Validation"** → `decrypt`, `validate`, `seuser`, `serole`, `setype`, `selevel`

# Ansible `fetch` Module - Easy to Remember Guide  

## 📌 Key Parameters & Mnemonics  

### 1️⃣ `src` (Source file - Required)  
- **What?** The remote file you want to fetch.  
- **Rule:** Must be a file, not a directory.  

### 2️⃣ `dest` (Destination - Required)  
- **What?** The local directory where the file will be saved.  
- **Rule:** Hostname and path are automatically added unless `flat=true`.  

### 3️⃣ `flat` (Keep filename only?)  
- **What?** Controls whether the hostname/path is appended.  
- **Rule:**  
  - `true` → Keep only filename.  
  - `false` → Include hostname/path.  

### 4️⃣ `fail_on_missing` (Fail if file missing?)  
- **What?** Whether to fail if the remote file is unreadable.  
- **Rule:**  
  - `true` (default) → Fail if missing.  
  - `false` → Ignore missing files.  

### 5️⃣ `validate_checksum` (Verify integrity?)  
- **What?** Ensures the file is correctly copied.  
- **Rule:**  
  - `true` (default) → Verify checksum.  
  - `false` → Skip verification.  

---

## 🎯 Super Simple Trick to Remember  
✅ **S**ave (**S**rc) → **D**estination (**D**est)  
✅ **F**orce failure? (**F**ail_on_missing)  
✅ **F**ilename only? (**F**lat)  
✅ **V**erify checksum? (**V**alidate_checksum)  

📝 **Memory Trick:**  
👉 `"SDF FV"` → **S**ource, **D**estination, **F**ail, **F**lat, **V**erify  

🚀 **Quick Tip:**  
- Use `flat=true` for a single host to keep filenames simple.  
- Use `fail_on_missing=false` if some files may not exist.  


# 📌 Ansible Ad-Hoc Commands 

### ✅ Check Connectivity with Ping  
```sh
ansible all -m ping
ansible all -m command -a "uptime"
ansible all -m setup
ansible all -m command -a "hostname"
ansible all -m copy -a "src=/local/file.txt dest=/remote/path/file.txt mode=0644"
ansible all -m fetch -a "src=/etc/profile dest=/backup/"
ansible all -m user -a "name=john password={{ 'mypassword' | password_hash('sha512') }} state=present"
ansible all -m file -a "path=/remote/path/file.txt owner=root group=root mode=0644"
ansible all -m file -a "path=/remote/path/file.txt state=absent"
ansible all -m yum -a "name=htop state=present"  # For RHEL-based systems
ansible all -m apt -a "name=htop state=present update_cache=yes"  # For Debian-based systems
ansible all -m yum -a "name=htop state=absent"
ansible all -m apt -a "name=htop state=absent"
ansible all -m service -a "name=nginx state=started"  # Start Nginx
ansible all -m service -a "name=nginx state=restarted"  # Restart Nginx
ansible all -m service -a "name=nginx state=stopped"  # Stop Nginx
ansible all -m systemd -a "name=nginx enabled=yes"
ansible all -m shell -a "pkill -f nginx"

#✅ Manage Firewall Rules

ansible all -m firewalld -a "port=8080/tcp permanent=yes state=enabled"

#✅ Manage SSH Keys (Copy Public Key to Remote Machines)

ansible all -m authorized_key -a "user=root key='{{ lookup('file', '/home/user/.ssh/id_rsa.pub') }}' state=present"

#✅ Edit a Configuration File Using Lineinfile
ansible all -m lineinfile -a "path=/etc/ssh/sshd_config line='PermitRootLogin no' state=present"

#✅ Create and Mount a Filesystem

ansible all -m filesystem -a "fstype=ext4 dev=/dev/sdb state=present"
ansible all -m mount -a "path=/mnt/data src=/dev/sdb fstype=ext4 state=mounted"

#✅ Compress and Transfer Large Files
ansible all -m archive -a "path=/var/log state=compressed dest=/tmp/logs.tar.gz"
ansible all -m fetch -a "src=/tmp/logs.tar.gz dest=/local_backup/"

#✅ Run Commands with Elevated Privileges
ansible all -b -m command -a "systemctl restart nginx"

✅ Execute Multiple Commands in One Go

ansible all -m shell -a "df -h && free -m && uptime"


✅ Measure Execution Time

time ansible all -m command -a "uptime"

✅ Debug SSH Issues

ansible all -m ping -vvv


✅ Limit Execution to Specific Hosts

ansible webservers -m ping


✅ Execute a Command Only on a Subset of Hosts

ansible all -m command -a "uptime" --limit "192.168.1.10,webserver"


```
# Ansible Ad-hoc Commands Using Built-in Modules

## 1. General System Commands

```bash
ansible all -m ping
ansible all -m setup
ansible all -m command -a "uptime"
ansible all -m shell -a "df -h"
ansible all -m shell -a "free -m"
ansible all -m shell -a "whoami"
ansible all -m shell -a "uname -a"
ansible all -m shell -a "cat /etc/os-release"
```

## 2. File and Directory Management

```bash
ansible all -m file -a "path=/tmp/testfile state=touch"
ansible all -m file -a "path=/tmp/testdir state=directory mode=0755"
ansible all -m file -a "path=/tmp/testfile state=absent"
ansible all -m file -a "src=/tmp/source dest=/tmp/dest state=link"
```

## 3. Package Management (YUM/APT)

```bash
ansible all -m yum -a "name=httpd state=present"
ansible all -m yum -a "name=httpd state=absent"
ansible all -m yum -a "name=* state=latest"
ansible all -m apt -a "name=nginx state=present"
ansible all -m apt -a "name=nginx state=absent"
ansible all -m apt -a "name=* state=latest"
```

## 4. Service Management

```bash
ansible all -m service -a "name=nginx state=started"
ansible all -m service -a "name=nginx state=stopped"
ansible all -m service -a "name=nginx state=restarted"
ansible all -m service -a "name=nginx enabled=yes"
ansible all -m service -a "name=nginx enabled=no"
```

## 5. User and Group Management

```bash
ansible all -m user -a "name=john state=present"
ansible all -m user -a "name=john state=absent"
ansible all -m user -a "name=john uid=1050 group=developers"
ansible all -m group -a "name=devops state=present"
```

## 6. Managing Permissions and Ownership

```bash
ansible all -m file -a "path=/tmp/testfile owner=root group=root mode=0644"
ansible all -m file -a "path=/tmp/testdir mode=0755 recurse=yes"
```

## 7. Networking Commands

```bash
ansible all -m command -a "ip a"
ansible all -m command -a "netstat -tulnp"
ansible all -m command -a "ss -tulnp"
ansible all -m command -a "hostname -I"
ansible all -m command -a "traceroute google.com"
```

## 8. Process Management

```bash
ansible all -m shell -a "ps aux | grep nginx"
ansible all -m shell -a "kill -9 1234"
ansible all -m shell -a "pkill -f nginx"
```

## 9. Disk and Storage Management

```bash
ansible all -m shell -a "df -h"
ansible all -m shell -a "lsblk"
ansible all -m shell -a "fdisk -l"
```

## 10. Logs and Monitoring

```bash
ansible all -m shell -a "tail -n 100 /var/log/syslog"
ansible all -m shell -a "tail -n 100 /var/log/messages"
ansible all -m shell -a "journalctl -xe"
```


# Ansible Variables -

## 1. Introduction to Ansible Variables
Ansible variables allow you to store and reuse values dynamically across playbooks, roles, and tasks. Variables make playbooks more flexible and reusable.

---

## 2. Defining Variables
### a) Inside Playbooks
You can define variables directly within a playbook under the `vars` section.
```yaml
- hosts: all
  vars:
    package_name: nginx
  tasks:
    - name: Install package
      apt:
        name: "{{ package_name }}"
        state: present
```

### b) Using `vars_files`
You can store variables in an external file and load them into a playbook.
```yaml
- hosts: all
  vars_files:
    - vars.yml
```
📂 `vars.yml`
```yaml
package_name: nginx
```

### c) Using `vars_prompt`
Prompt the user to enter values during runtime.
```yaml
- hosts: all
  vars_prompt:
    - name: package_name
      prompt: "Enter the package name to install"
      private: no
```

---

## 3. Variable Precedence (Highest to Lowest)
1. **Command-line variables** (`-e` flag)
   ```bash
   ansible-playbook playbook.yml -e "package_name=nginx"
   ```
2. **Role defaults (`defaults/main.yml`)**
3. **Inventory variables**
4. **Playbook-defined variables (`vars:` section)**
5. **Host/group variables (`host_vars/` and `group_vars/`)**
6. **Facts (Gathered by `setup` module)**
7. **Role variables (`vars/main.yml`)**
8. **Block variables**
9. **Task variables**
10. **Environment variables**

---

## 4. Types of Variables
### a) Simple Variables
```yaml
username: "admin"
port: 8080
```

### b) List Variables
```yaml
users:
  - anand
  - raj
  - kumar
```

### c) Dictionary (Map) Variables
```yaml
user_info:
  name: "Anand"
  role: "DevOps Engineer"
  skills:
    - Ansible
    - Kubernetes
    - Terraform
```

---

## 5. Using Variables in Playbooks
```yaml
- hosts: all
  tasks:
    - name: Print a message
      debug:
        msg: "The selected package is {{ package_name }}"
```

---

## 6. Host and Group Variables
Define variables for specific hosts and groups in inventory files.

📂 `inventory.yml`
```yaml
web_servers:
  hosts:
    web1:
      ansible_host: 192.168.1.10
      app_port: 80
    web2:
      ansible_host: 192.168.1.11
      app_port: 8080
```

📂 `group_vars/web_servers.yml`
```yaml
app_name: "MyWebApp"
```

📂 `host_vars/web1.yml`
```yaml
app_port: 443
```

---

## 7. Registering Variables
Capture output from a task and store it in a variable.
```yaml
- hosts: all
  tasks:
    - name: Get OS details
      command: uname -a
      register: os_info

    - name: Display OS details
      debug:
        var: os_info.stdout
```

---

## 8. Environment Variables
Set environment variables for a task.
```yaml
- hosts: all
  tasks:
    - name: Run script with environment variables
      shell: ./deploy.sh
      environment:
        APP_ENV: production
        DB_HOST: localhost
```

---

## 9. Conditionals with Variables
Use variables in conditionals.
```yaml
- hosts: all
  tasks:
    - name: Restart service if it's enabled
      service:
        name: apache2
        state: restarted
      when: service_enabled == "yes"
```

---

## 10. Using Jinja2 Filters
Ansible supports Jinja2 filters for processing variables.
```yaml
- hosts: all
  tasks:
    - name: Convert list to comma-separated string
      debug:
        msg: "{{ users | join(', ') }}"
```

Other useful filters:
```yaml
- hosts: all
  tasks:
    - name: Uppercase a string
      debug:
        msg: "{{ 'ansible' | upper }}"

    - name: Default value if variable is undefined
      debug:
        msg: "{{ package_name | default('nginx') }}"
```

---

## 11. Facts as Variables
Ansible gathers facts automatically and stores them as variables.
```yaml
- hosts: all
  tasks:
    - name: Print OS distribution
      debug:
        msg: "OS: {{ ansible_distribution }} {{ ansible_distribution_version }}"
```

---

## Summary
| Method | Where Defined | Scope |
|--------|--------------|-------|
| `vars:` | Playbook | Playbook-wide |
| `vars_files:` | External File | Playbook-wide |
| `vars_prompt:` | User Input | Playbook-wide |
| `host_vars/` | Inventory | Host-specific |
| `group_vars/` | Inventory | Group-specific |
| `register:` | Task Output | Task-specific |

Ansible variables make automation dynamic and flexible, helping customize configurations without modifying playbooks directly.

---

## Additional Resources
- [Ansible Documentation](https://docs.ansible.com/)
- [Jinja2 Filters](https://jinja.palletsprojects.com/)
- [YAML Syntax Guide](https://yaml.org/)

🚀 Happy Automation with Ansible! 🎯



# Ansible Facts - 

## 1. Introduction to Ansible Facts
Ansible facts are system properties automatically collected from managed nodes. These facts provide information about OS, network, hardware, and more.

---

## 2. Gathering Ansible Facts
By default, Ansible gathers facts using the `setup` module.
```yaml
- hosts: all
  tasks:
    - name: Gather facts
      setup:
```
To disable fact gathering (for faster execution):
```yaml
- hosts: all
  gather_facts: no
```

---

## 3. Viewing Facts
To see all available facts:
```bash
ansible all -m setup
```
To filter specific facts:
```bash
ansible all -m setup -a 'filter=ansible_distribution*'
```

---

## 4. Common Ansible Facts
### a) OS & Distribution Information
```yaml
ansible_distribution: Ubuntu
ansible_distribution_version: 22.04
ansible_kernel: 5.15.0-79-generic
```
Example usage:
```yaml
- hosts: all
  tasks:
    - name: Print OS details
      debug:
        msg: "OS: {{ ansible_distribution }} {{ ansible_distribution_version }}"
```

### b) Network Information
```yaml
ansible_default_ipv4:
  address: 192.168.1.10
  gateway: 192.168.1.1
  netmask: 255.255.255.0
  interface: eth0
```
Example usage:
```yaml
- hosts: all
  tasks:
    - name: Show default IP
      debug:
        msg: "Default IP: {{ ansible_default_ipv4.address }}"
```

### c) Hardware Information
```yaml
ansible_architecture: x86_64
ansible_processor: ["Intel(R) Core(TM) i7-10750H"]
ansible_memtotal_mb: 16000
```
Example usage:
```yaml
- hosts: all
  tasks:
    - name: Show CPU details
      debug:
        msg: "Processor: {{ ansible_processor[0] }}"
```

---

## 5. Using Facts in Playbooks
Facts can be used for conditionals and tasks.
```yaml
- hosts: all
  tasks:
    - name: Restart service if Ubuntu
      service:
        name: apache2
        state: restarted
      when: ansible_distribution == 'Ubuntu'
```

---

## 6. Custom Facts
You can create custom facts by adding a `.fact` file in `/etc/ansible/facts.d/`.
```bash
sudo mkdir -p /etc/ansible/facts.d
sudo echo '{"custom_key": "custom_value"}' > /etc/ansible/facts.d/custom.fact
```
To access custom facts:
```yaml
- hosts: all
  tasks:
    - name: Show custom fact
      debug:
        msg: "Custom Fact: {{ ansible_local.custom.custom_key }}"
```

---

## 7. Summary
| Fact Type | Example Usage |
|-----------|--------------|
| OS Info | `ansible_distribution`, `ansible_kernel` |
| Network Info | `ansible_default_ipv4.address`, `ansible_interfaces` |
| CPU Info | `ansible_processor`, `ansible_architecture` |
| Memory Info | `ansible_memtotal_mb` |
| Custom Facts | `ansible_local.custom.custom_key` |

Ansible facts provide powerful automation capabilities by dynamically adapting playbooks to different system environments.

---

## Additional Resources
- [Ansible Facts Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#ansible-facts)
- [Jinja2 Filters](https://jinja.palletsprojects.com/)

🚀 Happy Automation with Ansible! 🎯

# Ansible Variables & Environment Variables - -

## 1. Introduction to Ansible Variables
Ansible variables store dynamic values and can be used to make playbooks more flexible and reusable.

---

## 2. Defining and Using Variables
### a) Defining Variables in a Playbook
```yaml
- hosts: all
  vars:
    my_var: "Hello, Ansible!"
  tasks:
    - name: Print the variable
      debug:
        msg: "{{ my_var }}"
```

### b) Defining Variables in an Inventory File
```ini
[servers]
server1 ansible_host=192.168.1.100 ansible_user=root my_var="Inventory Variable"
```
Usage in a playbook:
```yaml
- hosts: servers
  tasks:
    - name: Print inventory variable
      debug:
        msg: "{{ my_var }}"
```

### c) Defining Variables in a Separate File
Create a `vars.yml` file:
```yaml
my_var: "Variable from file"
```
Usage in a playbook:
```yaml
- hosts: all
  vars_files:
    - vars.yml
  tasks:
    - name: Print variable from file
      debug:
        msg: "{{ my_var }}"
```

---

## 3. Variable Precedence
Ansible variables have different levels of precedence. From lowest to highest priority:
1. Default variables
2. Inventory variables
3. Role variables
4. Playbook variables (`vars` section)
5. Extra variables (`-e` flag)

Example of overriding a variable using `-e`:
```bash
ansible-playbook playbook.yml -e "my_var='Overridden value'"
```

---

## 4. Types of Variables
### a) String Variables
```yaml
my_string: "Hello, World!"
```
### b) Integer Variables
```yaml
my_number: 42
```
### c) Boolean Variables
```yaml
my_bool: true
```
### d) List Variables
```yaml
my_list:
  - item1
  - item2
  - item3
```
### e) Dictionary (Map) Variables
```yaml
my_dict:
  key1: value1
  key2: value2
```
Usage example:
```yaml
- hosts: all
  vars:
    my_dict:
      name: "Ansible"
      version: "2.10"
  tasks:
    - name: Print dictionary values
      debug:
        msg: "Name: {{ my_dict.name }}, Version: {{ my_dict.version }}"
```

---

## 5. Special Variables
### a) `hostvars` - Access variables of another host
```yaml
- hosts: all
  tasks:
    - name: Print a variable from another host
      debug:
        msg: "{{ hostvars['server1']['my_var'] }}"
```

### b) `ansible_facts` - Gathered facts about the host
```yaml
- hosts: all
  tasks:
    - name: Show OS details
      debug:
        msg: "{{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}"
```

---

## 6. Environment Variables in Ansible
Environment variables can be accessed using two main methods:

### a) Using `lookup('env', 'VARIABLE_NAME')`
Fetches environment variables from the control machine (local).
```yaml
- hosts: localhost
  tasks:
    - name: Print HOME environment variable
      debug:
        msg: "HOME directory is {{ lookup('env', 'HOME') }}"
```

### b) Using `ansible_env` Facts
Retrieves environment variables from the remote machine.
```yaml
- hosts: all
  tasks:
    - name: Print PATH variable from remote host
      debug:
        msg: "PATH is {{ ansible_env.PATH }}"
```

---

## 7. Setting Environment Variables in a Playbook
### a) Setting Environment Variables for a Task
```yaml
- hosts: all
  tasks:
    - name: Set and use an environment variable
      shell: echo $MY_CUSTOM_VAR
      environment:
        MY_CUSTOM_VAR: "Hello from Ansible"
      register: output

    - name: Print the output
      debug:
        msg: "{{ output.stdout }}"
```

### b) Passing Environment Variables at Runtime
```bash
ANSIBLE_CONFIG_PATH="/etc/ansible" ansible-playbook playbook.yml
```
Usage in the playbook:
```yaml
- hosts: all
  tasks:
    - name: Print runtime environment variable
      debug:
        msg: "Ansible Config Path is {{ lookup('env', 'ANSIBLE_CONFIG_PATH') }}"
```

---

## 8. Using `command` and `shell` to Print Environment Variables
### a) Using `command` (No Shell Expansion)
```yaml
- hosts: all
  tasks:
    - name: Print HOME variable using command
      command: echo $HOME
      register: home_output

    - name: Show output
      debug:
        msg: "{{ home_output.stdout }}"
```
**Note:** `command` does not expand `$HOME`, so use `ansible_env.HOME` instead.

### b) Using `shell` (With Shell Expansion)
```yaml
- hosts: all
  tasks:
    - name: Print PATH variable using shell
      shell: echo $PATH
      register: path_output

    - name: Show output
      debug:
        msg: "{{ path_output.stdout }}"
```

### c) Printing All Environment Variables
```yaml
- hosts: all
  tasks:
    - name: Print all environment variables
      shell: env
      register: env_output

    - name: Show output
      debug:
        msg: "{{ env_output.stdout_lines }}"
```

---

## 9. Summary
| Concept | Example Usage |
|---------|--------------|
| Define Variables | `vars: my_var: "Hello"` |
| Inventory Variables | `my_var="Inventory Value"` |
| Variable Precedence | Extra vars (`-e`) override playbook vars |
| Environment Variables (Local) | `lookup('env', 'HOME')` |
| Environment Variables (Remote) | `ansible_env.PATH` |
| Setting Env Variables | `environment: { VAR: "Value" }` |
| Using `shell` & `command` | `shell: echo $HOME` |

Ansible variables and environment variables provide powerful automation capabilities by dynamically adapting playbooks to different system environments.

---

## Additional Resources
- [Ansible Variables Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html)
- [Ansible Facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#ansible-facts)

🚀 Happy Automation with Ansible! 🎯



# Ansible Shell Module - - Guide

## 1. Introduction to Ansible Shell Module
The `shell` module in Ansible is used to execute shell commands on remote hosts. Unlike the `command` module, `shell` allows you to use shell operators (like `|`, `&&`, `>`, `<`, etc.), variable expansion, and built-in shell features.

---

## 2. Basic Usage of the Shell Module
### a) Running a Simple Shell Command
```yaml
- hosts: all
  tasks:
    - name: Run a simple command
      shell: echo "Hello from Ansible Shell!"
      register: shell_output

    - name: Print command output
      debug:
        msg: "{{ shell_output.stdout }}"
```

### b) Running a Command with a Specific Shell
```yaml
- hosts: all
  tasks:
    - name: Run a command using Bash
      shell: echo "Running with Bash!"
      args:
        executable: /bin/bash
```

---

## 3. Using Variables in the Shell Module
```yaml
- hosts: all
  vars:
    my_var: "Hello, World!"
  tasks:
    - name: Use a variable in a shell command
      shell: echo "The message is: {{ my_var }}"
      register: output

    - name: Print the message
      debug:
        msg: "{{ output.stdout }}"
```

---

## 4. Capturing Command Output
```yaml
- hosts: all
  tasks:
    - name: Get current directory
      shell: pwd
      register: current_dir

    - name: Print the directory
      debug:
        msg: "Current directory is {{ current_dir.stdout }}"
```

### Capturing Multi-line Output
```yaml
- hosts: all
  tasks:
    - name: List files in /tmp
      shell: ls -l /tmp
      register: files_list

    - name: Print file list
      debug:
        msg: "{{ files_list.stdout_lines }}"
```

---

## 5. Using Pipes and Redirection
### a) Piping Output
```yaml
- hosts: all
  tasks:
    - name: Get last 5 log entries
      shell: tail -n 5 /var/log/syslog
      register: logs

    - name: Print last 5 logs
      debug:
        msg: "{{ logs.stdout_lines }}"
```

### b) Redirecting Output to a File
```yaml
- hosts: all
  tasks:
    - name: Save system information to a file
      shell: uname -a > /tmp/system_info.txt
```

---

## 6. Using Loops with Shell Commands
```yaml
- hosts: all
  tasks:
    - name: Create multiple files
      shell: touch /tmp/{{ item }}
      loop:
        - file1.txt
        - file2.txt
        - file3.txt
```

---

## 7. Handling Errors
### a) Ignoring Errors
```yaml
- hosts: all
  tasks:
    - name: Try to remove a non-existent file
      shell: rm /tmp/non_existent_file.txt
      ignore_errors: yes
```

### b) Using `failed_when` Condition
```yaml
- hosts: all
  tasks:
    - name: Check disk space
      shell: df -h | grep '/dev/sda1'
      register: disk_space
      failed_when: "'No such file or directory' in disk_space.stderr"
```

---

## 8. Running Background Commands
```yaml
- hosts: all
  tasks:
    - name: Run a process in the background
      shell: nohup sleep 300 &
```

---

## 9. Running Commands as a Specific User
```yaml
- hosts: all
  tasks:
    - name: Run as another user
      shell: whoami
      become: yes
      become_user: someuser
```

---

## 10. Using Shell with Environment Variables
```yaml
- hosts: all
  tasks:
    - name: Use an environment variable in shell
      shell: echo $MY_VAR
      environment:
        MY_VAR: "Ansible Shell Example"
      register: output

    - name: Print the variable
      debug:
        msg: "{{ output.stdout }}"
```

---

## 11. Using Shell in Handlers
Handlers execute only when a task notifies them.
```yaml
- hosts: all
  tasks:
    - name: Create a file
      file:
        path: /tmp/myfile.txt
        state: touch
      notify: restart_service

  handlers:
    - name: restart_service
      shell: systemctl restart myservice
```

---

## 12. Advanced Shell Usage
### a) Using Complex Multi-line Commands
```yaml
- hosts: all
  tasks:
    - name: Run a multi-line shell script
      shell: |
        echo "Starting Process"
        date
        uptime
```

### b) Running Commands with Timeout
```yaml
- hosts: all
  tasks:
    - name: Run a command with a timeout
      shell: timeout 10s some_long_running_command
```

### c) Running Commands in a Specific Directory
```yaml
- hosts: all
  tasks:
    - name: Run a command in /tmp
      shell: ls
      args:
        chdir: /tmp
```

---

## 13. Summary
| Concept | Example |
|---------|---------|
| Running a simple shell command | `shell: echo "Hello"` |
| Capturing output | `register: my_output` |
| Using pipes & redirection | `shell: ls -l | grep txt > files.txt` |
| Loops with shell | `loop: [file1, file2]` |
| Handling errors | `ignore_errors: yes` |
| Running background tasks | `nohup sleep 300 &` |
| Running as another user | `become_user: someuser` |
| Using environment variables | `environment: { VAR: "Value" }` |

This guide provides a complete understanding of the Ansible `shell` module, from basic usage to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Shell Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)


# Ansible Cron Module - - Guide

## 1. Introduction to Ansible Cron Module
The `cron` module in Ansible is used to manage cron jobs on Unix-based systems. It allows you to add, modify, and remove scheduled tasks easily using Ansible playbooks.

---

## 2. Basic Usage of the Cron Module
### a) Adding a Simple Cron Job
This example adds a cron job that runs a script every day at midnight.
```yaml
- hosts: all
  tasks:
    - name: Schedule a cron job to run daily at midnight
      ansible.builtin.cron:
        name: "Daily Backup"
        minute: "0"
        hour: "0"
        job: "/usr/local/bin/backup.sh"
```

### b) Removing a Cron Job
```yaml
- hosts: all
  tasks:
    - name: Remove the Daily Backup cron job
      ansible.builtin.cron:
        name: "Daily Backup"
        state: absent
```

---

## 3. Scheduling Jobs with Different Intervals
### a) Running a Job Every 5 Minutes
```yaml
- hosts: all
  tasks:
    - name: Run a script every 5 minutes
      ansible.builtin.cron:
        name: "Monitor Logs"
        minute: "*/5"
        job: "python3 /opt/scripts/log_monitor.py"
```

### b) Running a Job Every Hour
```yaml
- hosts: all
  tasks:
    - name: Run a cleanup job every hour
      ansible.builtin.cron:
        name: "Hourly Cleanup"
        minute: "0"
        hour: "*"
        job: "/usr/bin/cleanup.sh"
```

### c) Running a Job on Specific Days
```yaml
- hosts: all
  tasks:
    - name: Run a maintenance job every Sunday at 3 AM
      ansible.builtin.cron:
        name: "Sunday Maintenance"
        minute: "0"
        hour: "3"
        weekday: "0"
        job: "/usr/local/bin/maintenance.sh"
```

---

## 4. Using Special Time Strings (Reboot, Daily, etc.)
```yaml
- hosts: all
  tasks:
    - name: Run a job on reboot
      ansible.builtin.cron:
        name: "Run on Reboot"
        special_time: reboot
        job: "echo 'System Restarted' >> /var/log/reboot.log"
```

Other options for `special_time`:
- `reboot` - Runs once at system startup
- `yearly` - Runs once a year (`@yearly` or `0 0 1 1 *`)
- `monthly` - Runs once a month (`@monthly` or `0 0 1 * *`)
- `weekly` - Runs once a week (`@weekly` or `0 0 * * 0`)
- `daily` - Runs once a day (`@daily` or `0 0 * * *`)
- `hourly` - Runs once an hour (`@hourly` or `0 * * * *`)

---

## 5. Managing Cron Jobs for Different Users
```yaml
- hosts: all
  tasks:
    - name: Run a script as a specific user
      ansible.builtin.cron:
        name: "User-specific Job"
        minute: "0"
        hour: "6"
        job: "/home/user/backup.sh"
        user: "username"
```

---

## 6. Disabling and Enabling Cron Jobs
### a) Disabling a Cron Job
```yaml
- hosts: all
  tasks:
    - name: Disable a cron job
      ansible.builtin.cron:
        name: "Disabled Job"
        minute: "0"
        hour: "4"
        job: "echo 'This job is disabled'"
        disabled: yes
```

### b) Enabling a Previously Disabled Cron Job
```yaml
- hosts: all
  tasks:
    - name: Enable a previously disabled cron job
      ansible.builtin.cron:
        name: "Disabled Job"
        minute: "0"
        hour: "4"
        job: "echo 'This job is re-enabled'"
        disabled: no
```

---

## 7. Setting Environment Variables for Cron Jobs
```yaml
- hosts: all
  tasks:
    - name: Set environment variable for cron job
      ansible.builtin.cron:
        name: "Set PATH for script"
        job: "echo $MY_VAR >> /tmp/env_log.txt"
        env:
          MY_VAR: "Hello from Ansible Cron"
```

---

## 8. Redirecting Cron Output to a Log File
```yaml
- hosts: all
  tasks:
    - name: Log cron job output
      ansible.builtin.cron:
        name: "Log Cron Output"
        minute: "0"
        hour: "12"
        job: "echo 'Cron job executed' >> /var/log/cronjob.log 2>&1"
```

---

## 9. Running Multiple Cron Jobs
```yaml
- hosts: all
  tasks:
    - name: Add multiple cron jobs
      ansible.builtin.cron:
        name: "Job {{ item.name }}"
        minute: "{{ item.minute }}"
        hour: "{{ item.hour }}"
        job: "{{ item.command }}"
      loop:
        - { name: "Job 1", minute: "10", hour: "2", command: "echo 'Job 1' >> /tmp/job1.log" }
        - { name: "Job 2", minute: "30", hour: "6", command: "echo 'Job 2' >> /tmp/job2.log" }
```

---

## 10. Summary
| Feature | Example |
|---------|---------|
| Add a cron job | `ansible.builtin.cron: name=Backup minute=0 hour=0 job=/path/to/script.sh` |
| Remove a cron job | `state: absent` |
| Run job every 5 minutes | `minute: "*/5"` |
| Run job at a specific time | `hour: "3" minute: "0"` |
| Run on reboot | `special_time: reboot` |
| Run as specific user | `user: username` |
| Disable cron job | `disabled: yes` |
| Redirect output to log file | `job: "command >> /var/log/output.log 2>&1"` |

This guide provides a complete understanding of the Ansible `cron` module, from basic usage to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Cron Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/cron_module.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)



# Ansible `command` Module - - Guide

## 1. Introduction to the Ansible `command` Module
The `ansible.builtin.command` module is used to execute commands on remote machines. Unlike the `shell` module, it does not process shell features like variable substitution, pipes (`|`), and redirections (`>`, `>>`).

---

## 2. Basic Usage of the `command` Module
### a) Running a Simple Command
```yaml
- hosts: all
  tasks:
    - name: Run a basic command
      ansible.builtin.command: echo "Hello, Ansible!"
```

### b) Running a Command with Arguments
```yaml
- hosts: all
  tasks:
    - name: List files in a directory
      ansible.builtin.command: ls -l /var/log
```

---

## 3. Using `creates` to Avoid Repeated Execution
The `creates` option prevents the command from running if the specified file exists.
```yaml
- hosts: all
  tasks:
    - name: Extract a tar file only if not already extracted
      ansible.builtin.command: tar -xvf /tmp/archive.tar -C /opt/myapp/
      args:
        creates: /opt/myapp/
```

---

## 4. Using `removes` to Control Execution
The `removes` option ensures the command runs only if the specified file exists.
```yaml
- hosts: all
  tasks:
    - name: Delete a file if it exists
      ansible.builtin.command: rm /tmp/tempfile.txt
      args:
        removes: /tmp/tempfile.txt
```

---

## 5. Capturing Command Output
To capture the output of a command and use it later in the playbook, register the result.
```yaml
- hosts: all
  tasks:
    - name: Check disk space
      ansible.builtin.command: df -h /
      register: disk_space

    - name: Show command output
      debug:
        msg: "{{ disk_space.stdout }}"
```

---

## 6. Using `chdir` to Change Working Directory
The `chdir` option allows executing a command in a specific directory.
```yaml
- hosts: all
  tasks:
    - name: Run command in a specific directory
      ansible.builtin.command: make install
      args:
        chdir: /usr/local/src/myproject/
```

---

## 7. Running Commands with Different Users
You can use `become` to run commands as a different user (e.g., root).
```yaml
- hosts: all
  tasks:
    - name: Run command as root
      ansible.builtin.command: systemctl restart apache2
      become: yes
```

---

## 8. Handling Command Failures with `ignore_errors`
By default, if a command fails, Ansible stops execution. Use `ignore_errors: yes` to continue execution.
```yaml
- hosts: all
  tasks:
    - name: Try to remove a non-existent file
      ansible.builtin.command: rm /nonexistent/file.txt
      ignore_errors: yes
```

---

## 9. Using `free_form` Syntax
Instead of specifying `command: <command>`, you can use free-form syntax.
```yaml
- hosts: all
  tasks:
    - name: Free-form command execution
      command: uptime
```

---

## 10. Comparing `command` and `shell`
| Feature | `command` Module | `shell` Module |
|---------|-----------------|----------------|
| Supports pipes (`|`) |  ✅ Yes |
| Supports variable expansion (`$VAR`) | ❌ No | ✅ Yes |
| Supports redirections (`>` and `>>`) | ❌ No | ✅ Yes |
| Security | ✅ Safer | ⚠️ Less secure |

Example using `shell` (not possible with `command`):
```yaml
- hosts: all
  tasks:
    - name: Using shell module for advanced features
      ansible.builtin.shell: echo "Disk Usage: $(df -h /)" > /tmp/disk_report.txt
```

---

## 11. Summary
| Feature | Example |
|---------|---------|
| Run a simple command | `ansible.builtin.command: echo "Hello, World!"` |
| Avoid re-execution | `creates: /path/to/file` |
| Ensure execution only if a file exists | `removes: /path/to/file` |
| Capture output | `register: result` + `debug: msg={{ result.stdout }}` |
| Change directory before execution | `chdir: /path/to/dir` |
| Run as a different user | `become: yes` |
| Ignore errors | `ignore_errors: yes` |

This guide provides a complete understanding of the Ansible `command` module, from basic usage to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Command Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)


# Ansible `script` Module - - Guide

## 1. Introduction to the Ansible `script` Module
The `ansible.builtin.script` module allows you to execute scripts on remote hosts. Unlike the `command` or `shell` modules, `script` is designed to run local or remote scripts written in Bash, Python, Perl, or any other scripting language.

---

## 2. Basic Usage of the `script` Module

### a) Running a Simple Script
The `script` module executes a script located on the control machine and copies it to the remote machine for execution.

**Example: Running a Bash script**
```yaml
- hosts: all
  tasks:
    - name: Run a local script on the remote machine
      ansible.builtin.script: /path/to/myscript.sh
```

### b) Running a Python Script
```yaml
- hosts: all
  tasks:
    - name: Run a Python script on the remote machine
      ansible.builtin.script: /path/to/myscript.py
```

> **Note:** The script must have the correct shebang (`#!/bin/bash` or `#!/usr/bin/python3`) to run properly.

---

## 3. Passing Arguments to a Script
You can pass arguments to the script using the `cmd` option.

**Example: Passing Arguments to a Script**
```yaml
- hosts: all
  tasks:
    - name: Run script with arguments
      ansible.builtin.script: /path/to/myscript.sh arg1 arg2
```

If your script requires quoted arguments, use escaping:
```yaml
- hosts: all
  tasks:
    - name: Run script with quoted arguments
      ansible.builtin.script: /path/to/myscript.sh "Hello World"
```

---

## 4. Using `creates` to Prevent Repeated Execution
You can use `creates` to prevent the script from running if a specific file exists.

**Example: Extracting a Tar File Only Once**
```yaml
- hosts: all
  tasks:
    - name: Extract only if not already extracted
      ansible.builtin.script: /path/to/extract.sh
      args:
        creates: /opt/extracted/
```

---

## 5. Using `removes` to Ensure Execution Only If a File Exists
The `removes` option ensures the script runs only if the specified file is present.

**Example: Cleaning Up Logs**
```yaml
- hosts: all
  tasks:
    - name: Delete logs if they exist
      ansible.builtin.script: /path/to/cleanup.sh
      args:
        removes: /var/logs/app.log
```

---

## 6. Running Scripts as a Different User
You can use `become` to execute the script as another user (e.g., root).

**Example: Running as Root**
```yaml
- hosts: all
  tasks:
    - name: Run script as root
      ansible.builtin.script: /path/to/admin_script.sh
      become: yes
```

---

## 7. Running Scripts in a Specific Directory
The `chdir` option allows running the script in a specific directory.

**Example: Running in `/opt/app/`**
```yaml
- hosts: all
  tasks:
    - name: Run script inside a directory
      ansible.builtin.script: /path/to/setup.sh
      args:
        chdir: /opt/app/
```

---

## 8. Capturing Script Output
To capture and display the output of a script, use `register`.

**Example: Capturing Output**
```yaml
- hosts: all
  tasks:
    - name: Run script and capture output
      ansible.builtin.script: /path/to/myscript.sh
      register: script_output

    - name: Show script output
      debug:
        msg: "{{ script_output.stdout }}"
```

---

## 9. Running Scripts with Environment Variables
You can set environment variables using the `environment` directive.

**Example: Setting an Environment Variable**
```yaml
- hosts: all
  tasks:
    - name: Run script with environment variables
      ansible.builtin.script: /path/to/env_script.sh
      environment:
        APP_ENV: "production"
        DB_USER: "admin"
```

---

## 10. Handling Errors with `ignore_errors`
By default, if a script fails, Ansible stops execution. Use `ignore_errors: yes` to continue execution.

**Example: Ignoring Errors**
```yaml
- hosts: all
  tasks:
    - name: Run script and ignore errors
      ansible.builtin.script: /path/to/unstable_script.sh
      ignore_errors: yes
```

---

## 11. Comparing `script` vs. `command` vs. `shell`
| Feature | `script` Module | `command` Module | `shell` Module |
|---------|---------------|-----------------|--------------|
| Supports script execution | ✅ Yes | ❌ No | ❌ No |
| Supports pipes (`|`) | ❌ No | ❌ No | ✅ Yes |
| Supports variable expansion (`$VAR`) | ❌ No |  ✅ Yes |
| Supports redirections (`>` and `>>`) | ❌ No | ❌ No | ✅ Yes |
| Security | ✅ Safer | ✅ Safer | ⚠️ Less secure |

---

## 12. Summary
| Feature | Example |
|---------|---------|
| Run a script | `ansible.builtin.script: /path/to/script.sh` |
| Run a script with arguments | `ansible.builtin.script: /path/to/script.sh arg1 arg2` |
| Avoid re-execution | `creates: /path/to/file` |
| Ensure execution only if a file exists | `removes: /path/to/file` |
| Capture output | `register: result` + `debug: msg={{ result.stdout }}` |
| Change directory before execution | `chdir: /path/to/dir` |
| Run as a different user | `become: yes` |
| Ignore errors | `ignore_errors: yes` |

This guide provides a complete understanding of the Ansible `script` module, from basic usage to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Script Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/script_module.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)


# Ansible `template` Module - - Guide

## 1. Introduction to Ansible `template` Module
The `ansible.builtin.template` module is used to generate files dynamically on remote machines using Jinja2 templates. This is useful for configuring applications with dynamic values such as environment-specific settings.

---

## 2. Basic Usage of the `template` Module

### a) Creating a Simple Template File

Create a Jinja2 template file (`config.j2`):
```jinja2
server_name = {{ ansible_hostname }}
```

Now, apply the template using an Ansible playbook:
```yaml
- hosts: all
  tasks:
    - name: Generate configuration file
      ansible.builtin.template:
        src: config.j2
        dest: /etc/myconfig.conf
```

This will create `/etc/myconfig.conf` with the hostname dynamically replaced.

---

## 3. Passing Variables to Templates
You can pass custom variables using the `vars` section.

**Example: Using Variables in Templates**

Create a template (`message.j2`):
```jinja2
Welcome, {{ username }}!
```

Playbook to render the template:
```yaml
- hosts: all
  vars:
    username: "Anand"
  tasks:
    - name: Generate message file
      ansible.builtin.template:
        src: message.j2
        dest: /tmp/message.txt
```

---

## 4. Using Conditionals in Templates
Jinja2 allows `if` statements within templates.

Create a template (`config.j2`):
```jinja2
{% if env == "production" %}
server_mode = secure
{% else %}
server_mode = debug
{% endif %}
```

Playbook:
```yaml
- hosts: all
  vars:
    env: "production"
  tasks:
    - name: Apply environment-specific configuration
      ansible.builtin.template:
        src: config.j2
        dest: /etc/app.conf
```

---

## 5. Using Loops in Templates
Jinja2 supports `for` loops to iterate over lists.

Template (`users.j2`):
```jinja2
Users:
{% for user in users %}
- {{ user }}
{% endfor %}
```

Playbook:
```yaml
- hosts: all
  vars:
    users: ["Alice", "Bob", "Charlie"]
  tasks:
    - name: Generate user list
      ansible.builtin.template:
        src: users.j2
        dest: /tmp/users.txt
```

---

## 6. Using Filters in Templates
Jinja2 provides filters to manipulate data.

**Example: Uppercase Filter**

Template (`info.j2`):
```jinja2
Hello, {{ username | upper }}!
```

**Example: Default Value**

```jinja2
Welcome, {{ name | default('Guest') }}
```

---

## 7. Secure Templates with `ansible-vault`
You can encrypt sensitive template files with `ansible-vault`:
```bash
ansible-vault encrypt secrets.j2
```

Decrypt before using:
```bash
ansible-vault decrypt secrets.j2
```

---

## 8. Best Practices
- Use `{{ variable }}` syntax for placeholders.
- Use `creates:` option to prevent unnecessary template reapplication.
- Use `handlers` to restart services when templates change.
- Use `ansible-vault` to store sensitive templates securely.

---

## 9. Summary
| Feature | Example |
|---------|---------|
| Basic Template | `server_name = {{ ansible_hostname }}` |
| Passing Variables | `vars: { username: 'Anand' }` |
| Conditionals | `{% if env == 'prod' %} secure {% endif %}` |
| Loops | `{% for user in users %} - {{ user }} {% endfor %}` |
| Filters | `{{ username | upper }}` |
| Encrypt Templates | `ansible-vault encrypt template.j2` |

This guide provides a full understanding of Ansible's `template` module, from basics to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Template Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- [Jinja2 Template Documentation](https://jinja.palletsprojects.com/)



# Ansible Archive and Unarchive - - Guide

## 1. Introduction to Archive and Unarchive in Ansible
Ansible provides two modules for handling compressed files:
- **`ansible.builtin.archive`**: Compresses files into `.zip`, `.tar`, `.gz`, etc.
- **`ansible.builtin.unarchive`**: Extracts compressed files.

These modules are useful for managing backups, deploying applications, and transferring large files.

---

## 2. Installing Required Packages
Ensure that the `zip` and `tar` utilities are installed on the target system:
```yaml
- name: Install required utilities
  package:
    name: ["zip", "tar"]
    state: present
```

---

## 3. Using `archive` Module (Compress Files)

### a) Basic Example (Creating a `.tar.gz` File)
```yaml
- name: Archive log files
  ansible.builtin.archive:
    path: /var/log/*.log
    dest: /backup/logs.tar.gz
```

### b) Archive Multiple Files into `.zip`
```yaml
- name: Archive files into a zip
  ansible.builtin.archive:
    path:
      - /var/log/syslog
      - /var/log/auth.log
    dest: /backup/logs.zip
    format: zip
```

### c) Exclude Specific Files
```yaml
- name: Archive excluding specific files
  ansible.builtin.archive:
    path: /home/user/documents
    dest: /backup/docs.tar.gz
    exclude_path:
      - /home/user/documents/secret.txt
```

---

## 4. Using `unarchive` Module (Extract Files)

### a) Extract a `.tar.gz` File
```yaml
- name: Extract tar.gz archive
  ansible.builtin.unarchive:
    src: /backup/logs.tar.gz
    dest: /var/log/restored
    remote_src: yes
```

### b) Extract a `.zip` File
```yaml
- name: Extract zip archive
  ansible.builtin.unarchive:
    src: /backup/logs.zip
    dest: /var/log/restored
    remote_src: yes
    mode: 0755
```

### c) Extract from a Remote URL
```yaml
- name: Download and extract archive from URL
  ansible.builtin.unarchive:
    src: https://example.com/files/data.tar.gz
    dest: /opt/data
    remote_src: no
```

### d) Extract Only If Not Exists
```yaml
- name: Extract only if folder is missing
  ansible.builtin.unarchive:
    src: /backup/logs.tar.gz
    dest: /var/log/restored
    remote_src: yes
    creates: /var/log/restored/log1.log
```

---

## 5. Using `handlers` to Extract After Archiving
```yaml
- hosts: all
  tasks:
    - name: Archive files
      ansible.builtin.archive:
        path: /var/www/html
        dest: /backup/site.tar.gz
      notify: Extract Archive

  handlers:
    - name: Extract Archive
      ansible.builtin.unarchive:
        src: /backup/site.tar.gz
        dest: /var/www/restored
        remote_src: yes
```

---

## 6. Best Practices
- Use `remote_src: yes` if the archive is already on the target machine.
- Use `mode:` to set file permissions after extraction.
- Use `notify:` to trigger tasks after archiving or extracting files.
- Avoid unnecessary extraction using `creates:`.
- Use `exclude_path:` to exclude sensitive files from archives.

---

## 7. Summary
| Feature | Archive Example | Unarchive Example |
|---------|---------------|-----------------|
| Basic Archive | `dest: logs.tar.gz` | `dest: /logs/restore` |
| Multiple Files | `path: [/file1, /file2]` | N/A |
| Excluding Files | `exclude_path: [secret.txt]` | N/A |
| Extract from URL | N/A | `src: https://example.com/file.tar.gz` |
| Extract if Not Exists | N/A | `creates: /path/file.txt` |

This guide covers all aspects of the `archive` and `unarchive` modules in Ansible for efficient file management. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Archive Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/archive_module.html)
- [Ansible Unarchive Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html)



# Ansible `lineinfile` Module - - Guide

## 1. Introduction to Ansible `lineinfile` Module
The `ansible.builtin.lineinfile` module is used to modify lines in text files on remote hosts. It allows you to add, replace, or remove specific lines based on conditions.

---

## 2. Installing Required Packages
Ensure that Ansible is installed on your control node:
```bash
sudo apt update && sudo apt install ansible -y
```

---

## 3. Basic Usage - Adding a Line

### a) Append a Line if It Does Not Exist
```yaml
- name: Ensure a line exists in a file
  ansible.builtin.lineinfile:
    path: /etc/example.conf
    line: "This is a new line"
    create: yes
```
- `path`: Specifies the target file.
- `line`: The text to be added.
- `create: yes`: Creates the file if it does not exist.

### b) Insert a Line at a Specific Location (Before/After a Pattern)
```yaml
- name: Insert a line before a matching pattern
  ansible.builtin.lineinfile:
    path: /etc/example.conf
    line: "Inserted line"
    insertafter: "^PatternToFind"
```
- `insertafter`: Inserts the line after a matched pattern.

---

## 4. Modifying Lines

### a) Replacing an Existing Line
```yaml
- name: Replace an existing line
  ansible.builtin.lineinfile:
    path: /etc/example.conf
    regexp: '^OldLine.*'
    line: 'NewLineValue'
```
- `regexp`: Matches the line to be replaced.

### b) Changing Configuration Parameters
```yaml
- name: Change a configuration parameter
  ansible.builtin.lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin no'
    backup: yes
```
- `backup: yes`: Creates a backup before modifying the file.

---

## 5. Removing Lines

### a) Remove a Specific Line
```yaml
- name: Remove a line from a file
  ansible.builtin.lineinfile:
    path: /etc/example.conf
    regexp: '^UnwantedLine'
    state: absent
```
- `state: absent`: Ensures the line is removed.

---

## 6. Using `lineinfile` in Loops
### a) Add Multiple Lines
```yaml
- name: Add multiple lines using a loop
  ansible.builtin.lineinfile:
    path: /etc/multiline.conf
    line: "{{ item }}"
  loop:
    - 'Line 1'
    - 'Line 2'
    - 'Line 3'
```

---

## 7. Advanced Usage
### a) Ensure a User Exists in `/etc/passwd`
```yaml
- name: Ensure a user exists in /etc/passwd
  ansible.builtin.lineinfile:
    path: /etc/passwd
    line: 'newuser:x:1002:1002::/home/newuser:/bin/bash'
    state: present
```

### b) Disable SSH Root Login Securely
```yaml
- name: Disable SSH Root Login
  ansible.builtin.lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin no'
    state: present
    backup: yes
```

### c) Replace a Line Using Backreferences
```yaml
- name: Change SSH Port
  ansible.builtin.lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^Port (\d+)'
    line: 'Port 2222'
    backrefs: yes
```
- `backrefs: yes`: Allows modifying parts of a matched regex.

---

## 8. Best Practices
- Always use `backup: yes` when modifying critical system files.
- Use `regexp:` instead of `line:` to make changes dynamic.
- Use `state: absent` to ensure a line does not exist.
- Validate file contents before applying changes using `shell: cat /etc/example.conf`.

---

## 9. Summary
| Feature | Example |
|---------|---------|
| Add a Line | `line: "New entry"` |
| Replace Line | `regexp: '^OldValue'` → `line: 'NewValue'` |
| Remove Line | `state: absent` |
| Insert Before/After | `insertafter: '^Pattern'` |
| Backup | `backup: yes` |
| Use Loops | `loop: ['Line1', 'Line2']` |
| Modify with Backrefs | `regexp: '^Port (\d+)'` → `line: 'Port 2222'` |

This guide provides a full understanding of Ansible's `lineinfile` module, from basics to advanced techniques. 🚀 Happy Automation!

---

## Additional Resources
- [Ansible Lineinfile Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)


# Ansible User and Group Management - - Guide

## 1. Introduction to User and Group Management in Ansible
Ansible provides `ansible.builtin.user` and `ansible.builtin.group` modules to manage users and groups on remote machines. These modules help automate user creation, modification, password management, and group assignments.

---

## 2. Managing Groups with `ansible.builtin.group`

### a) Creating a New Group
```yaml
- name: Create a group
  ansible.builtin.group:
    name: developers
    state: present
```

### b) Removing a Group
```yaml
- name: Remove a group
  ansible.builtin.group:
    name: oldgroup
    state: absent
```

### c) Creating a Group with Specific GID
```yaml
- name: Create a group with a specific GID
  ansible.builtin.group:
    name: admins
    gid: 5000
    state: present
```

---

## 3. Managing Users with `ansible.builtin.user`

### a) Creating a New User
```yaml
- name: Create a new user
  ansible.builtin.user:
    name: johndoe
    state: present
    password: "{{ 'password' | password_hash('sha512') }}"
    create_home: yes
    shell: /bin/bash
```

### b) Creating a User with a Specific UID and Primary Group
```yaml
- name: Create user with UID and primary group
  ansible.builtin.user:
    name: alice
    uid: 1005
    group: developers
    state: present
```

### c) Adding a User to Multiple Groups
```yaml
- name: Add user to multiple groups
  ansible.builtin.user:
    name: bob
    groups: sudo,developers
    append: yes
```

### d) Removing a User
```yaml
- name: Remove a user
  ansible.builtin.user:
    name: tempuser
    state: absent
    remove: yes
```

### e) Changing User Password
```yaml
- name: Update user password
  ansible.builtin.user:
    name: alice
    password: "{{ 'newpassword' | password_hash('sha512') }}"
```

### f) Managing SSH Keys for Users
```yaml
- name: Add an SSH key to authorized_keys
  ansible.builtin.authorized_key:
    user: johndoe
    key: "ssh-rsa AAAAB3NzaC1... user@hostname"
    state: present
```

---

## 4. Managing System Users

### a) Creating a System User (No Login)
```yaml
- name: Create a system user
  ansible.builtin.user:
    name: daemonuser
    system: yes
    shell: /usr/sbin/nologin
```

### b) Creating a User Without a Home Directory
```yaml
- name: Create user without home directory
  ansible.builtin.user:
    name: serviceuser
    create_home: no
```

---

## 5. Best Practices for User and Group Management
- Use `password_hash()` to securely store passwords.
- Always set `append: yes` when adding users to groups to avoid overwriting existing group memberships.
- Use `system: yes` for system users to prevent unnecessary privileges.
- Use `remove: yes` when deleting users to clean up home directories.

---

## 6. Summary
| Feature | Example |
|---------|---------|
| Create Group | `state: present` |
| Create User | `state: present, create_home: yes` |
| Set Password | `password: {{ 'mypassword' | password_hash ('sha512') }}` |
| Add to Multiple Groups | `groups: sudo,developers, append: yes` |
| Remove User | `state: absent, remove: yes` |
| SSH Key Management | `authorized_key:` |

This guide provides a full-depth explanation of Ansible’s user and group management. 🚀 Happy Automation!

---

## 7. Additional Resources
- [Ansible User Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)
- [Ansible Group Module Documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html)


# Ansible Passwordless SSH - - Guide

## 1. Introduction to Passwordless SSH
Passwordless SSH authentication enables secure and automated connections between systems without requiring manual password entry. Ansible leverages SSH for managing remote machines, making passwordless SSH crucial for seamless automation.

### Why Use Passwordless SSH?
- **Increases security** by eliminating password exposure.
- **Improves automation** by allowing Ansible to connect without human intervention.
- **Enhances performance** by reducing authentication overhead.

---

## 2. Setting Up Passwordless SSH Manually
To enable passwordless SSH, follow these steps:

### a) Generate an SSH Key Pair on the Control Node
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```
- `-t rsa` specifies the RSA algorithm.
- `-b 4096` sets the key length to 4096 bits.
- `-f ~/.ssh/id_rsa` defines the file location.
- `-N ""` sets no passphrase.

### b) Copy the Public Key to the Remote Host
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote_host
```
Alternatively, use manual copying:
```bash
cat ~/.ssh/id_rsa.pub | ssh user@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### c) Verify Passwordless SSH
```bash
ssh user@remote_host
```
If successful, it logs in without a password.

---

## 3. Automating Passwordless SSH Setup with Ansible
Ansible can automate SSH key distribution using `authorized_key`.

### a) Playbook for Configuring Passwordless SSH
```yaml
- name: Setup Passwordless SSH
  hosts: all
  become: yes
  tasks:
    - name: Create .ssh directory if not exists
      ansible.builtin.file:
        path: ~/.ssh
        state: directory
        mode: '0700'

    - name: Copy SSH Public Key to Remote Server
      ansible.builtin.authorized_key:
        user: "{{ ansible_user }}"
        state: present
        key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
```

### b) Running the Playbook
```bash
ansible-playbook setup_ssh.yml --ask-pass
```
- `--ask-pass`: Prompts for the initial password-based authentication.

---

## 4. Managing SSH Configuration for Multiple Hosts
To simplify SSH connections, modify `~/.ssh/config`:
```bash
Host remote-server
    HostName 192.168.1.100
    User ansible
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
```
Now, you can log in with:
```bash
ssh remote-server
```

---

## 5. Using Ansible Vault for Secure Key Management
For additional security, encrypt private keys with Ansible Vault:
```bash
ansible-vault encrypt ~/.ssh/id_rsa
```
To use it in playbooks:
```yaml
- name: Decrypt SSH Key
  ansible.builtin.copy:
    src: ~/.ssh/id_rsa
    dest: ~/.ssh/id_rsa
    mode: '0600'
```

---

## 6. Best Practices for Passwordless SSH
- Use **strong SSH key pairs** (RSA 4096-bit or Ed25519).
- Restrict SSH access in `/etc/ssh/sshd_config`:
  ```bash
  PermitRootLogin no
  PasswordAuthentication no
  ````
- Monitor SSH access logs using `fail2ban`.

---

## 7. Summary
| Task | Command or Playbook |
|------|------------------|
| Generate SSH key | `ssh-keygen -t rsa -b 4096` |
| Copy SSH key manually | `ssh-copy-id user@remote_host` |
| Verify SSH access | `ssh user@remote_host` |
| Ansible Playbook | `setup_ssh.yml` |
| Secure with Vault | `ansible-vault encrypt ~/.ssh/id_rsa` |

This guide provides a comprehensive overview of setting up passwordless SSH for Ansible. 🚀 Happy Automation!

---

## 8. Additional Resources
- [Ansible Authorized Key Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/authorized_key_module.html)
- [OpenSSH Documentation](https://www.openssh.com/manual.html)



# Ansible Import and Include Modules - - Guide

## 1. Introduction
Ansible provides `import_` and `include_` modules to modularize playbooks, roles, and tasks efficiently. These modules help in structuring Ansible projects for better reusability and maintainability.

### Key Differences Between Import and Include:
| Feature | Import Modules | Include Modules |
|---------|---------------|---------------|
| Execution Time | Static (processed at parse time) | Dynamic (processed at runtime) |
| Performance | Faster (pre-loaded before execution) | Slower (evaluated at runtime) |
| Use Case | Best for defining fixed structures | Best for dynamic task execution |

---

## 2. `import_playbook` - Importing a Playbook
This module allows one playbook to import another, helping in modular execution.

### a) Basic Usage
```yaml
- name: Import another playbook
  import_playbook: common_tasks.yml
```

### b) Using Variables in Imported Playbooks
```yaml
- name: Import a playbook with variables
  import_playbook: deploy.yml
  vars:
    app_version: "1.2.0"
```

### c) Nested Playbook Execution
```yaml
- name: Master playbook
  import_playbook: setup.yml
- import_playbook: deploy.yml
- import_playbook: cleanup.yml
```

---

## 3. `import_role` - Importing a Role
This module statically imports a role into a play.

### a) Basic Usage
```yaml
- hosts: web
  tasks:
    - name: Import role
      import_role:
        name: apache
```

### b) Import Role with Variables
```yaml
- hosts: db
  tasks:
    - name: Import database role
      import_role:
        name: mysql
      vars:
        db_name: mydatabase
```

### c) Import Multiple Roles
```yaml
- hosts: app
  tasks:
    - import_role:
        name: frontend
    - import_role:
        name: backend
```

---

## 4. `import_tasks` - Importing a Task List
This module statically imports a list of tasks.

### a) Basic Usage
```yaml
- name: Import tasks from file
  import_tasks: setup_tasks.yml
```

### b) Import Tasks with Conditions
```yaml
- name: Import tasks if condition is met
  import_tasks: config_tasks.yml
  when: ansible_os_family == "Debian"
```

---

## 5. `include_role` - Dynamically Load and Execute a Role
Unlike `import_role`, this module dynamically includes roles during execution.

### a) Basic Usage
```yaml
- hosts: servers
  tasks:
    - name: Include role dynamically
      include_role:
        name: security
```

### b) Conditional Role Execution
```yaml
- hosts: web
  tasks:
    - name: Conditionally include role
      include_role:
        name: logging
      when: enable_logging is defined
```

---

## 6. `include_tasks` - Dynamically Include a Task List
This module dynamically includes a task list at runtime.

### a) Basic Usage
```yaml
- name: Include tasks dynamically
  include_tasks: install_tasks.yml
```

### b) Looping with Included Tasks
```yaml
- name: Include tasks for multiple users
  include_tasks: create_user.yml
  loop:
    - alice
    - bob
    - charlie
```

---

## 7. `include_vars` - Loading Variables Dynamically
This module loads variable files dynamically within a task.

### a) Basic Usage
```yaml
- name: Load variables from a file
  include_vars:
    file: app_vars.yml
```

### b) Loading Variables Based on OS Type
```yaml
- name: Load OS-specific variables
  include_vars:
    file: "vars/{{ ansible_os_family }}.yml"
```

### c) Loading Multiple Variable Files
```yaml
- name: Load all variable files
  include_vars:
    dir: /etc/ansible/vars/
```

---

## 8. Summary Table
| Module | Purpose | Example |
|--------|---------|---------|
| `import_playbook` | Statically import another playbook | `import_playbook: setup.yml` |
| `import_role` | Statically import a role | `import_role: name=nginx` |
| `import_tasks` | Statically import tasks | `import_tasks: update.yml` |
| `include_role` | Dynamically load a role | `include_role: name=database` |
| `include_tasks` | Dynamically load tasks | `include_tasks: deploy.yml` |
| `include_vars` | Dynamically load variables | `include_vars: file=config.yml` |

---

## 9. Best Practices
- **Use `import_` modules** when the structure is fixed.
- **Use `include_` modules** when tasks or roles depend on runtime conditions.
- **Organize variables efficiently** to avoid redundant inclusions.

This guide provides a full-depth explanation of Ansible's import and include modules. 🚀 Happy Automation!

---

## 10. Additional Resources
- [Ansible Import and Include Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html)


# Importing External YAML Files in Ansible - - Guide

## 1. Introduction to Importing External YAML Files in Ansible
In Ansible, managing large playbooks can be simplified by importing or including external YAML files. This improves modularity and reusability. There are two primary ways to import external YAML files:

- `import_playbook` - Used for importing entire playbooks.
- `import_tasks` & `include_tasks` - Used for importing task files.
- `vars_files` - Used for importing variable files.

---

## 2. Using `import_playbook` to Import External Playbooks
`import_playbook` is useful when you want to call one playbook from another.

### Example: Importing a Playbook
#### `main_playbook.yml`
```yaml
- name: Main Playbook
  hosts: localhost
  tasks:
    - name: Import another playbook
      ansible.builtin.import_playbook: external_playbook.yml
```

#### `external_playbook.yml`
```yaml
- name: External Playbook
  hosts: all
  tasks:
    - name: Ping all hosts
      ansible.builtin.ping:
```

### Running the Playbook
```bash
ansible-playbook main_playbook.yml
```

---

## 3. Using `import_tasks` and `include_tasks` to Import Task Files
`import_tasks` and `include_tasks` allow importing external YAML files containing tasks. The key difference is:
- `import_tasks`: Static import (evaluated at playbook parsing time).
- `include_tasks`: Dynamic import (evaluated at runtime, allows loops and conditions).

### Example: Importing Task Files
#### `main_playbook.yml`
```yaml
- name: Playbook with Imported Tasks
  hosts: localhost
  tasks:
    - name: Import tasks
      ansible.builtin.import_tasks: tasks.yml
```

#### `tasks.yml`
```yaml
- name: Create a file
  ansible.builtin.file:
    path: /tmp/example.txt
    state: touch
```

### Example: Using `include_tasks`
```yaml
- name: Playbook with Included Tasks
  hosts: localhost
  tasks:
    - name: Include tasks dynamically
      ansible.builtin.include_tasks: tasks.yml
```

---

## 4. Using `vars_files` to Import Variables
For better management, variables can be stored in an external file and loaded using `vars_files`.

### Example: Importing Variable Files
#### `main_playbook.yml`
```yaml
- name: Playbook with External Variables
  hosts: localhost
  vars_files:
    - variables.yml
  tasks:
    - name: Display imported variables
      ansible.builtin.debug:
        msg: "Hello, {{ username }}! Your role is {{ user_role }}"
```

#### `variables.yml`
```yaml
username: Alice
user_role: Admin
```

### Running the Playbook
```bash
ansible-playbook main_playbook.yml
```

Expected Output:
```
TASK [Display imported variables] ****************
ok: [localhost] => {
    "msg": "Hello, Alice! Your role is Admin"
}
```

---

## 5. Using `include_vars` to Dynamically Load Variables
Instead of `vars_files`, you can use `include_vars` to dynamically load variables at runtime.

### Example:
```yaml
- name: Load Variables Dynamically
  hosts: localhost
  tasks:
    - name: Include variable file
      ansible.builtin.include_vars:
        file: variables.yml
    - name: Print variable
      ansible.builtin.debug:
        msg: "User {{ username }} has role {{ user_role }}"
```

---

## 6. Differences Between `import_tasks`, `include_tasks`, and `import_playbook`
| Feature | `import_tasks` | `include_tasks` | `import_playbook` |
|---------|---------------|----------------|------------------|
| Use case | Import task files | Include task files dynamically | Import another playbook |
| When evaluated | Playbook parsing time | Runtime | Playbook parsing time |
| Supports loops/conditions | ❌ No | ✅ Yes | ❌ No |

---

## 7. Best Practices
- Use `import_tasks` for static imports when no conditions are needed.
- Use `include_tasks` for dynamic imports where loops or conditions are required.
- Use `vars_files` or `include_vars` to separate variables for better maintainability.
- Use `import_playbook` when managing multiple playbooks together.

---

## 8. Summary
| Task | Command or Module |
|------|------------------|
| Import Playbook | `import_playbook: external.yml` |
| Import Tasks | `import_tasks: tasks.yml` |
| Include Tasks | `include_tasks: tasks.yml` |
| Import Variables | `vars_files: variables.yml` |
| Include Variables | `include_vars: file: variables.yml` |

This guide provides a full-depth explanation of importing YAML files in Ansible. 🚀 Happy Automation!

---

## 9. Additional Resources
- [Ansible Import and Include Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html)


# Ansible Modules - - Guide

This guide provides a comprehensive explanation of essential Ansible modules with examples from nner to advanced levels.

---

## 1. Meta Module – Execute Ansible Actions
The `meta` module allows control over the execution of a playbook.

### a) Stopping Execution
```yaml
- name: Stop execution if condition is met
  ansible.builtin.meta: end_play
```

### b) Flushing Handlers Immediately
```yaml
- name: Flush handlers now
  ansible.builtin.meta: flush_handlers
```

### c) Resetting a Role
```yaml
- name: Reset role variables
  ansible.builtin.meta: reset_connection
```

---

## 2. Mount Facts Module – Retrieve Mount Information
This module gathers information about mounted filesystems.

### a) Retrieve and Display Mount Facts
```yaml
- name: Gather mount facts
  hosts: all
  tasks:
    - name: Get mount details
      ansible.builtin.mount_facts:

    - name: Show mount facts
      debug:
        var: ansible_facts.mounts
```

---

## 3. Package Module – Generic OS Package Manager
The `package` module allows installing, removing, and managing packages across different OS package managers (APT, YUM, DNF, etc.).

### a) Installing a Package
```yaml
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
    state: present
```

### b) Removing a Package
```yaml
- name: Remove Apache
  ansible.builtin.package:
    name: apache2
    state: absent
```

### c) Updating All Packages
```yaml
- name: Update all packages
  ansible.builtin.package:
    name: '*'
    state: latest
```

---

## 4. Package Facts Module – Retrieve Installed Package Information

### a) Gathering Package Facts
```yaml
- name: Gather installed package facts
  ansible.builtin.package_facts:
```

### b) Display Installed Packages
```yaml
- name: Show installed packages
  debug:
    var: ansible_facts.packages
```

---

## 5. Pause Module – Pause Playbook Execution

### a) Pause for a Fixed Duration
```yaml
- name: Pause for 10 seconds
  ansible.builtin.pause:
    seconds: 10
```

### b) Pause for User Input
```yaml
- name: Pause for confirmation
  ansible.builtin.pause:
    prompt: "Press Enter to continue..."
```

---

## 6. Ping Module – Verify Connection

### a) Checking Host Connectivity
```yaml
- name: Ping all hosts
  hosts: all
  tasks:
    - name: Ping remote hosts
      ansible.builtin.ping:
```

---

## 7. Pip Module – Manage Python Packages

### a) Installing a Python Package
```yaml
- name: Install requests library
  ansible.builtin.pip:
    name: requests
```

### b) Installing from Requirements File
```yaml
- name: Install packages from requirements.txt
  ansible.builtin.pip:
    requirements: /path/to/requirements.txt
```

### c) Uninstalling a Python Package
```yaml
- name: Uninstall flask
  ansible.builtin.pip:
    name: flask
    state: absent
```

---

## 8. Include Vars Module – Load Variables from Files

### a) Load Variables from a YAML File
```yaml
- name: Load variables from file
  ansible.builtin.include_vars:
    file: vars.yml
```

### b) Load Variables Dynamically
```yaml
- name: Load variables based on OS
  ansible.builtin.include_vars:
    file: "{{ ansible_os_family }}.yml"
```

---

## Summary Table

| Module | Description | Example Command |
|--------|-------------|-----------------|
| `meta` | Control play execution | `ansible.builtin.meta: end_play` |
| `mount_facts` | Retrieve mount details | `ansible.builtin.mount_facts:` |
| `package` | Manage system packages | `ansible.builtin.package: name=nginx state=present` |
| `package_facts` | Gather package info | `ansible.builtin.package_facts:` |
| `pause` | Pause execution | `ansible.builtin.pause: seconds=10` |
| `ping` | Check connectivity | `ansible.builtin.ping:` |
| `pip` | Manage Python libraries | `ansible.builtin.pip: name=requests` |
| `include_vars` | Load variables from files | `ansible.builtin.include_vars: file=vars.yml` |

This guide provides detailed explanations and examples to master Ansible automation! 🚀

# Ansible Modules 

This guide provides a comprehensive explanation of essential Ansible modules with examples 

---

## 1. Controlling Play Execution with the Meta Module
The `meta` module allows control over the execution of a playbook.

### a) Stopping Execution
```yaml
- name: Stop execution if condition is met
  ansible.builtin.meta: end_play
```
This stops the current play immediately.

### b) Flushing Handlers Immediately
```yaml
- name: Flush handlers now
  ansible.builtin.meta: flush_handlers
```
This forces all queued handlers to run immediately.

### c) Resetting a Role
```yaml
- name: Reset role variables
  ansible.builtin.meta: reset_connection
```
This resets the SSH connection to the managed host, useful when changing user permissions.

### d) Running a New Role Immediately
```yaml
- name: Execute a new role immediately
  ansible.builtin.meta: role_reset
```
This ensures that a new role execution starts fresh.

---

## 2. Mount Facts Module – Retrieve Mount Information
This module gathers information about mounted filesystems.

### a) Retrieve and Display Mount Facts
```yaml
- name: Gather mount facts
  hosts: all
  tasks:
    - name: Get mount details
      ansible.builtin.mount_facts:

    - name: Show mount facts
      debug:
        var: ansible_facts.mounts
```

---

## 3. Package Module – Generic OS Package Manager
The `package` module allows installing, removing, and managing packages across different OS package managers (APT, YUM, DNF, etc.).

### a) Installing a Package
```yaml
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
    state: present
```

### b) Removing a Package
```yaml
- name: Remove Apache
  ansible.builtin.package:
    name: apache2
    state: absent
```

### c) Updating All Packages
```yaml
- name: Update all packages
  ansible.builtin.package:
    name: '*'
    state: latest
```

---

## 4. Package Facts Module – Retrieve Installed Package Information

### a) Gathering Package Facts
```yaml
- name: Gather installed package facts
  ansible.builtin.package_facts:
```

### b) Display Installed Packages
```yaml
- name: Show installed packages
  debug:
    var: ansible_facts.packages
```

---

## 5. Pause Module – Pause Playbook Execution

### a) Pause for a Fixed Duration
```yaml
- name: Pause for 10 seconds
  ansible.builtin.pause:
    seconds: 10
```

### b) Pause for User Input
```yaml
- name: Pause for confirmation
  ansible.builtin.pause:
    prompt: "Press Enter to continue..."
```

---

## 6. Ping Module – Verify Connection

### a) Checking Host Connectivity
```yaml
- name: Ping all hosts
  hosts: all
  tasks:
    - name: Ping remote hosts
      ansible.builtin.ping:
```

---

## 7. Pip Module – Manage Python Packages

### a) Installing a Python Package
```yaml
- name: Install requests library
  ansible.builtin.pip:
    name: requests
```

### b) Installing from Requirements File
```yaml
- name: Install packages from requirements.txt
  ansible.builtin.pip:
    requirements: /path/to/requirements.txt
```

### c) Uninstalling a Python Package
```yaml
- name: Uninstall flask
  ansible.builtin.pip:
    name: flask
    state: absent
```

---

## 8. Include Vars Module – Load Variables from Files

### a) Load Variables from a YAML File
```yaml
- name: Load variables from file
  ansible.builtin.include_vars:
    file: vars.yml
```

### b) Load Variables Dynamically
```yaml
- name: Load variables based on OS
  ansible.builtin.include_vars:
    file: "{{ ansible_os_family }}.yml"
```

---

## Summary Table

| Module | Description | Example Command |
|--------|-------------|-----------------|
| `meta` | Control play execution | `ansible.builtin.meta: end_play` |
| `mount_facts` | Retrieve mount details | `ansible.builtin.mount_facts:` |
| `package` | Manage system packages | `ansible.builtin.package: name=nginx state=present` |
| `package_facts` | Gather package info | `ansible.builtin.package_facts:` |
| `pause` | Pause execution | `ansible.builtin.pause: seconds=10` |
| `ping` | Check connectivity | `ansible.builtin.ping:` |
| `pip` | Manage Python libraries | `ansible.builtin.pip: name=requests` |
| `include_vars` | Load variables from files | `ansible.builtin.include_vars: file=vars.yml` |

This guide provides detailed explanations and examples to master Ansible automation! 🚀

# Ansible Modules 

This guide provides a comprehensive explanation of essential Ansible modules with examples from 

---

## 1. Controlling Play Execution with the Meta Module
The `meta` module allows control over the execution of a playbook.

### a) Stopping Execution
```yaml
- name: Stop execution if condition is met
  ansible.builtin.meta: end_play
```
This stops the current play immediately.

### b) Flushing Handlers Immediately
```yaml
- name: Flush handlers now
  ansible.builtin.meta: flush_handlers
```
This forces all queued handlers to run immediately.

### c) Resetting a Role
```yaml
- name: Reset role variables
  ansible.builtin.meta: reset_connection
```
This resets the SSH connection to the managed host, useful when changing user permissions.

### d) Running a New Role Immediately
```yaml
- name: Execute a new role immediately
  ansible.builtin.meta: role_reset
```
This ensures that a new role execution starts fresh.

---

## 2. Mount Facts Module – Retrieve Mount Information
This module gathers information about mounted filesystems.

### a) Retrieve and Display Mount Facts
```yaml
- name: Gather mount facts
  hosts: all
  tasks:
    - name: Get mount details
      ansible.builtin.mount_facts:

    - name: Show mount facts
      debug:
        var: ansible_facts.mounts
```

---

## 3. Package Module – Generic OS Package Manager
The `package` module allows installing, removing, and managing packages across different OS package managers (APT, YUM, DNF, etc.).

### a) Installing a Package
```yaml
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
    state: present
```

### b) Removing a Package
```yaml
- name: Remove Apache
  ansible.builtin.package:
    name: apache2
    state: absent
```

### c) Updating All Packages
```yaml
- name: Update all packages
  ansible.builtin.package:
    name: '*'
    state: latest
```

---

## 4. Package Facts Module – Retrieve Installed Package Information

### a) Gathering Package Facts
```yaml
- name: Gather installed package facts
  ansible.builtin.package_facts:
```

### b) Display Installed Packages
```yaml
- name: Show installed packages
  debug:
    var: ansible_facts.packages
```

---

## 5. Pause Module – Pause Playbook Execution

### a) Pause for a Fixed Duration
```yaml
- name: Pause for 10 seconds
  ansible.builtin.pause:
    seconds: 10
```

### b) Pause for User Input
```yaml
- name: Pause for confirmation
  ansible.builtin.pause:
    prompt: "Press Enter to continue..."
```

---

## 6. Ping Module – Verify Connection

### a) Checking Host Connectivity
```yaml
- name: Ping all hosts
  hosts: all
  tasks:
    - name: Ping remote hosts
      ansible.builtin.ping:
```

---

## 7. Pip Module – Manage Python Packages

### a) Installing a Python Package
```yaml
- name: Install requests library
  ansible.builtin.pip:
    name: requests
```

### b) Installing from Requirements File
```yaml
- name: Install packages from requirements.txt
  ansible.builtin.pip:
    requirements: /path/to/requirements.txt
```

### c) Uninstalling a Python Package
```yaml
- name: Uninstall flask
  ansible.builtin.pip:
    name: flask
    state: absent
```

---

## 8. Include Vars Module – Load Variables from Files

### a) Load Variables from a YAML File
```yaml
- name: Load variables from file
  ansible.builtin.include_vars:
    file: vars.yml
```

### b) Load Variables Dynamically
```yaml
- name: Load variables based on OS
  ansible.builtin.include_vars:
    file: "{{ ansible_os_family }}.yml"
```

---

## 9. Ansible Strategy Methods – Controlling Execution Flow

### a) Linear Strategy (Default)
This is the default execution mode where tasks run on all hosts before moving to the next task.
```yaml
- name: Default Linear Execution
  hosts: all
  strategy: linear
  tasks:
    - name: Run first task
      debug:
        msg: "This runs sequentially on all hosts"
```

### b) Free Strategy (Parallel Execution)
In this strategy, hosts execute tasks independently and do not wait for others.
```yaml
- name: Free Execution Strategy
  hosts: all
  strategy: free
  tasks:
    - name: Run independent tasks
      debug:
        msg: "This runs independently on each host"
```

### c) Host-Pinned Strategy
Used when each host needs to complete all tasks before moving to the next host.
```yaml
- name: Host-Pinned Execution
  hosts: all
  strategy: host_pinned
  tasks:
    - name: Execute tasks per host
      debug:
        msg: "This runs all tasks per host before switching to the next"
```

**For more details, refer to:** [Ansible Strategy Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

---

## Summary Table

| Module | Description | Example Command |
|--------|-------------|-----------------|
| `meta` | Control play execution | `ansible.builtin.meta: end_play` |
| `mount_facts` | Retrieve mount details | `ansible.builtin.mount_facts:` |
| `package` | Manage system packages | `ansible.builtin.package: name=nginx state=present` |
| `package_facts` | Gather package info | `ansible.builtin.package_facts:` |
| `pause` | Pause execution | `ansible.builtin.pause: seconds=10` |
| `ping` | Check connectivity | `ansible.builtin.ping:` |
| `pip` | Manage Python libraries | `ansible.builtin.pip: name=requests` |
| `include_vars` | Load variables from files | `ansible.builtin.include_vars: file=vars.yml` |
| `strategy` | Control execution strategy | `strategy: free` |

This guide provides detailed explanations and examples to master Ansible automation! 🚀


## 2. Ansible Delegate To - Run Tasks on a Different Host
The `delegate_to` directive allows you to execute tasks on a different host than the one specified in the inventory.

### a) Running a Task on the Control Node
```yaml
- name: Run a task on the control node
  hosts: all
  tasks:
    - name: Execute a command on the control machine
      ansible.builtin.command: whoami
      delegate_to: localhost
```
This executes the `whoami` command on the Ansible control node instead of the managed host.

### b) Copying Files to a Central Server
```yaml
- name: Copy logs to a central server
  hosts: web_servers
  tasks:
    - name: Copy logs to log server
      ansible.builtin.copy:
        src: /var/log/web.log
        dest: /centralized/logs/web.log
      delegate_to: log_server
```
This ensures logs from multiple servers are collected on a central logging server.

### c) Delegating a Task to Multiple Hosts
```yaml
- name: Delegate task to multiple hosts
  hosts: all
  tasks:
    - name: Run task on multiple hosts
      ansible.builtin.shell: uptime
      delegate_to: "{{ item }}"
      loop:
        - server1
        - server2
```
This runs the `uptime` command on `server1` and `server2`, regardless of the primary target host.

### d) Using Delegation with Conditional Execution
```yaml
- name: Conditionally delegate task
  hosts: all
  tasks:
    - name: Run only if condition met
      ansible.builtin.command: echo "Running on control node"
      delegate_to: localhost
      when: ansible_os_family == 'Debian'
```
This ensures the task runs on the control node only if the managed host is a Debian-based system.

### e) Delegating to Another Host with `run_once`
```yaml
- name: Gather facts once and delegate
  hosts: all
  tasks:
    - name: Collect system info
      ansible.builtin.setup:
      delegate_to: inventory_hostname
      run_once: true
```
This runs the `setup` module on only one host and delegates the facts collection to the entire inventory.

For more details, refer to the official Ansible documentation: [Ansible Delegate To](https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html)

---

## 3. Mount Facts Module – Retrieve Mount Information
This module gathers information about mounted filesystems.

### a) Retrieve and Display Mount Facts
```yaml
- name: Gather mount facts
  hosts: all
  tasks:
    - name: Get mount details
      ansible.builtin.mount_facts:

    - name: Show mount facts
      debug:
        var: ansible_facts.mounts
```

---

## 4. Package Module – Generic OS Package Manager
The `package` module allows installing, removing, and managing packages across different OS package managers (APT, YUM, DNF, etc.).

### a) Installing a Package
```yaml
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
    state: present
```

### b) Removing a Package
```yaml
- name: Remove Apache
  ansible.builtin.package:
    name: apache2
    state: absent
```

### c) Updating All Packages
```yaml
- name: Update all packages
  ansible.builtin.package:
    name: '*'
    state: latest
```

---

## Summary Table

| Module | Description | Example Command |
|--------|-------------|-----------------|
| `meta` | Control play execution | `ansible.builtin.meta: end_play` |
| `delegate_to` | Run tasks on a different host | `delegate_to: localhost` |
| `mount_facts` | Retrieve mount details | `ansible.builtin.mount_facts:` |
| `package` | Manage system packages | `ansible.builtin.package: name=nginx state=present` |
| `pause` | Pause execution | `ansible.builtin.pause: seconds=10` |
| `ping` | Check connectivity | `ansible.builtin.ping:` |
| `pip` | Manage Python libraries | `ansible.builtin.pip: name=requests` |
| `include_vars` | Load variables from files | `ansible.builtin.include_vars: file=vars.yml` |

This guide provides detailed explanations and examples to master Ansible automation! 🚀

# Ansible Error Handling:

## Introduction
Error handling is a crucial aspect of **Ansible** automation. It ensures playbooks run efficiently, prevents unexpected failures, and provides meaningful debugging insights. This guide covers error handling

---

## 1. Basic Error Handling with `ignore_errors`
By default, Ansible stops execution when a task fails. To continue execution even if a task fails, use `ignore_errors: yes`.

### Example:
```yaml
- name: Install a package
  apt:
    name: non-existent-package
    state: present
  ignore_errors: yes
```

### Real-World Use Case:
- In large-scale deployments, some servers might not have specific packages, but the playbook should continue running.

---

## 2. Handling Errors with `failed_when`
`failed_when` is used to define custom failure conditions.

### Example:
```yaml
- name: Check disk space
  shell: df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
  register: disk_usage
  failed_when: disk_usage.stdout | int > 80
```

### Real-World Use Case:
- In DevOps pipelines, failure conditions like disk space thresholds must be checked before proceeding.

---

## 3. Using `rescue` and `always` Blocks (Block Handling)
For structured error handling, Ansible provides `block`, `rescue`, and `always` statements.

### Example:
```yaml
- name: Error handling example
  block:
    - name: Create a directory
      file:
        path: /opt/mydir
        state: directory
    - name: Simulate failure
      command: /bin/false
  rescue:
    - name: Handle failure
      debug:
        msg: "Something went wrong, but we recovered."
  always:
    - name: Cleanup
      debug:
        msg: "This will run no matter what."
```

### Real-World Use Case:
- Useful in CI/CD pipelines where failures need to be logged but shouldn't stop execution.

---

## 4. Validating Conditions with `when` and `failed_when`
Avoid running tasks that may fail under specific conditions.

### Example:
```yaml
- name: Restart service if file exists
  systemd:
    name: apache2
    state: restarted
  when: ansible_os_family == "Debian"
```

### Real-World Use Case:
- Ensures OS compatibility before executing commands.

---

## 5. Register and Debugging Failures
Using `register` to capture outputs and make decisions.

### Example:
```yaml
- name: Try to install a package
  shell: apt install nginx -y
  register: package_status
  ignore_errors: yes

- name: Debug package status
  debug:
    var: package_status.stderr
```

### Real-World Use Case:
- Helpful in debugging installation failures in automation workflows.

---

## 6. Using `until` for Retry Mechanism
Ansible allows retries for tasks that may initially fail but succeed later.

### Example:
```yaml
- name: Retry command until success
  shell: curl -s http://example.com
  register: result
  until: result.rc == 0
  retries: 5
  delay: 10
```

### Real-World Use Case:
- Ensures services that take time to start are properly checked before moving ahead.

---

## 7. Error Logging to External Systems
Logging failures to a remote system for monitoring.

### Example:
```yaml
- name: Log errors
  uri:
    url: "http://monitoring-system.local/log"
    method: POST
    body: "{\"error\": \"Ansible task failed\"}"
    body_format: json
  when: ansible_failed_task is defined
```

### Real-World Use Case:
- Helps in enterprise logging and alerting when automation fails.

---

## 8. Best Practices for Ansible Error Handling
1. **Use `ignore_errors` selectively**: Don't hide critical failures.
2. **Implement `failed_when` conditions**: Define precise failure scenarios.
3. **Use `block/rescue/always`**: Implement structured error handling.
4. **Log failures**: Send errors to monitoring tools.
5. **Use `until` and retries**: Handle temporary failures effectively.

---

## Conclusion
Error handling in Ansible ensures reliability in automation. From simple `ignore_errors` to structured `block/rescue`, proper handling prevents unexpected disruptions. Implement these strategies in real-world deployments to build resilient playbooks.

---

## References
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html)


# Ansible Handlers - Beginner to Advanced

## Introduction
Ansible Handlers are special tasks triggered by other tasks using the `notify` directive. They are typically used for actions like restarting services, reloading configurations, or sending alerts when a task modifies a system state.

---

## Key Concepts

### 1. **What are Handlers?**
Handlers are similar to regular tasks but execute only when notified by another task. They help in optimizing execution by running actions only when necessary.

### 2. **Defining Handlers**
Handlers are defined under the `handlers` section within a playbook or role. They must have a unique name.

### 3. **Triggering Handlers**
A task triggers a handler using the `notify` directive. If a task does not cause a change, the handler is not executed.

### 4. **Executing Handlers Once**
If multiple tasks notify the same handler, it will run only once per playbook execution.

### 5. **Using `force_handlers`**
By default, handlers do not run if a playbook fails. Using `force_handlers: yes` ensures they execute even if there are failures.

### 6. **Using `meta: flush_handlers`**
By default, handlers execute at the end of a playbook run. Using `meta: flush_handlers` forces them to run immediately.

---

## Basic Example: Restarting a Service

```yaml
- name: Install and configure Nginx
  hosts: web_servers
  become: yes

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
      notify: Restart Nginx

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

### Explanation:
- The task **installs Nginx**.
- If the installation modifies the system, it **notifies** the handler.
- The handler **restarts the Nginx service**.

---

## Intermediate Example: Configuring and Restarting Multiple Services

```yaml
- name: Configure Web Server
  hosts: web_servers
  become: yes

  tasks:
    - name: Deploy new Nginx config
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify: Restart Nginx

    - name: Update firewall rules
      command: ufw allow 80/tcp
      notify: Reload Firewall

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
    
    - name: Reload Firewall
      command: ufw reload
```

### Explanation:
- A **template file** is deployed, and if changed, **Nginx restarts**.
- The **firewall rule update** triggers a **firewall reload**.
- If both tasks modify the system, **both handlers run, but only once each**.

---

## Advanced Example: Using `meta: flush_handlers`

```yaml
- name: Immediate handler execution
  hosts: db_servers
  become: yes

  tasks:
    - name: Update database configuration
      template:
        src: my.cnf.j2
        dest: /etc/mysql/my.cnf
      notify: Restart MySQL
    
    - meta: flush_handlers  # Immediately execute notified handlers

    - name: Run database migrations
      command: alembic upgrade head
```

### Explanation:
- The **database configuration is updated**.
- **`meta: flush_handlers` ensures MySQL restarts immediately**, before migrations run.

---

## Real-World Industry Use Cases

### 1. **CI/CD Pipelines**
Handlers are used in **continuous deployment** to restart applications after deploying new code.

```yaml
- name: Deploy new application release
  hosts: app_servers
  tasks:
    - name: Deploy code
      git:
        repo: 'https://github.com/company/app.git'
        dest: /var/www/app
      notify: Restart Application

  handlers:
    - name: Restart Application
      systemd:
        name: app
        state: restarted
```

### 2. **Automated Patch Management**
Handlers help in **rebooting servers** only when a kernel update occurs.

```yaml
- name: Patch servers
  hosts: all
  become: yes
  tasks:
    - name: Install updates
      apt:
        upgrade: dist
      notify: Reboot Server

  handlers:
    - name: Reboot Server
      reboot:
        reboot_timeout: 300
```

### 3. **Database Failover Handling**
Handlers automate **failover actions** in a database cluster when a primary node goes down.

```yaml
- name: Monitor DB health
  hosts: db_cluster
  tasks:
    - name: Check primary DB status
      command: pg_isready -h primary_db
      register: primary_status
      failed_when: primary_status.rc != 0
      notify: Promote Standby

  handlers:
    - name: Promote Standby
      command: pg_ctl promote
```

---

## Best Practices
- **Use handlers for idempotent tasks** (e.g., restarting services only when needed).
- **Keep handler names meaningful** (e.g., `Restart Nginx` instead of `nginx_restart`).
- **Use `meta: flush_handlers` cautiously**, only when immediate execution is necessary.
- **Avoid unnecessary notifications** (e.g., wrapping tasks with `when:` to conditionally trigger handlers).
- **Use handlers for critical tasks** (e.g., ensuring security policies are applied correctly).

---

## Conclusion
Ansible Handlers are essential for **efficient and automated infrastructure management**. By understanding their concepts and applying them effectively, you can optimize automation workflows in real-world industry environments.

---

## Additional Resources
- [Ansible Handlers Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_handlers.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)



# Ansible Roles: 

## Introduction
Ansible **roles** help organize playbooks into reusable, modular components. They improve maintainability, scalability, and reusability of automation tasks.

This guide covers **Ansible Roles** from beginner to advanced levels with real-world examples.

---

## 1. What are Ansible Roles?
Roles provide a structured way to group tasks, variables, handlers, templates, and files. Each role has a predefined directory structure.

### Role Directory Structure
```
my-role/
├── tasks/
│   ├── main.yml
├── handlers/
│   ├── main.yml
├── templates/
├── files/
├── vars/
│   ├── main.yml
├── defaults/
│   ├── main.yml
├── meta/
│   ├── main.yml
├── README.md
```

### Explanation of Each Directory:
- **tasks/** - Defines the list of tasks to be executed.
- **handlers/** - Contains handlers that respond to changes in tasks.
- **templates/** - Stores Jinja2 templates for dynamic configuration files.
- **files/** - Static files to be copied.
- **vars/** - Contains variable definitions (higher precedence than defaults).
- **defaults/** - Stores default variables for roles.
- **meta/** - Contains role metadata like dependencies.
- **README.md** - Documentation for the role.

---

## 2. Creating an Ansible Role
Roles can be created manually or using the `ansible-galaxy` command:

```bash
ansible-galaxy init my-role
```

This creates a structured role named `my-role`.

---

## 3. Writing a Simple Role
Let's create a **role to install Nginx**.

### Step 1: Define Tasks (`tasks/main.yml`)
```yaml
- name: Install Nginx
  apt:
    name: nginx
    state: present
  become: yes

- name: Start and Enable Nginx Service
  service:
    name: nginx
    state: started
    enabled: yes
```

### Step 2: Define Handlers (`handlers/main.yml`)
```yaml
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

### Step 3: Define Default Variables (`defaults/main.yml`)
```yaml
nginx_port: 80
```

### Step 4: Use the Role in a Playbook
```yaml
- name: Deploy Nginx using Role
  hosts: webservers
  roles:
    - my-role
```

### Real-World Use Case:
- Deploying and managing web servers across multiple environments.

---

## 4. Using Variables in Roles
Roles support dynamic configurations using variables.

### Example (`templates/nginx.conf.j2`):
```nginx
server {
    listen {{ nginx_port }};
    location / {
        root /var/www/html;
    }
}
```

### Define Variables (`vars/main.yml`)
```yaml
nginx_port: 8080
```

This makes the Nginx configuration **dynamic**.

---

## 5. Role Dependencies
Roles can depend on other roles using the `meta/main.yml` file.

### Example:
```yaml
dependencies:
  - role: common-packages
  - role: security-hardening
```

### Real-World Use Case:
- Setting up a common baseline across multiple servers before applying application-specific configurations.

---

## 6. Role Execution Order
Roles execute in the order defined within a playbook:
```yaml
- name: Setup Web Server
  hosts: all
  roles:
    - security
    - database
    - webserver
```

Here, the **security** role runs first, then **database**, followed by **webserver**.

---

## 7. Role Testing with `ansible-playbook`
Run roles using:
```bash
ansible-playbook -i inventory site.yml
```

To test only a role:
```bash
ansible-playbook -i inventory roles/my-role/tests/test.yml
```

---

## 8. Best Practices for Ansible Roles
1. **Follow the directory structure**: Keep tasks, handlers, and variables organized.
2. **Use `defaults/` for overridable variables**: Allows users to override values.
3. **Modularize roles**: Create small, reusable roles for maintainability.
4. **Use `meta/` for dependencies**: Ensures proper execution order.
5. **Test roles independently**: Use test playbooks before production deployment.

---

## Conclusion
Ansible roles enable modular and scalable automation. By structuring tasks into roles, you simplify maintenance and reusability across multiple projects.

---

## References
- [Ansible Roles Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)


# Ansible Handlers -

## Introduction
Ansible Handlers are special tasks triggered by other tasks using the `notify` directive. They are typically used for actions like restarting services, reloading configurations, or sending alerts when a task modifies a system state.

---

## Key Concepts

### 1. **What are Handlers?**
Handlers are similar to regular tasks but execute only when notified by another task. They help in optimizing execution by running actions only when necessary.

### 2. **Defining Handlers**
Handlers are defined under the `handlers` section within a playbook or role. They must have a unique name.

### 3. **Triggering Handlers**
A task triggers a handler using the `notify` directive. If a task does not cause a change, the handler is not executed.

### 4. **Executing Handlers Once**
If multiple tasks notify the same handler, it will run only once per playbook execution.

### 5. **Using `force_handlers`**
By default, handlers do not run if a playbook fails. Using `force_handlers: yes` ensures they execute even if there are failures.

### 6. **Using `meta: flush_handlers`**
By default, handlers execute at the end of a playbook run. Using `meta: flush_handlers` forces them to run immediately.

### 7. **Using `ansible.builtin.*` Modules in Handlers**
Ansible provides built-in modules that can be used within handlers to perform common automation tasks efficiently. Below are key modules and their use cases:

#### **7.1 `ansible.builtin.service`**
Manages system services, commonly used for restarting or reloading services.
```yaml
- name: Restart Apache
  ansible.builtin.service:
    name: apache2
    state: restarted
```

#### **7.2 `ansible.builtin.systemd`**
Used for managing `systemd` services.
```yaml
- name: Restart application service
  ansible.builtin.systemd:
    name: my_app
    state: restarted
```

#### **7.3 `ansible.builtin.command`**
Executes system commands.
```yaml
- name: Reload firewall
  ansible.builtin.command: ufw reload
```

#### **7.4 `ansible.builtin.shell`**
Runs shell commands.
```yaml
- name: Clear cache
  ansible.builtin.shell: echo 3 > /proc/sys/vm/drop_caches
```

#### **7.5 `ansible.builtin.template`**
Deploys Jinja2 templates.
```yaml
- name: Deploy Nginx config
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
```

#### **7.6 `ansible.builtin.copy`**
Copies files and can notify handlers on change.
```yaml
- name: Copy configuration file
  ansible.builtin.copy:
    src: app.conf
    dest: /etc/app/app.conf
  notify: Restart Application
```

#### **7.7 `ansible.builtin.reboot`**
Used for rebooting systems when required.
```yaml
- name: Reboot system
  ansible.builtin.reboot:
  reboot_timeout: 300
```

#### **7.8 `ansible.builtin.file`**
Used for setting file permissions, ownership, and state.
```yaml
- name: Set file permissions
  ansible.builtin.file:
    path: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
```

#### **7.9 `ansible.builtin.lineinfile`**
Ensures a particular line exists in a file.
```yaml
- name: Ensure logging enabled in config
  ansible.builtin.lineinfile:
    path: /etc/app/config.ini
    line: 'enable_logging = true'
```

#### **7.10 `ansible.builtin.user`**
Used to manage user accounts.
```yaml
- name: Create a system user
  ansible.builtin.user:
    name: deploy
    system: yes
```

#### **7.11 `ansible.builtin.group`**
Used to manage groups.
```yaml
- name: Create a group
  ansible.builtin.group:
    name: developers
```

#### **7.12 `ansible.builtin.apt`**
Used for managing Debian-based package installations.
```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
  notify: Restart Nginx
```

#### **7.13 `ansible.builtin.yum`**
Used for managing RedHat-based package installations.
```yaml
- name: Install HTTPD
  ansible.builtin.yum:
    name: httpd
    state: present
```

#### **7.14 `ansible.builtin.dnf`**
Similar to `yum`, but used for newer RedHat-based systems.
```yaml
- name: Install PostgreSQL
  ansible.builtin.dnf:
    name: postgresql
    state: present
```

#### **7.15 `ansible.builtin.get_url`**
Used for downloading files.
```yaml
- name: Download a package
  ansible.builtin.get_url:
    url: https://example.com/package.tar.gz
    dest: /tmp/package.tar.gz
```

#### **7.16 `ansible.builtin.unarchive`**
Extracts compressed files.
```yaml
- name: Extract an archive
  ansible.builtin.unarchive:
    src: /tmp/package.tar.gz
    dest: /opt/software/
    remote_src: yes
```

#### **7.17 `ansible.builtin.stat`**
Checks file properties.
```yaml
- name: Check if a file exists
  ansible.builtin.stat:
    path: /etc/nginx/nginx.conf
  register: nginx_config
```

#### **7.18 `ansible.builtin.cron`**
Manages cron jobs.
```yaml
- name: Schedule a backup job
  ansible.builtin.cron:
    name: "Backup Job"
    minute: "0"
    hour: "2"
    job: "/usr/bin/backup.sh"
```

#### **7.19 `ansible.builtin.mount`**
Manages file system mounts.
```yaml
- name: Mount an NFS share
  ansible.builtin.mount:
    path: /mnt/nfs
    src: 192.168.1.100:/export
    fstype: nfs
    state: mounted
```

#### **7.20 `ansible.builtin.debug`**
Useful for debugging playbooks.
```yaml
- name: Debug variable
  ansible.builtin.debug:
    var: ansible_facts
```

---

## Conclusion
By mastering these `ansible.builtin` modules, you can optimize your Ansible playbooks to be more efficient and maintainable. Handlers ensure that changes take effect only when necessary, reducing unnecessary operations in infrastructure automation.

---

## Additional Resources
- [Ansible Handlers Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_handlers.html)
- [Ansible Built-in Modules](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

