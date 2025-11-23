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

# 遍歷剛剛儲存的 YML 檔案，並使用 mamba 建立新環境
#for yml_file in "$YML_DIR"/*.yml; do
#    if [ -f "$yml_file" ]; then
#        echo "正在使用 Mamba 建立環境從 $yml_file..."
#        # 使用 mamba env create，這會自動建立在您的 miniforge3/envs 目錄下
#        mamba env create -f "$yml_file" -y
#        echo "環境建立完成從 $yml_file"
#    fi
#done

echo "--- 所有環境遷移完成！您可以開始測試新環境，然後安全刪除 /home/lab407/anaconda3 ---"
