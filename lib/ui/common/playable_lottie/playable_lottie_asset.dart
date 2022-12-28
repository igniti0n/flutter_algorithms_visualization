enum PlayableLottieAsset {
  goalFlag,
  trashBin,
}

extension PlayableLottieAssetUtils on PlayableLottieAsset {
  static const String _basePath = 'assets/lotties/';
  static const _paths = {
    PlayableLottieAsset.goalFlag: '${_basePath}flag_with_sparkle.json',
    PlayableLottieAsset.trashBin: '${_basePath}delete.json'
  };

  String get pathToAsset => _paths[this]!;
}
