#!/bin/bash

# Exit on any error
set -e

# Define variables
NETWORK_NAME="custom_network"
SUBNET="192.168.1.0/24"

BASE_IP="192.168.1.101"
#CONTAINER_NAMES=("vm1" "vm2" "vm3")
#IMAGES=("centos/systemd:latest" "alpine:latest" "ubuntu:latest")

CONTAINER_NAMES=("vm1" "vm2" "vm3")
IMAGES=("ubuntu:latest" "centos:latest" "alpine:latest")


#CONTAINER_NAMES=("vm1")
#IMAGES=("ubuntu:latest")

# Function to create Docker network
create_network() {
    echo "Creating Docker network: $NETWORK_NAME with subnet: $SUBNET"
    docker network create --subnet="$SUBNET" "$NETWORK_NAME" || echo "Network already exists."
}

# Function to calculate IP address
calculate_ip() {
    local base_ip=$1
    local increment=$2
    echo "$base_ip" | awk -v inc="$increment" -F. '{print $1"."$2"."$3"."$4+inc}'
}

# Function to create and configure a container
create_container() {
    local name=$1
    local image=$2
    local ip=$3

    echo "Creating container: $name with image: $image and IP: $ip"
    #docker run -d --name "$name" --net "$NETWORK_NAME" --ip "$ip" "$image" sleep infinity

    echo "Configuring SSH on $name"
    case $image in
        alpine:latest)
            docker run -d --name "$name" --net "$NETWORK_NAME" --ip "$ip" "$image" sleep infinity		
            docker exec "$name" sh -c "
                apk add --no-cache openssh &&
                mkdir -p /run/sshd &&
                ssh-keygen -A &&
                echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&
                #passwd -d root &&
                echo root:password | chpasswd &&
		apk add --no-cache python3 &&
                /usr/sbin/sshd

            "
            ;;
        centos:latest)
	    #docker run -d --name "$name" --net "$NETWORK_NAME" --ip "$ip" --privileged --cgroups=host -v /sys/fs/cgroup:/sys/fs/cgroup:ro "$image" /usr/sbin/init	
            docker run -d --name "$name" --net "$NETWORK_NAME" --ip "$ip" "$image" sleep infinity		
            docker exec "$name" sh -c "
                sed -i 's|mirrorlist=http://mirrorlist.centos.org|#mirrorlist=http://mirrorlist.centos.org|g' /etc/yum.repos.d/*.repo
                sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/*.repo
	        yum install -y openssh-server &&
		mkdir -p /var/run/sshd &&
                #systemctl enable sshd &&
                #systemctl start sshd &&
                echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&
                echo root:password | chpasswd
		ssh-keygen -A
		/usr/sbin/sshd -D &
            "
            ;;
        ubuntu:latest)
	    docker run -d --name "$name" --net "$NETWORK_NAME" --ip "$ip" "$image" sleep infinity	
            docker exec "$name" bash -c "
                apt update &&
                apt install -y openssh-server &&
                service ssh start &&
                echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config &&
                echo root:password | chpasswd &&
                service ssh restart
            "
            ;;
    esac
    echo "Container $name is configured and running."
}

# Main script logic
create_network

# Iterate over containers to create and configure them
for i in "${!CONTAINER_NAMES[@]}"; do
    IP=$(calculate_ip "$BASE_IP" "$i")
    create_container "${CONTAINER_NAMES[$i]}" "${IMAGES[$i]}" "$IP"
done

# Display container details
echo "Containers are up and running:"
docker ps

echo "Container IPs:"
for name in "${CONTAINER_NAMES[@]}"; do
    docker inspect "$name" | grep IPAddress
done

echo "Setup complete. You can now use these containers with Ansible."

