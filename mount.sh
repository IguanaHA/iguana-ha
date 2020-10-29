storageAccountName=$1
fileShareName="repo"
storageAccountKey=$2

#1. Declare and create local mount path
mntPath="/mnt/iguanasharedrepo/repo"

sudo mkdir -p $mntPath

#2. Create credential file to store credentials
if [ ! -d "/etc/smbcredentials" ]; then
    sudo mkdir "/etc/smbcredentials"
fi

smbCredentialFile="/etc/smbcredentials/$storageAccountName.cred"

echo "username=$storageAccountName" | sudo tee $smbCredentialFile > /dev/null
echo "password=$storageAccountKey" | sudo tee -a $smbCredentialFile > /dev/null

#3. Change permissions on credential file to secure access to root
chmod 600 $smbCredentialFile

#4 add file share to fstab
smbPath=//$storageAccountName.file.core.windows.net/$fileShareName

echo "$smbPath $mntPath cifs nofail,vers=2.1,credentials=$smbCredentialFile,serverino" | sudo tee -a /etc/fstab > /dev/null

#4. Mount the file share
sudo mount -a

sudo mkdir -p /mnt/iguanasharedrepo/repo/syncmanager
