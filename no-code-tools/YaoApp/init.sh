#!/bin/sh
curl -fsSL https://website.yaoapps.com/install.sh | bash

mkdir -p yaoapps-demos
cd yaoapps-demos
yao init

# yao migrate
# yao run flows.setmenu
# yao start


