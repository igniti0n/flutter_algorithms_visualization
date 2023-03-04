'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "8347ceefb3c91c3a19f0e29370ceb902",
"version.json": "3e0e01d94dded47ba6e1f7af57b62992",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"assets/FontManifest.json": "d265dcdeff5535502bc3368279fbf477",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/assets/tutorial_controls.gif": "a3dc65dd1032db4c1a2ebd1b6df02570",
"assets/assets/svg/play_button.svg": "ac72af6d9e9bdb49069177f052b3d106",
"assets/assets/svg/stopwatch.svg": "59b4d66cd5813f4cdb87808947b44cbd",
"assets/assets/svg/github_logo.svg": "8dcc6b5262f3b6138b1566b357ba89a9",
"assets/assets/svg/eraser.svg": "0150f72630c6489fe5b305cc29958aac",
"assets/assets/svg/route_tracked.svg": "8fd6a2414ea053b1fd72712134d81d85",
"assets/assets/svg/eraser_colored.svg": "5b91c4cc4665f363e698cd0cd4e069f2",
"assets/assets/svg/flag.svg": "84b0043fdf97f09cc7707ca09e559cb0",
"assets/assets/svg/brick.svg": "1112e096a0fedf27619175edffcc1565",
"assets/assets/a_star.gif": "bd738243e4c17fb5edd7ed80d73e2ecc",
"assets/assets/dfs.gif": "6212d72446ec414849ad64f58cd227c9",
"assets/assets/bfs.gif": "dc0a2c2a7390485b8ba8b699b078475f",
"assets/assets/lotties/path_finding.json": "2f07db50ccd61278290467af38cd0d5f",
"assets/assets/lotties/flag_with_sparkle.json": "bef436011b19767a5a10c8ec7e8b72a8",
"assets/assets/lotties/delete.json": "b519536b05b6fd5a4d54993cd5ac32f8",
"assets/assets/lotties/maze.json": "5b2e8daea15162fe2de3bbb3fda9b2ef",
"assets/assets/dijkstra.gif": "846d9caf3314cfd8b767686582f65ae4",
"assets/assets/images/cost_controls.png": "bedec3f171c930af3906ab4f2ad4b73e",
"assets/assets/images/algorithm_choosing.png": "3d4d4ac4911b4585ad16fb2a3589cd78",
"assets/assets/images/time_control.png": "0a343038b4a97c5c11cdc427daa73c35",
"assets/assets/images/delete_reset.png": "a6db029631895171f61e340433d29d3b",
"assets/assets/fonts/UnitRoundedOTBold.otf": "4e069f9bb156570d898e3d42e5847e63",
"assets/assets/fonts/UnitRoundedOT.otf": "1826d36cf3701156affb199096a63432",
"assets/assets/maze.gif": "210d7950e21a0af8370b8f20b6273a50",
"assets/NOTICES": "daa1ba77a35e726aac84398a48869eca",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.json": "355b518ca22a13bab8d0dcd709684eb8",
"index.html": "53cca2435af4f1a1edaa1ad6e1a67207",
"/": "53cca2435af4f1a1edaa1ad6e1a67207",
"main.dart.js": "19909a2cae081d281073bbd5b4612300",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
