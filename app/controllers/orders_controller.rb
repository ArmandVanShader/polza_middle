class OrdersController < ApplicationController
  def new
    @ingredients = Ingredient.all.to_a
    @dishs = Dish.all.to_a
    @order = Order.new allergens: @ingredients.sample(rand(0..5)), dishs: @dishs.sample(rand(1..@dishs.size))
  end

  def create
    puts order_params
    @order = Order.new(order_params)
    puts @order
    @order.save!

    flash[:notice] = "Заказ сохранён."
    redirect_to action: :home
  end

  def generate
    @count = params[:count].to_i || 10
    Order.generate(@count)
    flash[:notice] = "Заказы сгенерированы."
    redirect_to action: :home
  end

  def index
    @orders = Order.strict_loading.all.preload({dishs: :ingredients}).includes(:allergens).order(created_at: :desc)
  end

  def delete
    Order.in_batches(of: 100).destroy_all
    flash[:notice] = "Заказы удалены."
    redirect_to action: :home
  end


  def summary
    render json: Order.summary
  end

  def home
  end

  private
    def order_params
      params.permit(dish_ids: [], allergen_ids: [])
    end
end
