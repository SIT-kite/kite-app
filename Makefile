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

# 通过adb安装到 Android 手机
adb_install:
	# TODO
	adb install ./xxx.apk

# 构建 Windows
build_windows:
	flutter build windows

# 运行 Windows 应用
run_windows:
	./build/windows/runner/Release/kite.exe

# 构建Linux版本应用
build_linux:
	flutter build linux

# 运行Linux版本应用
run_linux:
	# 只有在英文环境才能正常显示中文(flutter bug)
	export LC_ALL=en_US.UTF-8
	./build/linux/x64/release/bundle/kite



all: clean get generate build_android build_linux
