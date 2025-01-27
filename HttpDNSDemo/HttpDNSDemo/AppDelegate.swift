//
//  AppDelegate.swift
//  HttpDNSDemo
//

import UIKit
import HttpDNS
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let dnsFetcher: HttpDNSFetcher = .init(identifier: "mainDNSFetcher", queue: .global())
    private var cancellable: AnyCancellable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let domains: [String] = [
            "google.com",
            "youtube.com"
        ]
        // preload some domains
        dnsFetcher.preload(domains: domains)

        self.observeDNSUpdate()
        return true
    }
    
    func observeDNSUpdate() {
        // observe the dns refresh
        self.cancellable = dnsFetcher.publisherForDNSInfos()
            .sink(receiveValue: { dnsInfo in
            print("dns info updated \(dnsInfo)")
        })
    }
    
    func performRequestUsingDNSInfo(_ dnsInfo: DNSInfo) {
        guard let request = dnsInfo.createURLRequest(scheme: "https", path: "index.html") else {
            return
        }
        
        // Optional directly use the ip to create url
        // let urlString = "https://" + dnsInfo.ipv4 + "/index.html"
        
        // create url request using dnsinfo
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let domain = "google.com"
        let cachedDNS = dnsFetcher.getCachedDNSInfo(for: domain)
        print("cached dns for \(domain) is \(cachedDNS)")
        
        // refresh a specific domain
        dnsFetcher.refresh(domain: "google.com", force: true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
