//
//  CityCodeModel.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/22.
//

import Foundation

struct CityCodeModel {
    
    static let allCity: [String] = ["宜蘭縣", "桃園市", "新竹縣", "苗栗縣", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "屏東縣", "臺東縣", "花蓮縣", "澎湖縣", "基隆市", "新竹市", "嘉義市", "臺北市", "高雄市", "新北市", "臺中市", "臺南市", "連江縣", "金門縣"]
    static let cityCode: [String: String] = ["宜蘭縣": "F-D0047-001", "桃園市": "F-D0047-005", "新竹縣": "F-D0047-009", "苗栗縣": "F-D0047-013", "彰化縣": "F-D0047-017", "南投縣": "F-D0047-021", "雲林縣": "F-D0047-025", "嘉義縣": "F-D0047-029", "屏東縣": "F-D0047-033", "臺東縣": "F-D0047-037", "花蓮縣": "F-D0047-041", "澎湖縣": "F-D0047-045", "基隆市": "F-D0047-049", "新竹市": "F-D0047-053", "嘉義市": "F-D0047-057", "臺北市": "F-D0047-061", "高雄市": "F-D0047-065", "新北市": "F-D0047-069", "臺中市": "F-D0047-073", "臺南市": "F-D0047-077", "連江縣": "F-D0047-081", "金門縣": "F-D0047-085"]
}

struct TownCodeModel {
    
