class StaticPagesController < ApplicationController
  def home
    @sellingbook = current_user.sellingbooks.build if signed_in?
    @wantedbook = current_user.wantedbooks.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
