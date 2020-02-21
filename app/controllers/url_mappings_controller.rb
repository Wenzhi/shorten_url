class UrlMappingsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    actual_url = params[:actual_url]
    mapping = UrlMapping.find_by_actual_url(actual_url)
    if !mapping.present?
      begin
        mapping = generate_new_mapping!(actual_url)
      rescue => e
        render :json => {:error_message => e.message,
                         :error_class => e.class.name }
      return
      end
    end

    render :json => {:token => mapping.token,
                     :actual_url => mapping.actual_url }

  end



  def show
    @url_mapping = UrlMapping.find_by_token(params[:token])

    if @url_mapping.present?
      respond_to do |format|
        format.html { redirect_to @url_mapping.actual_url}
        format.json { render :json => {:token => @url_mapping.token,
                                       :actual_url => @url_mapping.actual_url }}
      end
    else
      render :json => {:error_message => "Cannot find the corresponding actual url."}
    end

    return
  end

    def generate_new_mapping!(actual_url)
      mapping = UrlMapping.new(actual_url: actual_url)
      mapping.generate_token
      mapping.save!
      return mapping
    end
end
