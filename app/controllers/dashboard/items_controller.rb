class Dashboard::ItemsController < ApplicationController
  def index
    @items = Item.where(user: current_user)
  end

  def toggle
    item = Item.find(params[:id])
    if item.enabled?
      item.update(enabled: false)
    else
      item.update(enabled: true)
    end
    flash[:alert] = "Item #{item.id} with name '#{item.name}' is now disabled."
    redirect_to dashboard_items_path
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:alert] = "Item #{item.id} with name '#{item.name}' has been deleted."
    redirect_to dashboard_items_path
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:message] = "Your new item is saved."
      redirect_to dashboard_items_path
    else
      add_errors_on_flash(@item)
      render :new
    end
  end

  private

  def item_params
    ip = params.require(:item).permit(:name, :description, :image, :price, :instock_qty)
    ip[:user] = current_user
    ip.reject{|key,value| value.is_a?(String) && value.empty?}
  end
end
