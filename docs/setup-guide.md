# Steps to Run a Node Engram

### Install Necessary Dependencies:
Start by updating your system and installing required dependencies:

```console
$ sudo apt update
$ sudo apt upgrade
$ sudo apt install software-properties-common
$ sudo add-apt-repository -y ppa:ethereum/ethereum
$ sudo apt update
$ sudo apt install geth
```

Clone the repository Engram Genesis Spec: 
```console
$ git clone https://github.com/engram-network/tokio-node
$ cd tokio-node
$ git checkout betanet
```

### Initialize the Execution Node:
Initialize your execution node by creating a data directory and initializing it:

```console
$ mkdir -p ~/engram-node/data
$ cd ~/engram-node
$ geth --datadir=data init /path/to/genesis.json
```
Replace [/path/to/genesis.json](https://github.com/engram-network/tokio-node/blob/betanet/tokio-spec/custom_config_data/genesis.json) with the actual path to your Engram Genesis file.

### Create a Configuration Execution File:
Create a systemd service config file to configure the execution node service. Paste the following service configuration into the file. Exit and save once done (Ctrl + X, Y, Enter).

```console
[Unit]
Description=Engram Execution Client - Geth (Tokio)
After=network.target
Wants=network.target

[Service]
User=root
Group=root
Type=simple
Restart=always
RestartSec=5s
TimeoutStopSec=180
ExecStart=/usr/local/bin/geth \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> 

[Install]
WantedBy=default.target
```
If you are not sure or unclear about the command from geth you can use the systemd config from the repository that is already available. [Engram Execution Client Systemd](https://github.com/engram-network/tokio-node/tree/betanet/systemd)

### Run the Execution Node:
Start the Execution node using the configuration file you created reload systemd to reflect the changes and start the service. Check status to make sure it’s running correctly.

```markdown
$ sudo systemctl daemon-reload
$ sudo systemctl start geth.service
$ sudo systemctl status geth.service
```

You can watch the live messages from your Geth node logs using this command. Make sure nothing suspicious shows up in your logs.

```console
$ sudo journalctl -f -u geth.service -o cat | ccze -A
```
Press Ctrl + C to stop showing those messages.

### Adding Peer:
Access the Console: Open a terminal window and connect to your Engram node's console. You can usually do this by running:

```markdown
$ geth attach http://localhost:8545
$ admin.addPeer("enode://<peer_enode_url>@<peer_ip>:<peer_port>")
$ admin.addTrustedPeer("enode://<peer_enode_url>@<peer_ip>:<peer_port>")
```
Please refer to all public Engram [Bootnodes Here](https://github.com/engram-network/tokio-node/blob/betanet/tokio-spec/custom_config_data/bootstrap-data.txt)

After you add public engram bootnodes, you need to see your static peer whether it has connected and joined the engram network or is still in the queue. you can utilize the geth command as follows:
```console
$ > admin.peers
[{
    caps: ["eth/66", "eth/67", "eth/68", "snap/1"],
    enode: "enode://1a7ee57bf5fc6b151c2a1d917a10db5fade2efd3bddf88bfa4830112cacb59ad3ca59147b48026d8b8cb5ae362e15b61e72974507c5a4de667112f133c3171c5@18.142.177.161:51850",
    id: "8dfca9b32dcdf3a1e3206bb1ad01859b32038240388a972f67ec577852a6a336",
    name: "Geth/Enterprise-Engram/v1.12.2-stable/linux-amd64/go1.21.1",
    network: {
      inbound: true,
      localAddress: "172.31.19.20:30303",
      remoteAddress: "18.142.177.161:51850",
      static: false,
      trusted: false
    },
    protocols: {
      eth: {
        version: 68
      },
      snap: {
        version: 1
      }
    }
}]
```
After you add peers to the engram node, the static peers in your geth will change from **static=0** to **static=1** which means that the public bootnodes of engram accept your node's request to join the network.

### Configuring Beacon Node
Start by updating your system and installing required dependencies:

#### **Build From Source**
```console
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ sudo apt install -y git gcc g++ make cmake pkg-config llvm-dev libclang-dev clang
$ git clone https://github.com/sigp/lighthouse.git
$ cd lighthouse
$ git checkout stable
$ make
```
Compilation may take around 10 minutes. Installation was successful if lighthouse --help displays the command-line documentation.
If you run into any issues, please check the [Troubleshooting](https://lighthouse-book.sigmaprime.io/installation-source.html#troubleshooting) section, or reach out to us on [Discord](https://discord.gg/cyAszAh).

#### **Pre-built Binaries**
Each Lighthouse release contains several downloadable binaries in the "Assets" section of the release. You can find the releases on [Here](https://github.com/sigp/lighthouse/releases).

```console
x86_64-unknown-linux-gnu: AMD/Intel 64-bit processors (most desktops, laptops, servers)
aarch64-unknown-linux-gnu: 64-bit ARM processors (Raspberry Pi 4)
x86_64-apple-darwin: macOS with Intel chips
x86_64-windows: Windows with 64-bit processors
```

Usage
```console
$ cd ~/engram-node
$ curl -LO https://github.com/sigp/lighthouse/releases/download/v4.4.1/lighthouse-v4.4.1-x86_64-unknown-linux-gnu-portable.tar.gz
$ tar -xvf lighthouse-v4.4.1-x86_64-unknown-linux-gnu-portable.tar.gz
$ sudo mv lighthouse /usr/local/bin
$ lighthouse --version

Lighthouse v4.4.1-2841f60
BLS library: blst-portable
SHA256 hardware acceleration: false
Allocator: jemalloc
Profile: maxperf
Specs: mainnet (true), minimal (false), gnosis (true)
```
### Create a Configuration Beacon File:
Create a systemd service config file to configure the execution node service. Paste the following service configuration into the file. Exit and save once done (Ctrl + X, Y, Enter).

```markdown
[Unit]
Description=Lighthouse Ethereum Client Beacon Node (Goerli)
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=lighthousebeacon
Group=lighthousebeacon
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/lighthouse bn \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> \
  <YOUR COMMAND LINE HERE> 

[Install]
WantedBy=multi-user.target
```
If you are not sure or unclear about the command from lighthouse you can use the systemd config from the repository that is already available. [Engram Beacon Client Systemd](https://github.com/engram-network/tokio-node/tree/betanet/systemd)

**Please note, you need an ENR (Ethereum Node Record) from engram to connect and join the consensus network just like network execution requires public bootnodes.**

### Run the Beacon Node:
Start the Beacon node using the configuration file you created reload systemd to reflect the changes and start the service. Check status to make sure it’s running correctly.

```markdown
$ sudo systemctl daemon-reload
$ sudo systemctl start beacon.service
$ sudo systemctl status beacon.service
```

You can watch the live messages from your beacon node logs using this command. Make sure nothing suspicious shows up in your logs.

```console
$ sudo journalctl -f -u beacon.service -o cat | ccze -A
```
Press Ctrl + C to stop showing those messages.

**After the execution network and consensus network have connected and joined the engram network, your node will automatically synchronize all the databases from the engram, wait until everything is synchronized and take the last block of events.**
