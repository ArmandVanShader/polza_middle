class DishsController < ApplicationController
  def import
    Dish.import
    flash[:notice] = "Ингредиенты и блюда импортированы."
    redirect_to controller: :orders, action: :home
  end
end
