require 'shopify_api'
class ProductsController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy]
  @api_key = '538c9d1f964f5663a4d6f8a5557a1fb6'
  @password = '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'
  @shop_name = 'color-storess'
  @shop_url = "https://#{@api_key}:#{@password}@#{@shop_name}.myshopify.com"     
  ShopifyAPI::Base.site = @shop_url
  ShopifyAPI::Base.api_version = '2020-07'
  shop = ShopifyAPI::Shop.current

  def index          
     @products = ShopifyAPI::Product.all
     products_count = ShopifyAPI::Product.count
     #puts "count #{products_count}"
      respond_to do |format|
        format.html do
          render 'index'
        end
        format.json{
           products = get_products_list(products_count)
            render json: products
        }
      end
   end
 def get_products_list(products_count)
  puts "products count value: #{products_count}"
    page = 1
    start = params[:start] ? params[:start].to_i : 0
    length = params[:length] ? params[:length].to_i : 5
    if start > 0
      page = (start / length) + 1
    end
     # search_value = params[:search][:value]
     # if search_value.blank?
     
     #   products = ShopifyAPI::Product.find(:all, conditions: ["title LIKE ?", "%#search%"])
     #   products = ShopifyAPI::Product.select(:id, :title, :body_html, :product_type, :price, :sku, :barcode, :weight).where("lower(title) LIKE :search OR product_type LIKE :search", search: "%#{search_value.downcase}%").order('products.created_at DESC')
   #  end  
       
     product_details = []
    
     @products&.each do |product|
      list = {}
      list[:title] = product.title
      list[:body_html] = product.body_html
      list[:product_type] = product.product_type
      list[:price] =  product.variants[0].price  
      list[:sku] =  product.variants[0].sku
      list[:barcode] =  product.variants[0].barcode
      list[:weight] =  product.variants[0].weight
      product_details << list
      puts "list : #{list}" 
    end
    products = { "draw": params[:draw], "recordsTotal": products_count, "recordsFiltered": products_count, data: product_details }
    products
  end

 def show
 end

 def new    
    @product = Product.new
     #fetch_countries  
      #fetch_province
    end

  def create    
     @product = ShopifyAPI::Product.new(product_params)            
     @product.save
     puts "Saved successfully"
     # puts "respond :#{@product.variants}"
     @product_variant_list = @product.variants
     puts "respond :#{@product.variants}"
     @product_variant_list[0].price = product_params[:price]
     @product_variant_list[0].compare_at_price = product_params[:compare_at_price]
     @product_variant_list[0].sku = product_params[:sku]
     @product_variant_list[0].barcode = product_params[:barcode]
     @product_variant_list[0].weight = product_params[:weight]
     @product_variant_list[0].weight_unit = product_params[:weight_unit]    
     #country
     @product.save
     inventory_item_id = @product_variant_list[0].inventory_item_id
     inventory = ShopifyAPI::InventoryItem.find(inventory_item_id)
    # puts "==============inventory: #{product_params[:tracked]}"
     inventory.cost = product_params[:cost]
     inventory.tracked = product_params[:tracked]
     inventory.save
     @inventory_level = ShopifyAPI::InventoryLevel.where(inventory_item_ids: @product.variants[0].inventory_item_id)
    #puts "inventory level============+++++++++++++++++++++++++ #{inventory_level}"
    # @product.save
     puts"product response: #{@product.to_json}"
    #redirect_to products_path, notice: 'Product has been successfully created.'
     if @product.save
      redirect_to products_path, notice: 'Product has been successfully created.'
    else
       render "new"
    end
  end


 #  def fetch_countries
 #   @countries = ShopifyAPI::Country.all
 # end
  #def fetch_province
   #@provinces = ShopifyAPI::Country.find(params[:id])
# end

def edit
end

def update
end

def destroy
end
# def export_product1
#      #list_of_inventory_item_ids = [23434234, 2342342423]


#      product_type_list = ProductType.select(:name, :value).all
#       #@product_type_hash = Hash[product_type_list.map { |i| [i.name, i.value] }]
#       @product_type_hash = product_type_list.map{ |i| [i.name, i.value] }.to_h
#        #Rails.logger.info "product_type_hash=========: #{@product_type_hash}"

