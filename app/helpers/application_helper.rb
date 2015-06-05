module ApplicationHelper
  
  def carts
    quantity = 0
    current_user.carts.each do |c| 
      quantity = quantity + c.quantity
    end 
    quantity == 0 ? "" : quantity   
  end  
  
  def active(hash={})     
    if current_page?(hash)
      "class='active'".html_safe     
    end
  end  
  
  def showBlank(s)
    if s.blank?
      '--'
    else  
      simple_format( s, {}, wrapper_tag: "span")
    end
  end  
  
  def countyImageOptions
    [['金門縣', 'county/Kinmen.png'],
     ['連江縣', 'county/Lienchiang.png'],
     ['基隆市', 'county/Keelung_City.png'],
     ['臺北市', 'county/Taipei.png'],
     ['新北市', 'county/New_Taipei.png'],
     ['桃園市', 'county/Taoyuan.png'],
     ['臺中市', 'county/Taichung.png'],
     ['臺南市', 'county/Tainan.png'],
     ['高雄市', 'county/Kaohsiung.png'],
     ['新竹市', 'county/Hsinchu_City.png'],
     ['嘉義市', 'county/Chiayi_City.png'],
     ['新竹縣', 'county/Hsinchu.png'],
     ['苗栗縣', 'county/Miaoli.png'],
     ['彰化縣', 'county/Changhua.png'],
     ['南投縣', 'county/Nantou.png'],
     ['雲林縣', 'county/Yunlin.png'],
     ['嘉義縣', 'county/Chiayi.png'],       
     ['屏東縣', 'county/Pingtung.png'],
     ['宜蘭縣', 'county/Yilan.png'],
     ['花蓮縣', 'county/Hualien.png'],
     ['臺東縣', 'county/Taitung.png'],                                                               
     ['澎湖縣', 'county/Penghu.png']]
  end     
end