    static let townCode: [String: [String]] = [
        "宜蘭縣": ["頭城鎮", "礁溪鄉", "壯圍鄉", "員山鄉", "宜蘭市", "大同鄉", "五結鄉", "三星鄉", "羅東鎮", "冬山鄉", "南澳鄉", "蘇澳鎮"],
        "桃園市": ["大園區", "蘆竹區", "觀音區", "龜山區", "桃園區", "中壢區", "新屋區", "八德區", "平鎮區", "楊梅區", "大溪區", "龍潭區", "復興區"],
        "新竹縣": ["新豐鄉", "湖口鄉", "新埔鎮", "竹北市", "關西鎮", "芎林鄉", "竹東鎮", "寶山鄉", "尖石鄉", "橫山鄉", "北埔鄉", "峨眉鄉", "五峰鄉"],
        "苗栗縣": ["竹南鎮", "頭份市", "三灣鄉", "造橋鄉", "後龍鎮", "南庄鄉", "頭屋鄉", "獅潭鄉", "苗栗市", "西湖鄉", "通霄鎮", "公館鄉", "銅鑼鄉", "泰安鄉", "苑裡鎮", "大湖鄉", "三義鄉", "卓蘭鎮"],
        "彰化縣": ["伸港鄉", "和美鎮", "線西鄉", "鹿港鎮", "彰化市", "秀水鄉", "福興鄉", "花壇鄉", "芬園鄉", "芳苑鄉", "埔鹽鄉", "大村鄉", "二林鎮", "員林市", "溪湖鎮", "埔心鄉", "永靖鄉", "社頭鄉", "埤頭鄉", "田尾鄉", "大城鄉", "田中鎮", "北斗鎮", "竹塘鄉", "溪州鄉", "二水鄉"],
        "南投縣": ["仁愛鄉", "國姓鄉", "埔里鎮", "草屯鎮", "中寮鄉", "南投市", "魚池鄉", "水里鄉", "名間鄉", "信義鄉", "集集鎮", "竹山鎮", "鹿谷鄉"],
        "雲林縣": ["麥寮鄉", "二崙鄉", "崙背鄉", "西螺鎮", "莿桐鄉", "林內鄉", "臺西鄉", "土庫鎮", "虎尾鎮", "褒忠鄉", "東勢鄉", "斗南鎮", "四湖鄉", "古坑鄉", "元長鄉", "大埤鄉", "口湖鄉", "北港鎮", "水林鄉", "斗六市"],
        "嘉義縣": ["大林鎮", "溪口鄉", "阿里山鄉", "梅山鄉", "新港鄉", "民雄鄉", "六腳鄉", "竹崎鄉", "東石鄉", "太保市", "番路鄉", "朴子市", "水上鄉", "中埔鄉", "布袋鎮", "鹿草鄉", "義竹鄉", "大埔鄉"],
        "屏東縣": ["高樹鄉", "三地門鄉", "霧臺鄉", "里港鄉", "鹽埔鄉", "九如鄉", "長治鄉", "瑪家鄉", "屏東市", "內埔鄉", "麟洛鄉", "泰武鄉", "萬巒鄉", "竹田鄉", "萬丹鄉", "來義鄉", "潮州鎮", "新園鄉", "崁頂鄉", "新埤鄉", "南州鄉", "東港鎮", "林邊鄉", "佳冬鄉", "春日鄉", "獅子鄉", "琉球鄉", "枋山鄉", "牡丹鄉", "滿州鄉", "車城鄉", "恆春鎮", "枋寮鄉"],
        "臺東縣":  ["長濱鄉" ,"海端鄉" ,"池上鄉" ,"成功鎮" ,"關山鎮" ,"東河鄉" ,"鹿野鄉" ,"延平鄉" ,"卑南鄉" ,"臺東市", "太麻里鄉" ,"綠島鄉" ,"達仁鄉" ,"大武鄉" ,"蘭嶼鄉" ,"金峰鄉"],
        "花蓮縣": ["秀林鄉", "新城鄉", "花蓮市", "吉安鄉", "壽豐鄉", "萬榮鄉", "鳳林鎮", "豐濱鄉", "光復鄉", "卓溪鄉", "瑞穗鄉", "玉里鎮", "富里鄉"],
        "澎湖縣": ["白沙鄉", "西嶼鄉", "湖西鄉", "馬公市", "望安鄉", "七美鄉"],
        "基隆市": ["安樂區", "中山區", "中正區", "七堵區", "信義區", "仁愛區", "暖暖區"],
        "新竹市": ["北區","香山區","東區"],
        "嘉義市": ["東區","西區"],
        "臺北市": ["北投區", "士林區", "內湖區", "中山區", "大同區", "松山區", "南港區", "中正區", "萬華區", "信義區", "大安區", "文山區"],
        "高雄市": [ "楠梓區", "左營區", "三民區", "鼓山區", "苓雅區", "新興區", "前金區", "鹽埕區", "前鎮區", "旗津區", "小港區", "那瑪夏區", "甲仙區", "六龜區", "杉林區", "內門區", "茂林區", "美濃區", "旗山區", "田寮區", "湖內區", "茄萣區", "阿蓮區", "路竹區", "永安區", "岡山區", "燕巢區", "彌陀區", "橋頭區", "大樹區", "梓官區", "大社區", "仁武區", "鳥松區", "大寮區", "鳳山區", "林園區", "桃源區"],
        "新北市": ["石門區", "三芝區", "金山區", "淡水區", "萬里區", "八里區", "汐止區", "林口區", "五股區", "瑞芳區", "蘆洲區", "雙溪區", "三重區", "貢寮區", "平溪區", "泰山區", "新莊區", "石碇區", "板橋區", "深坑區", "永和區", "樹林區", "中和區", "土城區", "新店區", "坪林區", "鶯歌區", "三峽區", "烏來區"],
        "臺中市": ["北屯區", "西屯區", "北區", "南屯區", "西區", "東區", "中區", "南區", "和平區", "大甲區", "大安區", "外埔區", "后里區", "清水區", "東勢區", "神岡區", "龍井區", "石岡區", "豐原區", "梧棲區", "新社區", "沙鹿區", "大雅區", "潭子區", "大肚區", "太平區", "烏日區", "大里區", "霧峰區"],
        "臺南市": ["安南區", "中西區", "安平區", "東區", "南區", "北區", "白河區", "後壁區", "鹽水區", "新營區", "東山區", "北門區", "柳營區", "學甲區", "下營區", "六甲區", "南化區", "將軍區", "楠西區", "麻豆區", "官田區", "佳里區", "大內區", "七股區", "玉井區", "善化區", "西港區", "山上區", "安定區", "新市區", "左鎮區", "新化區", "永康區", "歸仁區", "關廟區", "龍崎區", "仁德區"],
        "連江縣": ["南竿鄉", "北竿鄉", "莒光鄉", "東引鄉"],
        "金門縣": ["金城鎮", "金湖鎮", "金沙鎮", "金寧鄉", "烈嶼鄉", "烏坵鄉"]
    ]
}

struct ElementNameCodeModel {
    
//    static let elementNames: [String] = ["天氣現象", "體感溫度", "溫度", "相對濕度", "降雨機率"]
    static let elementNames: [String] = ["體感溫度", "溫度", "降雨機率"]
    static let elementNameCode: [String: String] = ["天氣現象": "Wx", "體感溫度": "AT", "溫度": "T", "相對濕度": "RH", "降雨機率": "PoP6h"]
}