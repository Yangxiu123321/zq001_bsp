#!/bin/bash

# zq001 BSP 发布脚本
# 此脚本创建一个新的 zq001_bsp_rls 目录，包含 release 版本的 package.yaml
# 使用方法：./scripts/release.sh

set -e

RELEASE_DIR="zq001_bsp_rls"

echo "开始发布流程..."

# 创建发布目录
rm -rf "$RELEASE_DIR"
echo "创建发布目录: $RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# 复制整个项目结构到发布目录
echo "复制项目文件到 $RELEASE_DIR..."
rsync -av --exclude="$RELEASE_DIR" . "$RELEASE_DIR/" --exclude-from=<(printf '%s\n' '.git' 'zq001_bsp_rls' 'patches')
# repos 在仓库中是软链接，release 目录中改为实体文件
rm -f "${RELEASE_DIR}/scripts/repos" && cp -fL "./scripts/repos" "${RELEASE_DIR}/scripts/repos"


################################################################################
########################## 特殊处理 #############################################
################################################################################

# 替换配置文件
mv "${RELEASE_DIR}/scripts/repo_rls_config" "${RELEASE_DIR}/scripts/repo_config"

########################## manifest ############################################
echo "移除 manifest 中内部 xml 文件"
rm -f "${RELEASE_DIR}/manifest/sophcam_app.xml"
rm -f "${RELEASE_DIR}/manifest/sophcam_bsp_golden.xml"
rm -f ${RELEASE_DIR}/manifest/git_version_sophcam*
rm -rf "${RELEASE_DIR}/manifest/release"

########################## patches #############################################
echo "更改补丁文件夹名称"
mv ${RELEASE_DIR}/patches_rls ${RELEASE_DIR}/patches

########################## scripts #############################################
echo "移除发布脚本"
rm -f "${RELEASE_DIR}/scripts/release.sh"


################################################################################
########################## 发布完成 #############################################
################################################################################
echo ""
echo "发布完成!"
echo "发布目录: $RELEASE_DIR"
echo "同步到github仓库：rsync -av --delete --exclude .git dc309_bsp_rls/ ../github_dc309_bsp/"
