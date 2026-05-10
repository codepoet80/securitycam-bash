const CACHE = 'securitycam-v1';
const SHELL = ['./style.css', './icon.png', './icon-256.png', './spinner.gif', './offline.png'];

self.addEventListener('install', e => {
    e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)));
    self.skipWaiting();
});

self.addEventListener('activate', e => {
    e.waitUntil(caches.keys().then(keys =>
        Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ));
    self.clients.claim();
});

self.addEventListener('fetch', e => {
    // Always fetch camera images fresh; serve shell assets from cache
    if (e.request.url.match(/\.jpg/)) return;

    e.respondWith(
        caches.match(e.request).then(cached => cached || fetch(e.request))
    );
});
