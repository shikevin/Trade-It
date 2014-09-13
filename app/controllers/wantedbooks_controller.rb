class WantedbooksController < ApplicationController
  before_action :signed_in_user

  def create
    @wantedbook = current_user.wantedbooks.build(wantedbook_params)
    @sellingbook = current_user.sellingbooks.build
    if @wantedbook.save
      flash[:success] = "Course book: " + @wantedbook.content + " wanted"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

  def wantedbook_params
    params.require(:wantedbook).permit(:content)
  end
end