#        shopify_products  = ShopifyAPI::Product.find(:all, params: { limit: 2})
#       #Rails.logger.info "shopify_products......................:#{shopify_products.size.inspect}"
#       @shopify_product_types = shopify_products 
#       loop do  
#         break unless shopify_products.next_page?
#         shopify_products  = shopify_products.fetch_next_page
#         @shopify_product_types += shopify_products
#         #Rails.logger.info "shopify_products_types: #{@shopify_product_types}"
#       end
#       #find list of inventory_ID
#       @shopify_product_types.each do|inventory_id|
#         @list_of_inventory_item_ids = []
#         variants = inventory_id.variants
#         variants.each do |variant|               
#           inventory_item_id = variant.inventory_item_id
#           @list_of_inventory_item_ids << inventory_item_id
#           puts "List of inventory #{@list_of_inventory_item_ids}"
#         end
#       end
#       #find default location
#       shop_obj = ShopifyAPI::Shop.current
#       @default_location_id = shop_obj.primary_location_id
#       puts "location_id++++ #{@default_location_id}"
#       params = { inventory_item_ids: @list_of_inventory_item_ids, location_ids: @default_location_id, limit: 250}
#       @inventory_levels = ShopifyAPI::InventoryLevel.find(:all, params: params)
#       puts "inventory_levels++++ #{@inventory_levels}"

#       @inventory_levels.each do|level|

#       end
#       respond_to do |format|
#        format.xlsx {
#         response.headers['Content-Disposition'] = "attachment; filename= Product_export_#{Time.now.strftime('%d-%m-%Y')}.xlsx"
#       }
#     end
#   end
def export_product
     shopify_products  = ShopifyAPI::Product.find(:all, params: { limit: 250})
      #Rails.logger.info "shopify_products......................:#{shopify_products.size.inspect}"
      @shopify_product_types = shopify_products 
      loop do  
        break unless shopify_products.next_page?
        shopify_products  = shopify_products.fetch_next_page
        @shopify_product_types += shopify_products
        #Rails.logger.info "shopify_products_types: #{@shopify_product_types}"
      end

      product_type_list = ProductType.select(:name, :value).all
      #@product_type_hash = Hash[product_type_list.map { |i| [i.name, i.value] }]
      @product_type_hash = product_type_list.map{ |i| [i.name, i.value] }.to_h
      #Rails.logger.info "product_type_hash=========: #{@product_type_hash}"

      shop_obj = ShopifyAPI::Shop.current
      default_location_id = shop_obj.primary_location_id      

      @products_list = []      
      @shopify_product_types.each do |product|          
      inventory_qty_val = 0
      @list_of_inventory_item_ids = []
      variants = product.variants
      variants.each do |variant|               
      inventory_item_id = variant.inventory_item_id
      @list_of_inventory_item_ids << inventory_item_id        
      end
      #     
       # Rails.logger.info "List from excel sheet =========: #{@product_type_hash.to_json}"
       params = { inventory_item_ids: @list_of_inventory_item_ids.first,  limit: 250}
       inventory_levels = ShopifyAPI::InventoryLevel.find(:all, params: params) 
       inventory_levels.each do |level|
       inventory_location = ShopifyAPI::Location.find(level.location_id)
       inventory_qty = level.available  
       inventory_qty_val = inventory_qty + inventory_qty_val                
      end
      inventory_qty_val_type = inventory_qty_val * @product_type_hash[product.product_type]        
      puts " inventory_qty: #{inventory_qty_val}, inventory_qty_val_type: #{inventory_qty_val_type}, product type: #{@product_type_hash[product.product_type]  }"                    
      # @products_list = []  

      export_product = {} #declaring new hash
      export_product [:title] = product.title
      export_product [:body_html] = product.body_html
      export_product [:vendor] = product.vendor
      export_product [:product_type] = product.product_type
      export_product [:sku] =  product.variants[0].sku
      export_product [:grams] =   product.variants[0].grams
      export_product [:barcode] =  product.variants[0].barcode
      export_product [:weight_unit] =  product.variants[0].weight_unit
      export_product [:inventory_quantity] = inventory_qty_val
      export_product [:total_inventory_quantity] = inventory_qty_val_type
      export_product [:price] =  product.variants[0].price           
      @products_list << export_product
    end    
    
  end


  private
    # Use callbacks to share common setup or constraints between actions.   

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :body_html, :image, :price, :product_type, :compare_at_price, :cost, :sku, :barcode,:tracked, :available,:quantity, :incoming, :continue_selling, :weight, :weight_unit, :countries, :inventory_quantity, :inventory_item_id, :inventory_management, :inventory_policy, :requires_shipping, :fulfillment_service, :location_id, :location, :vendor)
    end

  end
