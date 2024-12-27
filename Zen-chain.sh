#!/bin/bash

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No color (color reset)

 # Make sure the system has the required dependencies
    install_dependencies() {
    echo -e "${YELLOW}Checking and installing required dependencies...${NC}"
    sudo apt-get update
    sudo apt-get install -y jq curl git build-essential
}

 # Make sure Docker and Docker Compose are installed.
    check_docker_installation() {
    if ! command -v docker &>/dev/null; then
        echo -e "${YELLOW}Docker not found. Installing Docker...${NC}"
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
    else
        echo -e "${GREEN}Docker is installed.${NC}"
    fi

    if ! command -v docker-compose &>/dev/null; then
        echo -e "${YELLOW}Docker Compose not found. Installing Docker Compose...${NC}"
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    else
        echo -e "${GREEN}Docker Compose is installed.${NC}"
    fi
}


        # Menu
        echo -e "${YELLOW}Select action:${NC}"
        echo -e "${BLUE}1) Installing node${NC}"
        echo -e "${BLUE}2) Deleting node${NC}"
        echo -e "${BLUE}3) Updating node${NC}"
        echo -e "${BLUE}4) Get session key${NC}"
        echo -e "${BLUE}5) Checking logs (exit logs CTRL+C)${NC}"

        echo -e "${YELLOW}Enter number:${NC} "
        read choice

case $choice in
    1)
        echo -e "${BLUE}Installing the node ...${NC}"

        # Update and install the necessary packages
        sudo apt update && sudo apt upgrade -y
        sleep 1
      

        # Installation
        echo -e "${BLUE}Loading ...${NC}"
        docker pull ghcr.io/zenchain-protocol/zenchain-testnet:v1.1.2

        # Creating a directory
        mkdir -p "$HOME/chain-data"
        chmod -R 777 "$HOME/chain-data"

        # Enter validator name
        echo -e "${BLUE}Let's get started, follow the instructions ...${NC}"
        read -p "Enter validator name (example: HiWorld): " VALIDATOR_NAME

               
               
        # Checking for conflicts with the container name
        echo -e "${BLUE}Checking for existing container with the name 'zenchain'...${NC}"
        if docker ps -a --format '{{.Names}}' | grep -Eq "^zenchain\$"; then
            echo -e "${YELLOW}Container with the name 'zenchain' already exists. Removing it...${NC}"
            docker stop zenchain && docker rm zenchain
            echo -e "${GREEN}Existing container removed successfully.${NC}"
        fi

        # Restarting the node installation
        echo -e "${BLUE}Starting the installation process again...${NC}"
        docker run \
        -d \
        --name zenchain \
        -p 9955:9944 \
        -v ./chain-data:/chain-data \
        --user $(id -u):$(id -g) \
        ghcr.io/zenchain-protocol/zenchain-testnet:v1.1.2 \
        ./usr/bin/zenchain-node \
        --base-path=/chain-data \
        --rpc-cors=all \
        --rpc-methods=Unsafe \
        --unsafe-rpc-external \
        --validator \
        --name=${VALIDATOR_NAME} \
        --bootnodes=/dns4/node-7274523776613056512-0.p2p.onfinality.io/tcp/24453/ws/p2p/12D3KooWDLh2E27VUrXRBvCP6YMz7PzZCVK3Kpwv42Sj1MHJJvN6 \
        --chain=zenchain_testnet

        # Final Conclusion
        echo -e "${GREEN}The installation is complete and the node is running! After installation, get the session key by restarting the script with the command (./Zen-chain.sh)${NC}"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${CYAN}Discord-longlifemmm${NC}"
        echo -e "${CYAN}Telegram-https://t.me/swapapparat${NC}"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
               ;;
    
    2)
        echo -e "${BLUE}Deleting a node ...${NC}"

        # Stop and delete
        docker stop zenchain
        docker rm zenchain
        sleep 1
              
        
        echo -e "${GREEN}Node successfully deleted!${NC}"

        # Final conclusion
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${CYAN}Discord-longlifemmm${NC}"
        echo -e "${CYAN}Telegram-https://t.me/swapapparat${NC}"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        ;;
    4) 
        echo -e "${BLUE}Create a session key ...${NC}"    
        # Key creation
        curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9955

        echo -e "${GREEN}Keep the key in a safe place!${NC}"
    ;;
    
    5)
        docker logs -f zenchain
        
        
        
        ;;
        
        3)
        echo -e "${BLUE}Updating the node ...${NC}"

        # Update and install the necessary packages
        sudo apt update && sudo apt upgrade -y
        sleep 1
      

        # Installation
        echo -e "${BLUE}Loading ...${NC}"
        docker pull ghcr.io/zenchain-protocol/zenchain-testnet:v1.1.2

        # Removing a container
        docker stop zenchain
        docker rm zenchain
        sleep 1
              
        # Enter validator name
        echo -e "${BLUE}Let's get started, follow the instructions ...${NC}"
        read -p "Enter validator name (example: HiWorld): " VALIDATOR_NAME

        # Node installation
        docker run \
  -d \
  --name zenchain \
  -p 9955:9944 \
  -v ./chain-data:/chain-data \
  --user $(id -u):$(id -g) \
  ghcr.io/zenchain-protocol/zenchain-testnet:v1.1.2 \
  ./usr/bin/zenchain-node \
  --base-path=/chain-data \
  --rpc-cors=all \
  --rpc-methods=Unsafe \
  --unsafe-rpc-external \
  --validator \
  --name=${VALIDATOR_NAME} \
  --bootnodes=/dns4/node-7274523776613056512-0.p2p.onfinality.io/tcp/24453/ws/p2p/12D3KooWDLh2E27VUrXRBvCP6YMz7PzZCVK3Kpwv42Sj1MHJJvN6 \
  --chain=zenchain_testnet


        # Final Conclusion
        echo -e "${GREEN}The update is completed and the node is running!${NC}"
        ;;
        
esac
