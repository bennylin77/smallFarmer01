module InvoicesHelper
  def cancelAvailable(invoice)
    cancel_available = true
    invoice.orders.each do |o|       
      if o.called_smallfarmer_c
          cancel_available = false
      end      
    end
    if invoice.canceled_c
      cancel_available = false      
    end
    cancel_available
  end
end