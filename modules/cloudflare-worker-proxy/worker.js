// Service-worker-syntax Cloudflare Worker (NOT an ES module — avoids the main_module schema).
//
// Bridges an HTTP-only biometric device to our HTTPS prod API. The device is hard-wired to hit
// a fixed root path (/iclock/...). Our API serves the same handlers under /biometric, so we
// rewrite the path and forward to the prod API Gateway custom domain over HTTPS.
addEventListener('fetch', (event) => {
  event.respondWith(handle(event.request));
});

async function handle(request) {
  const url = new URL(request.url);

  // Device hits the fixed root path /iclock/... ; our API serves it under /biometric.
  if (url.pathname === '/iclock' || url.pathname.startsWith('/iclock/')) {
    url.pathname = '/biometric' + url.pathname;
  }

  url.hostname = 'api-prod.itsmyskool.com'; // existing prod API Gateway custom domain
  url.protocol = 'https:';
  url.port = '';

  return fetch(new Request(url, request)); // Host header derives from url.hostname
}
