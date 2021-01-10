//
//  byteCoinManger.swift
//  byteCoinConverter
//
//  Created by Qenawi on 1/10/21.
//  Copyright © 2021 qenawi. All rights reserved.
//

import Foundation

protocol ByteCoinMangerDeligate {
    func onDataReady()
    func onDataExcangeReady()
    func onDataFail(e:Error)
}
class ByteCoinManger: NetWorkMangerCallBack {
    func onSucess<T>(d: T)
    {
        if d is BtsData
        {
             self.pickerData = (d as! BtsData).data ?? []
                   //switch context
                   DispatchQueue.main.async{
                       self.deligate?.onDataReady()

                   }
        }
        else {
            self.excahngeValue = (d as! BtsExchangeValue)
                   //switch context
                   DispatchQueue.main.async{
                       self.deligate?.onDataExcangeReady()

                   }
        }
       
    }
    
  
    
    
    func onFail(error: Error)
    {
    }
    
    var deligate:ByteCoinMangerDeligate? = nil
    var selection:String = ""
    var pickerData:[Btsitem] = []
    let netWorkManger = NetWorkManger()
    var excahngeValue :BtsExchangeValue? = nil
    
    init()
    {
        netWorkManger.callBack = self
    }
    func getPickerData()
    {self.callNetWork()}
    func getExcangeData(dd:String)
    {self.callNetWorkExcange(d: dd)}
    private func callNetWork()
    {
        self.netWorkManger.getUrl()
    }
    private func callNetWorkExcange(d:String)
        {
            self.netWorkManger.getUrlExchange(val: d)
        }
    
}
protocol NetWorkMangerCallBack {
    func onSucess<T>(d:T)
    func onFail(error:Error)
}



struct SampleClass:Decodable {
    var test:String
}
struct GlobalResponse<T:Decodable>:Decodable {
    var code:Int?,msg:String?,
    data:T?
    enum CodingKeys: String, CodingKey {
        case code
        case msg = "message"
        case data = "data"
        
    }
}
class NetWorkManger
{
    init() {}
    
    var callBack:NetWorkMangerCallBack? = nil
    
    func getUrl() {
        let URL="https://rest.coinapi.io/v1/exchangerate/BTC?apikey=C1CB790F-2AC0-4437-ADE0-B15769B2AACA"
        preformRequest(st: URL,typee: BtsData())
    }
    func getUrlExchange(val:String)
    {
               let URL="https://rest.coinapi.io/v1/exchangerate/\(val)/USD?apikey=C1CB790F-2AC0-4437-ADE0-B15769B2AACA"
               preformRequest(st: URL,typee: BtsExchangeValue())

    }
    func preformRequest<T:Decodable>(st:String ,typee:T) {
        let url = URL(string: st)
        let setion = URLSession(configuration: .default)
        let task = setion.dataTask(with: url!,completionHandler:{a,s,d in
            self.handle(e: typee, d: a, url: s, error: d)
            
        })
        task.resume()
    }
 
    
    
    func handle<T:Decodable>(e:T,d:Data?,url:URLResponse?,error:Error?){
        if error != nil{
            print(error!)
            return
        }
        if let safeData = d {
            
            parseJSON(weData: safeData,ee:e)
            
        }
    }
    
    
    
    func parseJSON<T:Decodable>(weData:Data,ee:T)  {
        print(weData)
        let decoder = JSONDecoder()
        do{
            let decodedDaat = try decoder.decode(T.self, from: weData)
            callBack?.onSucess(d:decodedDaat)
        }catch
        {
            print(error)
        }
        
    }
}
