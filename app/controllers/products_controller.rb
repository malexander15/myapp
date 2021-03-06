class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
	# TODO 1:
	# Add another before filter here for the new, create, edit, update, and destroy actions
  # Make sure that the user is logged in and/or logged in AND admin (you can just redirect_to root_url otherwise
	# Remember how the RESTful actions work- the new method in the controller just refers to the product creation view, 
	# But create is the action for sending that request to the server

	# TODO 2:
	# Go into the individual views and place if statements around the links to each action
	# E.G. Think about it, why would you have a link to the show action which would only redirect a non admin user?


	# GET /products
  # GET /products.json
  def index
    if params[:q]
    search_term = params[:q]
    @products = Product.where("name LIKE ?", "%#{search_term}%")
  else
    @products = Product.all.paginate(:page => params[:page], :per_page => 12)

    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @comments = @product.comments.order("created_at DESC").paginate(:page => params[:page], :per_page => 3)

  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to "/products", notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :image_url, :colour, :price)
    end
end
