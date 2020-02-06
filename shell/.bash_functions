#!/bin/bash

upgrade_terraform(){
    if [ -z "$1" ];then
        echo "Usage: upgrade_terraform <version>"
        return 1
    fi
    
    version=$1
    
    echo -ne "\e[1;34m[-] Downloading terraform $version...\e[0m"
    wget -q https://releases.hashicorp.com/terraform/"$version"/terraform_"$version"_linux_amd64.zip
    echo -ne "\r\e[1;32m[✔] Download complete\e[0m\e[K\n"
    
    echo -ne "\e[1;34m[-] Unzipping terraform_"$version"_linux_amd64.zip...\e[0m"
    unzip -q terraform_"$version"_linux_amd64.zip
    echo -ne "\r\e[1;32m[✔] Unzip complete\e[0m\e[K\n"
    
    echo -e "\e[1;35m[i] Move terraform to /usr/local/bin/\e[0m"
    sudo mv terraform /usr/local/bin/terraform
    echo -ne "\r\e[1;32m[✔] Moved terraform to /usr/local/bin/\e[0m\e[K\n"
    
    # Cleanup
    echo -e "\e[1;35m[i] Cleanup\e[0m\n"
    rm terraform_"$version"_linux_amd64.zip
    
    terraform --version
}
