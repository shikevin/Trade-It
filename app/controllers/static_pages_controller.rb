class StaticPagesController < ApplicationController
  def home
    @sellingbook = current_user.sellingbooks.build if signed_in?
    @wantedbook = current_user.wantedbooks.build if signed_in?
    @sell_feed_items = current_user.sell_feed.paginate(page: params[:page])
    @want_feed_items = current_user.want_feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end
