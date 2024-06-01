import 'package:iphoto/data/protocol.dart';
import 'package:iphoto/utils.dart';

Future<Map<ResourceType, List<String>>> getResources() async {
  // Get resource info
  List resInfo = await getResInfo();

  // Get resource by id
  List<Future<PathResource>> list = [];
  list.addAll(resInfo.map((e) {
    var record = e as Map<String, dynamic>;
    return getRes(
      record['id'],
      record['name'],
      ResourceType.values.byName(record['res_type']),
    );
  }));

  List<PathResource> pathRes = await list.wait;

  // Establish map of media type
  Map<ResourceType, List<String>> resMap = {
    ResourceType.image: [],
    ResourceType.video: [],
    ResourceType.thumbnail: [],
  };
  for (final r in pathRes) {
    logger.i("Path to resource: ${r.resPath}");

    resMap[r.resType]!.add(r.resPath);
  }

  return resMap;
}
