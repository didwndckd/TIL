//
//  SampleData.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

struct SampleData {
  
  // MARK: currentForecastSampleData
  
  static let currentForecastSampleData: Data = """
{
  "weather" : {
    "hourly" : [
      {
        "grid" : {
          "latitude" : "37.53318",
          "longitude" : "127.04679",
          "city" : "서울",
          "county" : "성동구",
          "village" : "성수1가1동"
        },
        "sky" : {
          "code" : "SKY_O08",
          "name" : "흐리고 비"
        },
        "temperature" : {
          "tc" : "6.90",
          "tmax" : "8.00",
          "tmin" : "4.00"
        },
        "humidity" : "90.00",
        "lightning" : "0",
        "wind" : {
          "wdir" : "256.00",
          "wspd" : "4.40"
        },
        "precipitation" : {
          "sinceOntime" : "1.00",
          "type" : "1"
        },
        "timeRelease" : "2020-02-22 02:00:00"
      }
    ]
  },
  "common" : {
    "alertYn" : "Y",
    "stormYn" : "N"
  },
  "result" : {
    "code" : 9200,
    "requestUrl" : "/weather/current/hourly?city=서울&county=성동구&village=성수동2가",
    "message" : "성공"
  }
}
""".data(using: .utf8)!
  
  
  // MARK: shortRangeForecast
  
