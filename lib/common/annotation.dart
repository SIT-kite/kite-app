class PlatformSafe {
  final String platform;
  const PlatformSafe(this.platform);
}
/// This method can be called safely on Desktop
const desktopSafe = PlatformSafe("Desktop");