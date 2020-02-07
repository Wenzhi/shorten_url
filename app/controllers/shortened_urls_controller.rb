class ShortenedUrlsController < ApplicationController
  def create
    url = params[:url]
    exist_url = ShortenedUrl.find_by_actual_url(url)
    if exist_url.present?
      render :json => {:shortened => exist_url.short_url,
                       :actual => exist_url.actual_url }
    else
      new_shortened_url = ShortenedUrl.new(actual_url: url)
      new_shortened_url.generate_short_url
      render :json => {:shortened => new_shortened_url.short_url,
                       :actual => new_shortened_url.actual_url }
    end
  end



  def show
    id = params[:id]
    short_url = params[:short_url]
    if id.present?
      @shortened_url = ShortenedUrl.find(id)
    elsif short_url.present?
      @shortened_url = ShortenedUrl.find_by_short_url(short_url)
    else
      return
    end

    if @shortened_url.present?
      respond_to do |format|
        format.html { redirect_to @shortened_url.short_url}
        format.json { render :json => {:shortened => @shortened_url.short_url,
                                       :actual => @shortened_url.actual_url }}
      end
    end
  end
end
