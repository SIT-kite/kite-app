# 清除build目录
clean:
	flutter clean

# 获取依赖
get:
	flutter pub get

# 运行build_runner生成代码
generate:
	flutter pub run build_runner build --delete-conflicting-outputs

# 构建android平台应用
build_android:
	flutter build apk --split-per-abi --target-platform android-arm64

# 构建Linux版本应用
build_linux:
	flutter build linux
