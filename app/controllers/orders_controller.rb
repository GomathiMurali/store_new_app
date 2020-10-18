require 'shopify_api'

class OrdersController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy]
  @api_key = '538c9d1f964f5663a4d6f8a5557a1fb6'
  @password = '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'
  @shop_name = 'color-storess'
  @shop_url = "https://#{@api_key}:#{@password}@#{@shop_name}.myshopify.com"    
  ShopifyAPI::Base.site = @shop_url
  ShopifyAPI::Base.api_version = '2020-07' # find the latest stable api_version here: https://shopify.dev/concepts/about-apis/versioning
  shop = ShopifyAPI::Shop.current

  #ShopifyAPI::Order.find(:all, params: {ids: "1,2,3,4"})
  def index
   @orders = ShopifyAPI::Order.all  
   
 end
 def show
 end

 def create
  @new_order = ShopifyAPI::Order.new
  @new_order.email = order_params[:email]
  @new_order.phone = order_params[:phone]
  @new_order.financial_status = order_params[:financial_status]
  @new_order.line_items = []  
  order_params[:product_attributes].values.each do |line_item| 
    line_item_obj = ShopifyAPI::LineItem.new(
      :variant_id => line_item["variant_id"],
      :title => line_item["title"],
      :quantity => line_item["quantity"],
      :grams => line_item["grams"],
      :price =>  line_item["price"]
      )
    @new_order.line_items << line_item_obj
  end

  @new_order.shipping_address = ShopifyAPI::ShippingAddress.new(
       :first_name => order_params[:first_name], :last_name => order_params[:last_name], :address1 => order_params[:address1], :address2 => order_params[:address2], :phone => order_params[:phone],:city => order_params[:city], :zip => order_params[:zip],  :province => order_params[:province], :country => order_params[:country])  
        new_order = ShopifyAPI::Order.create( 
       :email => @new_order.email,
       :phone => @new_order.phone,
       :financial_status => @new_order.financial_status, 
       :shipping_address => @new_order.shipping_address,
       :line_items => @new_order.line_items
       )   
    
   end

   def new
     @order= Order.new     
     @products = ShopifyAPI::Product.all     
     #fetch_country  
     $line_items = []

   end

   # def fetch_country
   #   @country = ShopifyAPI::Country.all
   # end

   def states
    render json: CS.states(params[:country]).to_json
  end

  def add_line_item
    variant_id = params[:variant_id]
    title = params[:title]
    price = params[:price]
    grams = params[:grams]
    quantity = params[:quantity]
    line_item = { "variant_id" => variant_id,"title" => title, "price" => price, "grams" => grams, "quantity" => quantity}    
    $line_items << line_item
    #puts "line_items size: #{$line_items.size}"
  end

  def edit
  end

  def update
  end

  def destroy
  end
  private
    # Use callbacks to share common setup or constraints between actions.   

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:title,:price, :quantity, :grams, :variant_id, :email,:country_id, :quantity, :financial_status, :address1, :address2,:first_name, :last_name, :phone, :country, :city,:province, :zip, product_attributes: [:title, :price, :grams, :quantity] )
    end
    
  end
