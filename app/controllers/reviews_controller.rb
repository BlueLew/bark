class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      UserMailer.new_review_email(@restaurant.user).deliver_later
      flash[:success] = "Thank you for your review!"
      redirect_to restaurant_path(@restaurant)
    else
      flash.now[:error] = "Your review could not be saved, please try again."
      redirect_to root_path
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @review = Review.find(params[:restaurant_id])
    if current_user != @review.user
      flash[:danger] = "You can only delete your own review."
      redirect_to root_path
    else
      @review.destroy
      flash[:danger] = "Review was successfully deleted."
      redirect_to restaurant_path(@restaurant)
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
