# **Steps to install Terraform on Ubuntu (WSL2)**

Open your WSL2 terminal and run the following commands:

```bash
sudo apt update && sudo apt upgrade -y
```

Install required packages: Terraform requires curl to download the installer. If you don’t have it, install it with:

```bash
sudo apt install -y curl gnupg software-properties-common
```

Add the HashiCorp GPG key: Terraform is developed by HashiCorp. Add their official GPG key:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

Add the official HashiCorp repository: Add the HashiCorp software repository to your system's sources:

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Update the package index and install Terraform: Run the following commands:

```bash
sudo apt update
sudo apt install terraform
```

Verify the installation: After the installation is complete, verify that Terraform was installed correctly by running:

```bash
terraform --version
```