  static let shortRangeForecast: Data = """
{
  "weather" : {
    "forecast3days" : [ {
      "grid" : {
        "city" : "서울",
        "county" : "성동구",
        "village" : "성수1가1동",
        "longitude" : "127.04679",
        "latitude" : "37.53318"
      },
      "timeRelease" : "2020-02-22 02:00:00",
      "fcst3hour" : {
        "wind" : {
          "wdir4hour" : "281.00",
          "wspd4hour" : "1.80",
          "wdir7hour" : "257.00",
          "wspd7hour" : "3.20",
          "wdir10hour" : "267.00",
          "wspd10hour" : "3.40",
          "wdir13hour" : "280.00",
          "wspd13hour" : "5.00",
          "wdir16hour" : "285.00",
          "wspd16hour" : "4.00",
          "wdir19hour" : "298.00",
          "wspd19hour" : "2.50",
          "wdir22hour" : "299.00",
          "wspd22hour" : "2.10",
          "wdir25hour" : "295.00",
          "wspd25hour" : "1.70",
          "wdir28hour" : "300.00",
          "wspd28hour" : "1.40",
          "wdir31hour" : "260.00",
          "wspd31hour" : "1.20",
          "wdir34hour" : "250.00",
          "wspd34hour" : "2.10",
          "wdir37hour" : "242.00",
          "wspd37hour" : "2.70",
          "wdir40hour" : "235.00",
          "wspd40hour" : "2.20",
          "wdir43hour" : "201.00",
          "wspd43hour" : "1.70",
          "wdir46hour" : "190.00",
          "wspd46hour" : "1.70",
          "wdir49hour" : "",
          "wspd49hour" : "",
          "wdir52hour" : "",
          "wspd52hour" : "",
          "wdir55hour" : "",
          "wspd55hour" : "",
          "wdir58hour" : "",
          "wspd58hour" : "",
          "wdir61hour" : "",
          "wspd61hour" : "",
          "wdir64hour" : "",
          "wspd64hour" : "",
          "wdir67hour" : "",
          "wspd67hour" : ""
        },
        "precipitation" : {
          "type4hour" : "0",
          "prob4hour" : "30.00",
          "type7hour" : "0",
          "prob7hour" : "0.00",
          "type10hour" : "0",
          "prob10hour" : "20.00",
          "type13hour" : "0",
          "prob13hour" : "20.00",
          "type16hour" : "0",
          "prob16hour" : "0.00",
          "type19hour" : "0",
          "prob19hour" : "0.00",
          "type22hour" : "0",
          "prob22hour" : "0.00",
          "type25hour" : "0",
          "prob25hour" : "0.00",
          "type28hour" : "0",
          "prob28hour" : "0.00",
          "type31hour" : "0",
          "prob31hour" : "0.00",
          "type34hour" : "0",
          "prob34hour" : "0.00",
          "type37hour" : "0",
          "prob37hour" : "0.00",
          "type40hour" : "0",
          "prob40hour" : "0.00",
          "type43hour" : "0",
          "prob43hour" : "0.00",
          "type46hour" : "0",
          "prob46hour" : "30.00",
          "type49hour" : "",
          "prob49hour" : "",
          "type52hour" : "",
          "prob52hour" : "",
          "type55hour" : "",
          "prob55hour" : "",
          "type58hour" : "",
          "prob58hour" : "",
          "type61hour" : "",
          "prob61hour" : "",
          "type64hour" : "",
          "prob64hour" : "",
          "type67hour" : "",
          "prob67hour" : ""
        },
        "sky" : {
          "code4hour" : "SKY_S07",
          "name4hour" : "흐림",
          "code7hour" : "SKY_S01",
          "name7hour" : "맑음",
          "code10hour" : "SKY_S03",
          "name10hour" : "구름많음",
          "code13hour" : "SKY_S03",
          "name13hour" : "구름많음",
          "code16hour" : "SKY_S01",
          "name16hour" : "맑음",
          "code19hour" : "SKY_S01",
          "name19hour" : "맑음",
          "code22hour" : "SKY_S01",
          "name22hour" : "맑음",
          "code25hour" : "SKY_S01",
          "name25hour" : "맑음",
          "code28hour" : "SKY_S01",
          "name28hour" : "맑음",
          "code31hour" : "SKY_S01",
          "name31hour" : "맑음",
          "code34hour" : "SKY_S01",
          "name34hour" : "맑음",
          "code37hour" : "SKY_S01",
          "name37hour" : "맑음",
          "code40hour" : "SKY_S01",
          "name40hour" : "맑음",
          "code43hour" : "SKY_S01",
          "name43hour" : "맑음",
          "code46hour" : "SKY_S07",
          "name46hour" : "흐림",
          "code49hour" : "",
          "name49hour" : "",
          "code52hour" : "",
          "name52hour" : "",
          "code55hour" : "",
          "name55hour" : "",
          "code58hour" : "",
          "name58hour" : "",
          "code61hour" : "",
          "name61hour" : "",
          "code64hour" : "",
          "name64hour" : "",
          "code67hour" : "",
          "name67hour" : ""
        },
        "temperature" : {
          "temp4hour" : "5.00",
          "temp7hour" : "6.00",
          "temp10hour" : "8.00",
          "temp13hour" : "7.00",
          "temp16hour" : "4.00",
          "temp19hour" : "2.00",
          "temp22hour" : "1.00",
          "temp25hour" : "0.00",
          "temp28hour" : "-1.00",
          "temp31hour" : "2.00",
          "temp34hour" : "6.00",
          "temp37hour" : "8.00",
          "temp40hour" : "6.00",
          "temp43hour" : "4.00",
          "temp46hour" : "3.00",
          "temp49hour" : "",
          "temp52hour" : "",
          "temp55hour" : "",
          "temp58hour" : "",
          "temp61hour" : "",
          "temp64hour" : "",
          "temp67hour" : ""
        },
        "humidity" : {
          "rh4hour" : "80.00",
          "rh64hour" : "",
          "rh67hour" : "",
          "rh7hour" : "75.00",
          "rh10hour" : "50.00",
          "rh13hour" : "45.00",
          "rh16hour" : "50.00",
          "rh19hour" : "45.00",
          "rh22hour" : "60.00",
          "rh25hour" : "65.00",
          "rh28hour" : "70.00",
          "rh31hour" : "65.00",
          "rh34hour" : "45.00",
          "rh37hour" : "35.00",
          "rh40hour" : "40.00",
          "rh43hour" : "55.00",
          "rh46hour" : "65.00",
          "rh49hour" : "",
          "rh52hour" : "",
          "rh55hour" : "",
          "rh58hour" : "",
          "rh61hour" : ""
        }
      },
      "fcst6hour" : {
        "rain6hour" : "없음",
        "rain12hour" : "없음",
        "rain18hour" : "없음",
        "rain24hour" : "없음",
        "rain30hour" : "없음",
        "rain36hour" : "없음",
        "rain42hour" : "없음",
        "rain48hour" : "없음",
        "rain54hour" : "",
        "snow6hour" : "없음",
        "snow12hour" : "없음",
        "snow18hour" : "없음",
        "snow24hour" : "없음",
        "snow30hour" : "없음",
        "snow36hour" : "없음",
        "snow42hour" : "없음",
        "snow48hour" : "없음",
        "snow54hour" : "",
        "rain60hour" : "",
        "rain66hour" : "",
        "snow60hour" : "",
        "snow66hour" : ""
      },
      "fcstdaily" : {
        "temperature" : {
          "tmax1day" : "8.00",
          "tmax2day" : "8.00",
          "tmax3day" : "",
          "tmin1day" : "4.00",
          "tmin2day" : "-1.00",
          "tmin3day" : ""
        }
      }
    } ]
  },
  "common" : {
    "alertYn" : "Y",
    "stormYn" : "N"
  },
  "result" : {
    "code" : 9200,
    "requestUrl" : "/weather/forecast/3days?city=서울&county=성동구&village=성수동2가",
    "message" : "성공"
  }
}
""".data(using: .utf8)!
    
}
