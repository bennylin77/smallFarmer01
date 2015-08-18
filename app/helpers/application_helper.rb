module ApplicationHelper
  
  def carts
    quantity = 0
    current_user.carts.each do |c| 
      quantity = quantity + c.quantity
    end 
    quantity == 0 ? "" : quantity   
  end  
  
  def notifications
    current_user.notifications.where(read_c: false).size ==0 ? "" : current_user.notifications.where(read_c: false).size 
  end
  
  def cartsAndNotifications
    quantity = 0
    current_user.carts.each do |c| 
      quantity = quantity + c.quantity
    end 
    quantity = quantity + current_user.notifications.where(read_c: false).size
    quantity == 0 ? "" : quantity             
  end
  
  def shippingRates(hash={})
    shipping_rates = 0
    logger.info 1111111
    logger.info hash[:size]
    case hash[:size]
    when GLOBAL_VAR['BOX_SIZE_FIRST']
    logger.info 2222222  
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_FIRST'] 
      shipping_rates = shipping_rates + (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL'] ? GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'] : 0)  
    when GLOBAL_VAR['BOX_SIZE_SECOND']
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_SECOND']   
      shipping_rates = shipping_rates + (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL'] ? GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'] : 0)      
    when GLOBAL_VAR['BOX_SIZE_THIRD']
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_THIRD']       
    end
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
    [['county/Kinmen.png', '金門縣'],
     ['county/Lienchiang.png', '連江縣'],
     ['county/Keelung_City.png', '基隆市'],
     ['county/Taipei.png', '台北市'],
     ['county/New_Taipei.png', '新北市'],
     ['county/Taoyuan.png', '桃園市'],
     ['county/Taichung.png', '台中市'],
     ['county/Tainan.png', '台南市'],
     ['county/Kaohsiung.png', '高雄市'],
     ['county/Hsinchu_City.png', '新竹市'],
     ['county/Chiayi_City.png', '嘉義市'],
     ['county/Hsinchu.png', '新竹縣'],
     ['county/Miaoli.png', '苗栗縣'],
     ['county/Changhua.png', '彰化縣'],
     ['county/Nantou.png', '南投縣'],
     ['county/Yunlin.png', '雲林縣'],
     ['county/Chiayi.png', '嘉義縣'],       
     ['county/Pingtung.png', '屏東縣'],
     ['county/Yilan.png','宜蘭縣'],
     ['county/Hualien.png','花蓮縣'],
     ['county/Taitung.png', '台東縣'],                                                               
     ['county/Penghu.png', '澎湖縣'],
     ['county/Taiwan.png', '南海諸島']]
  end     

end
