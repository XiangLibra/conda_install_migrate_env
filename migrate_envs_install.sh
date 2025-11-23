#!/bin/bash

# 定義舊 Anaconda 環境的根目錄
OLD_ANACONDA_ENVS_DIR="~/anaconda3/envs"

# 定義儲存 YML 檔案的目錄
YML_DIR="./env_yamls"
mkdir -p "$YML_DIR"



echo "--- 所有 YAML 檔案匯出完成，開始使用 Mamba 重建環境 ---"

# 確保您在 Miniforge 的 base 環境中
#mamba activate base

# 遍歷剛剛儲存的 YML 檔案，並使用 mamba 建立新環境
for yml_file in "$YML_DIR"/*.yml; do
    if [ -f "$yml_file" ]; then
        echo "正在使用 Mamba 建立環境從 $yml_file..."
        # 使用 mamba env create，這會自動建立在您的 miniforge3/envs 目錄下
        mamba env create -f "$yml_file" -y
        echo "環境建立完成從 $yml_file"
    fi
done

echo "--- 所有環境遷移完成！您可以開始測試新環境，然後安全刪除 /home/lab407/anaconda3 ---"
