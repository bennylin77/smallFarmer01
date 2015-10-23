var GLOBAL_VAR = {
	  	'SHIPMENT_TEMP_NORMAL': 1,
	  	'SHIPMENT_TEMP_REFRIGERATION': 2,
	  	'SHIPMENT_TEMP_FREEZING': 3,	
		'BOX_SIZE_FIRST': 0,
		'BOX_SIZE_SECOND': 1,
		'BOX_SIZE_THIRD': 2,
	  	'SHIPPING_RATES_FIRST': 100,
	  	'BARGAIN_SHIPPING_RATES_FIRST': 80,  
	  	'SHIPPING_RATES_SECOND': 130,
	  	'BARGAIN_SHIPPING_RATES_SECOND': 110,    
	  	'SHIPPING_RATES_THIRD': 170, 
  		'BARGAIN_SHIPPING_RATES_THIRD': 140,  	  	 
	  	'SHIPPING_RATES_COLD_CHAIN': 100 
}

function shippingRates( box_size, cold_chain, quantity){
	var shipping_rates
	box_size = parseInt(box_size)
	cold_chain = parseInt(cold_chain)
	quantity = parseInt(quantity)
	switch(box_size) {
	    case GLOBAL_VAR.BOX_SIZE_FIRST:
	    	if(quantity==1)
      			shipping_rates = (cold_chain != GLOBAL_VAR.SHIPMENT_TEMP_NORMAL) ? (GLOBAL_VAR.SHIPPING_RATES_FIRST + GLOBAL_VAR.SHIPPING_RATES_COLD_CHAIN):GLOBAL_VAR.SHIPPING_RATES_FIRST;
	    	else
      			shipping_rates = (cold_chain != GLOBAL_VAR.SHIPMENT_TEMP_NORMAL) ? (GLOBAL_VAR.BARGAIN_SHIPPING_RATES_FIRST + GLOBAL_VAR.SHIPPING_RATES_COLD_CHAIN):GLOBAL_VAR.BARGAIN_SHIPPING_RATES_FIRST;	    			
	        break;
	    case GLOBAL_VAR.BOX_SIZE_SECOND:
	    	if(quantity==1)
      			shipping_rates = (cold_chain != GLOBAL_VAR.SHIPMENT_TEMP_NORMAL) ? (GLOBAL_VAR.SHIPPING_RATES_SECOND + GLOBAL_VAR.SHIPPING_RATES_COLD_CHAIN):GLOBAL_VAR.SHIPPING_RATES_SECOND;
	    	else
      			shipping_rates = (cold_chain != GLOBAL_VAR.SHIPMENT_TEMP_NORMAL) ? (GLOBAL_VAR.BARGAIN_SHIPPING_RATES_SECOND + GLOBAL_VAR.SHIPPING_RATES_COLD_CHAIN):GLOBAL_VAR.BARGAIN_SHIPPING_RATES_SECOND;	    			
	        break;	    
	    case GLOBAL_VAR.BOX_SIZE_THIRD:
      		shipping_rates = (cold_chain != GLOBAL_VAR.SHIPMENT_TEMP_NORMAL) ? (GLOBAL_VAR.SHIPPING_RATES_THIRD + GLOBAL_VAR.SHIPPING_RATES_COLD_CHAIN):GLOBAL_VAR.SHIPPING_RATES_THIRD;	    			
	        break;	       	        
	    default:
	} 
	return shipping_rates
}
