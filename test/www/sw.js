const CACHE_NAME = 'herzschlag-cache-v1';
const CORE_FILES = [
  './',
  './index.html',
  './manifest.json',
  './three.min.js',
  './LuminosityShader.js',
  './CopyShader.js',
  './LuminosityHighPassShader.js',
  './MaskPass.js',
  './EffectComposer.js',
  './RenderPass.js',
  './ShaderPass.js',
  './UnrealBloomPass.js',
  './icon-192.png',
  './icon-512.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(CORE_FILES))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  // Firebase- und Google-Font-Anfragen NIE cachen, immer live laden
  if (url.hostname.includes('gstatic.com') || url.hostname.includes('googleapis.com') || url.hostname.includes('firebaseio.com')) {
    return;
  }
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        if (response && response.status === 200 && event.request.method === 'GET') {
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone));
        }
        return response;
      }).catch(() => cached);
    })
  );
});
