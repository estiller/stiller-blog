# Download the release binary
wget -qO/usr/bin/azurefile-dockervolumedriver https://github.com/Azure/azurefile-dockervolumedriver/releases/download/v0.5.1/azurefile-dockervolumedriver
chmod +x /usr/bin/azurefile-dockervolumedriver

# Service configuration
wget -qO/etc/default/azurefile-dockervolumedriver https://raw.githubusercontent.com/Azure/azurefile-dockervolumedriver/master/contrib/init/systemd/azurefile-dockervolumedriver.default
sed -i "s/youraccount/$1/g" /etc/default/azurefile-dockervolumedriver
sed -i "s/yourkey/$2/g" /etc/default/azurefile-dockervolumedriver

# Service file
wget -qO/etc/systemd/system/azurefile-dockervolumedriver.service https://raw.githubusercontent.com/Azure/azurefile-dockervolumedriver/master/contrib/init/systemd/azurefile-dockervolumedriver.service

# Reload and enable driver
systemctl daemon-reload
systemctl enable azurefile-dockervolumedriver
service azurefile-dockervolumedriver start
systemctl status azurefile-dockervolumedriver
