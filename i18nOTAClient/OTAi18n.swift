//
//  OTAi18n.swift
//  protoLocalizableI18N
//
//  Created by favre on 19/10/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

enum LocalizedError: Error {
  case fileNotFound(String)
  case uploadKeyError(String)
}

extension URLSession {
  func synchronousDataTaskWithURL(url: NSURL) -> (NSData?, URLResponse?, NSError?) {
    var data: NSData?, response: URLResponse?, error: NSError?
    
    let semaphore = DispatchSemaphore(value: 0)
    
    dataTask(with: url as URL) {
      data = $0 as NSData?; response = $1; error = $2 as NSError?
      semaphore.signal()
      }.resume()
    
    let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    return (data, response, error)
  }
}

//TODO: allow asynchronous download
//TODO: closure when fetch is down
//TODO: upload translate

/**
 an Instance of `i18n` allow user to download translation from ez-i18n server. One downloaded, translate can be found with `localized` method
 */
public class i18n {
  public static let shared = i18n(baseUrl: "", projectName: "")
  /**
   Base url of ez-i18n server
   */
  private var baseUrl:String //= "https://i18n.save.co/api/public"
  
  /**
   project name used by the server to find the right translation for your project
   */
  private var projectName:String// = "save-stocks"
  
  /**
   Property used to known if translation ar alredy download form server.
   */
  private var isFetched = false
  
  /**
   buffer for current translation
   */
  private var dico: [String:String] = [:]
  
  init(baseUrl: String, projectName: String) {
    self.baseUrl = baseUrl
    self.projectName = projectName
  }
  
  /**
   Set `baseUrl` and `projectName` property. This also force i18n client to re-download translation.
   
   - parameter baseUrl: Base url of ez-i18n server
   - parameter projectName: Property used to known if translation ar alredy download form server.
   */
  public func configure(baseUrl: String, projectName: String) {
    self.isFetched = false
    self.baseUrl = baseUrl
    self.projectName = projectName
  }
  
  /**
   Download all translation from server and save it locally.
   This method is call automatically just one time after running the app. Kill you'r app and it will be called again.
   
    Synchronous method.
   
   - parameter language: Preferred language for the translatation do download. if `language` is nil or emptynthe method attemps to use the language in `NSLocale.preferredLanguages()[0]`.
   - parameter tableName: The receiver’s string table to search. If tableName is nil or is an empty string, the method attempts to use the table in Localizable.strings.
   */
  public func fetchLocalized(language:String = NSLocale.preferredLanguages[0], tableName:String = "Localized") {
    let language = language.components(separatedBy: "-")[0]
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    if self.isFetched && FileManager.default.fileExists(atPath: "\(paths[0])/IVI/\(language).lproj/\(tableName)"){
      return
    }
    
    let result = URLSession.shared
      .synchronousDataTaskWithURL(
        url: NSURL(string: "\(self.baseUrl)/\(language)/\(self.projectName)")!)
    
    guard let data = result.0
      else { return }
    
    do {
      try FileManager.default.createDirectory(
        atPath: "\(paths[0])/IVI/\(language).lproj/",
        withIntermediateDirectories: true,
        attributes: [:])
      
      if !FileManager.default.fileExists(atPath: "\(paths[0])/IVI/\(language).lproj/\(tableName)") {
        let _ = FileManager.default.createFile(
          atPath: "\(paths[0])/IVI/\(language).lproj/\(tableName)",
          contents: nil,
          attributes: [:])
      }
      
      self.isFetched = data.write(toFile: "\(paths[0])/IVI/\(language).lproj/\(tableName)", atomically: true)
    }
    catch let error { print("[\(#file):\(#function)] ERROR : \(error)") }
  }
  
  /**
   Upload a specify key to i18n server.
   This method is call automatically if a given key is not found in current translation. 
   Can Throw `LocalizedError.uploadKeyError(String)`
   
   - parameter key: The key to upload
   - parameter language: Preferred language for the translatation do download. if `language` is nil or emptynthe method attemps to use the language in `NSLocale.preferredLanguages()[0]`.
   - parameter value: a value for the specify key and language. if value is nil then the value to upload for the current language will be the key.
   */
  public func postLocalizedKey(key: String, language:String = NSLocale.preferredLanguages[0], value: String? = nil) throws {
    guard let url = NSURL(string: self.baseUrl)
      else { throw LocalizedError.uploadKeyError("post url is malformed") }
    
    let locale = NSLocale.preferredLanguages[0].components(separatedBy: "-")[0]
    let request = NSMutableURLRequest(url: url as URL)
    let dico = [
      "app": self.projectName,
      "key": "\(key)",
      "locale": locale,
      "value": "\(value ?? key)"
    ]
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: dico, options: .prettyPrinted) //"{\"app\" : \"Save-Stocks\",\n \"key\" : \"\(key)\",\n \"locale\" : \"fr\",\n \"value\" : \"\(value ?? key)\"\n}".dataUsingEncoding(NSUTF8StringEncoding)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 300
    
    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
      print("I18N CREATION ==> \(response)")
      if let error = error {
        print("ERROR ==> [\(#file) : \(#function)] ERROR : \(error.localizedDescription)")
      }
      }.resume()
    print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue))
  }
  
  /**
   Read all translation from the translation files and store them in a buffer.
   
   - parameter tableName: The receiver’s string table to search. If tableName is nil or is an empty string, the method attempts to use the table in Localizable.strings.
   - parameter language: Preferred language for the translatation do download. if `language` is nil or emptynthe method attemps to use the language in `NSLocale.preferredLanguages()[0]`.
   - parameter bundle: The bundle containing the strings file
   */
  func preloadTranslation(language:String = NSLocale.preferredLanguages[0], tableName:String = "Localized", bundle:Bundle = Bundle.main) throws {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let language = language.components(separatedBy: "-")[0]
    
    guard paths.count > 0,
      let data = FileManager.default.contents(atPath: "\(paths[0])/IVI/\(language).lproj/\(tableName)"),
      let dico = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
      else { throw LocalizedError.fileNotFound("\(tableName) was not found or is malformed") }
    
    dico.forEach { (key, value) in
      guard
        let key = key as? String,
        let value = value as? String
        else { return }
      
      self.dico[key] = value
    }
  }
  
  
  /**
   Returns a localized version of the string designated by the specified key and residing in the specified table.
   
   - parameter key: The key for a string in the table identified by tableName.
   - parameter tableName: The receiver’s string table to search. If tableName is nil or is an empty string, the method attempts to use the table in Localizable.strings.
   - parameter language: Preferred language for the translatation do download. if `language` is nil or emptynthe method attemps to use the language in `NSLocale.preferredLanguages()[0]`.
   - parameter bundle: The bundle containing the strings file.
   - parameter value: The value to return if key is nil or if a localized string for key can’t be found in the table.
   
   - returns: A localized version of the string designated by key in table tableName.
   */
  public static func localized(key:String, tableName:String = "Localized", language:String = NSLocale.preferredLanguages[0], bundle:Bundle = Bundle.main, value:String = "") throws -> String {
    if i18n.shared.dico.count == 0 {
      try i18n.shared.preloadTranslation(language: language, tableName: tableName, bundle: bundle)
    }
    
    if !i18n.shared.dico.keys.contains(key) {
      try i18n.shared.postLocalizedKey(key: key, language: language)
      return value == "" ? key : value
    }
    
    guard let localized = i18n.shared.dico[key] , localized != ""
    else { return value == "" ? key : value }
    
    return i18n.shared.dico[key] ?? value
  }
  
}
