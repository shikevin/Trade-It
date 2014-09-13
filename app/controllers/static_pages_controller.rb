class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @sellingbook = current_user.sellingbooks.build
      @wantedbook = current_user.wantedbooks.build
      @sell_feed_items = current_user.sell_feed.paginate(page: params[:page])
      @want_feed_items = current_user.want_feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
