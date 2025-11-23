# conda_install_migrate_env
本專案用於要將conda環境轉換到不同電腦時使用

```bash
conda activate  base
```

## 讀取A電腦 conda所有環境的資訊儲存到*.yml檔案
``` bash
bash ./migrate_envs_read.sh
```

##  從*.yml檔案中來下載到B電腦的conda/miniforge(mamba)上
``` bash
bash ./migrate_envs_install.sh
```
