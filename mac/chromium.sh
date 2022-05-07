#!/bin/bash

echo "温馨提醒：请使用 root 权限运行该脚本！！！！"
echo "备份 Chromium "
mv /Applications/Chromium.app/Contents/MacOS/Chromium /Applications/Chromium.app/Contents/MacOS/Chromium_bin

cd ~
echo "开始配置 Chromium API Keys"
sudo tee /Applications/Chromium.app/Contents/MacOS/Chromium <<-'EOF'
#!/bin/bash
# Set up environment variables
export GOOGLE_API_KEY="AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k"
export GOOGLE_DEFAULT_CLIENT_ID="811574891467.apps.googleusercontent.com"
export GOOGLE_DEFAULT_CLIENT_SECRET="kdloedMFGdGla2P1zacGjAQh"

# Launch Chromium
/Applications/Chromium.app/Contents/MacOS/Chromium_bin
EOF

sudo chmod +x  /Applications/Chromium.app/Contents/MacOS/Chromium

echo "Chromium 添加 API Keys 完成！！！"