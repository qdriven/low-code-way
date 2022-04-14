# ToolJet Environment 

|Variable|Description|Required|Comments|
|--------|-----------|-----|---------|
|TOOLJET_HOST|Public URL|Yes|公网地址|
|LOCKBOX_MASTER_KEY|Lockbox存储Database密码|Yes|openssl rand -hex 32|
|SECRET_KEY_BASE||Yes|openssl rand -hex 64|