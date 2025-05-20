# 移除 alias 和函数，确保自定义 mvn 生效
unalias mvn 2>/dev/null
unfunction mvn 2>/dev/null

# 设置 Maven 配置 profile
function mvnkj() {
  export MAVEN_SETTINGS_PROFILE=kj
  echo "已切换到 settings-kj.xml 配置文件"
}
function mvnbank() {
  export MAVEN_SETTINGS_PROFILE=bank
  echo "已切换到 settings-bank.xml 配置文件"
}
function mvnmaven() {
  export MAVEN_SETTINGS_PROFILE=maven
  echo "已切换到 settings-maven.xml 配置文件"
}
function mvnali() {
  export MAVEN_SETTINGS_PROFILE=maven
  echo "已切换到 settings-maven.xml 配置文件"
}
function mvndefault() {
  unset MAVEN_SETTINGS_PROFILE
  echo "已切换到默认 settings.xml 配置文件"
}

# 重写 mvn 命令，根据 profile 自动选择 settings 文件
function mvn() {
  local settings_file
  case "$MAVEN_SETTINGS_PROFILE" in
    kj)
      settings_file="$HOME/.m2/settings-kj.xml"
      ;;
    maven)
      settings_file="$HOME/.m2/settings-maven.xml"
      ;;
    bank)
      settings_file="$HOME/.m2/settings-bank.xml"
      ;;
    ali)
      settings_file="$HOME/.m2/settings-ali.xml"
      ;;
    *)
      settings_file="$HOME/.m2/settings.xml"
      ;;
  esac
  command mvn -s "$settings_file" "$@"
}

# preexec 钩子：每次执行命令前检查是否是 mvn
function mvn_preexec_hook() {
  # $1 是即将执行的命令字符串
  if [[ $1 == mvn* ]]; then
    # 这里可以添加你想要的逻辑，比如打印、日志、自动切换配置等
    # 示例：打印当前 settings profile
    if [[ -n $MAVEN_SETTINGS_PROFILE ]]; then
      echo "[mvn钩子] 当前 Maven profile: $MAVEN_SETTINGS_PROFILE"
    else
      echo "[mvn钩子] 当前 Maven profile: default"
    fi
  fi
}
preexec_functions+=(mvn_preexec_hook)

function mvn_usage() {
  echo "mvnkj         # 切换到 settings-kj.xml 配置文件"
  echo "mvnmaven      # 切换到 settings-maven.xml 配置文件"
  echo "mvndefault    # 切换到默认 settings.xml 配置文件"
  echo "mvn <args>    # 自动使用当前激活的 settings 文件"
  echo "mvn_usage     # 显示本帮助信息"
}