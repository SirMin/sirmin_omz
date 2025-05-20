# sirmin_java.plugin.zsh

# 查看已安装的 Corretto JDK 版本
function list_corretto() {
    if ! command -v sdk >/dev/null 2>&1; then
        echo "未检测到 sdkman，请先安装 sdkman"
        return 1
    fi
    sdk list java | grep -i 'corretto' | grep -E '\s+installed' || echo "未检测到已安装的 Corretto JDK"
}

# 切换到指定版本的 Corretto JDK
function use_corretto() {
    local version=$1
    if [[ -z "$version" ]]; then
        echo "请指定 Corretto 版本号，例如 8、11、17"
        return 1
    fi
    if ! command -v sdk >/dev/null 2>&1; then
        echo "未检测到 sdkman，请先安装 sdkman"
        return 1
    fi
    local corretto_id=$(sdk list java | grep -i "amzn" | grep -E "\s+$version\." | grep -E '\s+(installed|local only)' | awk '{print $NF}')
    if [[ -z "$corretto_id" ]]; then
        echo "未找到已安装的 Corretto $version 版本"
        return 1
    fi
    sdk use java $corretto_id
    java -version
}
# 用法帮助
function java_usage() {
    echo "用法说明："
    echo "  use_corretto <版本号> # 切换到指定版本的 Corretto JDK"
    echo "  java8       # 切换到 Corretto 8"
    echo "  java17      # 切换到 Corretto 17"
    echo "  java21      # 切换到 Corretto 21"
    echo "  list_corretto # 显示已安装的所有 Corretto 版本"
    echo "  java_usage      # 显示本帮助信息"

}
alias java8='use_corretto 8'
alias java17='use_corretto 17'
alias java21='use_corretto 21'
