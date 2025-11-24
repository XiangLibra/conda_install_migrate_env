#!/bin/bash

# 定義舊 Anaconda 環境的根目錄
OLD_ANACONDA_ENVS_DIR="~/anaconda3/envs"

# 定義儲存 YML 檔案的目錄
YML_DIR="./env_yamls"
mkdir -p "$YML_DIR"

echo "--- 開始匯出所有環境的 YAML 檔案 ---"

# 遍歷舊 Anaconda 目錄下的所有子目錄
for env_path in "$OLD_ANACONDA_ENVS_DIR"/*; do
    if [ -d "$env_path" ]; then
        env_name=$(basename "$env_path")
        yml_file="$YML_DIR/$env_name.yml"

        echo "正在匯出環境: $env_name 到 $yml_file"

        # 使用絕對路徑啟用環境並匯出
        # 注意: 使用 conda activate 是因為它是 shell 函數，不能直接用在腳本中
        # 我們改用 conda run --prefix 來執行 export 指令
        conda run --prefix "$env_path" conda env export > "$yml_file"

        # 1. 修正 name: 後面的長路徑為乾淨的名稱
        sed -i "s|name: .*|name: $env_name|" "$yml_file"

        # 2. 移除可能重複的 conda-forge (如果之前匯出時已有)
#        sed -i '/- conda-forge/d' "$yml_file"
        sed -i '/channels:/,/dependencies:/s/  - .*//' "$yml_file"

        # 3. 確保 channels 列表包含 conda-forge，並放在 defaults 之上
        #    我們尋找 "channels:" 這行，並在它下面插入標準的 conda-forge 列表
        sed -i '/channels:/a\  - conda-forge\n  - defaults' "$yml_file"

        echo "匯出完成: $env_name"
    fi
done

echo "--- 所有 YAML 檔案匯出完成，開始使用 Mamba 重建環境 ---"

# 確保您在 Miniforge 的 base 環境中
mamba activate base
