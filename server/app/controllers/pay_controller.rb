class PayController < ApplicationController
	def make_payment
		payment = Payment.find_by_order_no(params[:order_no])
		payment = Payment.new if !payment
		payment.order_no    = params[:order_no]
		payment.amount		= params[:amount]
		payment.channel 	= params[:channel]
		payment.currency 	= params[:currency] || "cny"
		payment.app_key 	= "app_W1izL8GWPa5SWXPK"
		payment.client_ip	= request.env['REMOTE_ADDR']

		payment.save

		res = Pingpp::Charge.create(
	        :order_no => payment.order_no,
	        :amount   => payment.amount,
	        :subject  => "Subject1",
	        :body     => "Body1",
	        :channel  => payment.channel,
	        :currency => payment.currency,
	        :client_ip=> payment.client_ip,
	        :app => {:id => payment.app_key}
	    )

	    render :text=>res
	end

	def notify
		payment = Payment.find_by_order_no(params[:order_no])
		if params[:paid]
			payment.status = "paid" 
			payment.paid_at = params[:time_paid]
		end
		render :text=>"ok"
	end
end
