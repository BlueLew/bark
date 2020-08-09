class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)
    @review.user = current_user
    @review.save
    redirect_to restaurant_path(@restaurant)    
  end

  def destroy
    # @restaurant = Restaurant.find_by(params[:restaurant_id])
    @review = Review.find(params[:id])
    if current_user != @review.user
      flash[:danger] = "You can only delete your own review."
      redirect_to root_path
    else
      @review.destroy
      flash[:danger] = "Review was successfully deleted."
      redirect_to restaurant_path
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
