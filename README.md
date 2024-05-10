# IRLDockerAppLinuxLocalVPS - Expose VPS as a Local Device

## Overview

The `IRLDockerAppLinuxLocalVPS` project allows users to integrate a Virtual Private Server (VPS) into their local network environment as if it were a physical device located on-premises. 

This integration is achieved through the use of Wireguard VPN, which establishes a secure tunnel between the VPS and the local network. 

The primary benefit of this setup is that it enables local network devices to interact with the VPS just like any other local resource, which can be crucial for applications that require low-latency access or are sensitive to data sovereignty issues.

## Purpose

This solution is particularly useful in scenarios where businesses or developers need to extend their local infrastructure securely to include cloud resources. 

For instance, testing environments, staging areas for software development, or even home automation systems can be enhanced by incorporating a VPS seamlessly into the local network. 

It ensures that services hosted on a VPS, such as web applications, development tools, or databases, are accessible within the local network without exposing them directly to the internet or multiplying configuration on each local network devices.


## Prerequisites
- **Wireguard**: Your VPS must have Wireguard installed and configured.
  - Installation guide: [Wireguard Installation](https://www.wireguard.com/install/)
- **Docker**: Docker must be install on the machine.
- **Make**: Required to execute the make commands.
  - Install Make: `apt-get install build-essential`
- **Linux distributions ONLY**:
 ⛔️ WARNING: This project only works with Linux distributions as it uses `macvlan` with the local network interface `eth0`.
``bash docker network create -d macvlan --subnet=${LOCAL_SUBNET} --gateway=${LOCAL_GATEWAY} -o parent=eth0 pub_net || true
``

## Configuration Steps

### Step 1: Configuration Wireguard

Place the `wg0.conf` file in this folder with the connection details to your VPS and add the following lines to the `[Interface]` section of `wg0.conf`:

```bash
PostUp = /etc/wireguard-redir/init.sh
PostDown = /etc/wireguard-redir/postdown.sh
```

### Step 2: Install the App

Run the following command to install the app:

```bash
make install
```

You will receive an output with all the commands available for your app. Ex.:
```sh
🚀 Usage: 

<Your service name> [ env | up | down | log | top | build | restart | unintall ]

  <Your service name> env       # Create the required wg0.environment file
  <Your service name> up        # Bring the Stack up
  <Your service name> down      # Tear down the Stack
  <Your service name> log       # Stack log with follow. [Ctrl-C] to exit. Will not tear down the Stack
  <Your service name> top       # Display the running processes
  <Your service name> build     # Build the required Docker
  <Your service name> restart   # Same as runing <Your service name> down && <Your service name> up
  <Your service name> uninstall # Same as runing <Your service name> down; make uninstall. Will require to install the service again with make
```

#### In the future, if you wish to Uninstall 
```bash
make uninstall
## OR
<Your service name> uninstall
```

Uninstall will not remove your confirgurations file, `wg0.conf` & `wg0.environment`


### Step 3: Setup and Configure `wg0.environment`

- Start by creating a new `wg0.environment` file by running:

```bash
<Your service name> env
```

- The app created an environment file `wg0.environment` with the following configurations, please edit it to fit your need:

#### Wireguard Server/Gateway IP

- **Description**: Specifies the Wireguard server or gateway IP address over the VPN.
- **Example**: If your Wireguard interface IP ends with `.1`, it is usually the same as the `[Interface]` in Wireguard configuration.

```bash
WG_ROUTER_IP=<Wiregard gateway IP>
```

**Example**: 
```bash
WG_ROUTER_IP=192.168.188.1
```
- Here we assume this Address in wg0.conf 
```
[Interface]
Address = 192.168.188.39/32
```

#### Local Network Configuration

Configure settings for the local machine on your network:

- **Local IP Address**: Static IP of your machine on the local network.
- **Local MAC Address**: MAC address of your machine, where the segments are a hex number between `00` and `ff`.
- **Local Hostname**: Hostname of your machine on the local network.
- **Local Subnet**: Typically the gateway IP ending with `.0` and `/24` to denote the entire subnet mask.
- **Local Gateway**: IP address of your network gateway.

**Example**: 
```bash
LOCAL_IPADRESS=192.168.10.39
LOCAL_MAC_ADRESS=40:6C:8F:20:10:66
LOCAL_HOSTNAME=MYVPS
LOCAL_SUBNET=192.168.10.0/24
LOCAL_GATEWAY=192.168.10.1
```
- Here we assume:
    - your router has an ip of `192.168.10.1`
    - `MYVPS` will have a static address (free on the network) of `192.168.10.39`
    - your local subnet range from `192.168.10.1` to `192.168.10.255` -> `192.168.10.0/24`
    - you want to identify `MYVPS` on the network with a MAC Address: `40:6C:8F:20:10:66`

#### Network Ports Exposed on the Distant Machine to your Local network

Specify ports accessible on the local machine from a distant network:

- **Ports**: A space-separated list of port numbers.
  - **Example**: `22, 80, 443, 10000`

```bash
DISTANT_OPEN_PORTS=22 80 443 10000
```

#### Network Ports Exposed from Local IPs to the Distant Machine (VPS)

Define the local IPs and ports that will be accessible on the distant machine through the specified Wireguard interface address:

- **Format**: `<exposed on wg0 network>,<local ip>,<local port>`

```bash
LOCAL_NETWORK_REDIRECTS=( 80:<Local IP>:80 443:<Local IP>:443 )
```

**Example**: 

```bash
LOCAL_NETWORK_REDIRECTS=( 80:192.168.178.27:80 443:192.168.178.27:443 )
```

- To make `192.168.178.27:80` accessible via `192.168.92.10:80` on the Wireguard network, therfore from the VPS. 
- Here we assume this Address in wg0.conf 
```
[Interface]
Address = 192.168.188.39/32
```
