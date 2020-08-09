class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(params[:review].permit(:rating, :comment))
    @review.user = current_user
    @review.save
    redirect_to restaurant_path(@restaurant)    
  end

  def destroy
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
end
