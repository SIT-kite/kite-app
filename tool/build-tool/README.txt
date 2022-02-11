小风筝App的辅助脚本

预计有如下功能

mirror: 一键换源

dependence: 依赖管理
    get: 获取依赖
    add: 添加依赖

build_runner: 执行 build_runner

git: git 配置
    push: 推送本地提交
    pull: 拉取最新提交
    credential: 开启 git 账户验证信息缓存
    proxy: 配置 git 代理
    
android: Android 开发
    Android 分 abi 编译 release
        arm32: android-arm
        arm64: android-arm64
        x86: android-x86
        x64: android-x64
    default: arm/arm64/x64一键分 abi 编译
    mps: 多架构一键分包编译

linux: Linux Desktop 开发
    linux arm64: 构建 linux-arm64 应用(release)
    linux x64: 构建 Linux-x64 应用(release)
    run liunx release: 运行 Linux-x64 应用(release)
    build && run: 编译并运行 Linux-x64 应用(release)
    run hotload: 热重载模式开发 Linux-x64 应用

windows: Windows Desktop 开发(不支持)
    b: 构建 Windows 应用(release)
    r: 运行 Windows 应用(release)
    br: 编译并运行 Windows 应用(release)
    d: 热重载模式开发 Windows 应用

Web 开发
    不支持

Mac Desktop 开发
    不支持

IOS 开发
    不支持