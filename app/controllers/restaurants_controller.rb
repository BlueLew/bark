class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :destroy]

  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all.sort_by { |restaurant| [restaurant.reviews.average(:rating) || restaurant.reviews.count] }.reverse
    @restaurants = @restaurants.paginate(page: params[:page], per_page: 5)
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    @reviews = @restaurant.reviews
    @new_review = Review.new if current_user
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    
    respond_to do |format|
      if @restaurant.save
        if params[:restaurant][:images].present?
          params[:restaurant][:images].each do |image|
            @restaurant.images.attach(image)
          end
        end
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        if params[:restaurant][:images].present?
          params[:restaurant][:images].each do |image|
            @restaurant.images.attach(image)
          end
        end
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find_by(params[:signed_id]).purge
    redirect_back(fallback_location: request.referer)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.includes(:reviews).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:name)
    end

    def require_same_user
      if current_user != @restaurant.user
        flash[:danger] = "Only the owner can edit or delete the restaurant."
        redirect_to root_path
      end
    end
end
