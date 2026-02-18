// for some reason Trello uses a hash in the URL instead of a query string
//
//                ▼
// https://lmkw.io#token=some-trello-token
//                ▲
//
// URL hashes don't get transmitted to the server, so instead we rewrite the
// hash to query params
//
//                ▼
// https://lmkw.io?token=some-trello-token
//                ▲

if (location.hash) {
  document.location = `?${location.hash.substring(1)}`
}
