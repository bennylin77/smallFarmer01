module InvoicesHelper
  def cancelAvailable(invoice)
=begin    
    cancel_available = true    
    invoice.orders.each do |o|       
      if o.called_smallfarmer_c
          cancel_available = false
      end      
    end
    if invoice.canceled_c
      cancel_available = false      
    end
=end
    #invoice.confirmed_c ? false : true
    false
  end
end