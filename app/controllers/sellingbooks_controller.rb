class SellingbooksController < ApplicationController
  before_action :signed_in_user

  def create
    @sellingbook = current_user.sellingbooks.build(sellingbook_params)
    @wantedbook = current_user.wantedbooks.build
    if @sellingbook.save
      flash[:success] = "Selling course book: " + @sellingbook.content
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

  def sellingbook_params
    params.require(:sellingbook).permit(:content)
  end
end