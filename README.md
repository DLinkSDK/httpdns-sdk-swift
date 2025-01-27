# HttpDNS

## 1: Get the SDK

### (1) Add Pod source in you Pod file

```Ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/DLinkSDK/deeplink-dev-specs.git'
```

### (2) add dependency
```Ruby
pod 'HttpDNS'
```

## 2: Usage

### (1) Create HttpDNS Fetcher
```swift
let dnsFetcher: HttpDNSFetcher = .init(identifier: "mainDNSFetcher", queue: .init(identifier: "mainDNSFetcher", queue: .global()))
```
If you want to http dns work on your prefer queue, pass the queue to the initialze method

### (2) Preload HttpDNS for domains
```swift
let domains: [String] = [
    "google.com",
    "youtube.com"
]
// preload some domains
dnsFetcher.preload(domains: domains)
```
### (3) Get DNS info for domain
If dns info for domain has been resolved, you can get the cached dns info.
```swift
let domain = "google.com"
if let cachedDNS = dnsFetcher.getCachedDNSInfo(for: domain) { 
    print("cached dns for \(domain) is \(cachedDNS)")
} else {
    print("dns not resolved yet")
}

```
### (4) Force refresh DNS info for domain
```swift
dnsFetcher.refresh(domain: "google.com", force: true)
```

### (5) Use DNS info to make url request
```swift
let request = dnsInfo.createURLRequest(scheme: "https", path: "index.html")
```
or you can construct an url by direct using ip info in dns resolved.
```swift
let urlString = "https://" + dnsInfo.ipv4 + "/index.html"
```

### (6) Observe DNS info change
You can also use combine to observe dns info change. Update your business info when the callback fires. 
```swift
dnsFetcher.publisherForDNSInfos()
    .sink(receiveValue: { dnsInfo in
    print("dns info updated \(dnsInfo)")
})
```
