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
                         :error_class => e.class.name}
      return
      end
    end

    render :json => {:token => mapping.token,
                     :actual_url => mapping.actual_url,
                     :shortened_url => request.host_with_port+url_mapping_path(mapping.token)}

  end

  def show
    @url_mapping = UrlMapping.find_by_token(params[:token])

    if @url_mapping.present?
      respond_to do |format|
        format.html { redirect_to @url_mapping.actual_url}
        format.json { render :json => {:token => @url_mapping.token,
                                       :actual_url => @url_mapping.actual_url,
                                       :shortened_url => request.host_with_port+url_mapping_path(@url_mapping.token)}}
      end
    else
      render :json => {:error_message => "Cannot find the corresponding actual url."}
    end

    return
  end

  def destroy
    token = params[:token]
    return_json = {}
    if token.present?
      return_json[:token] = token
      return_json[:deleted] = true
      UrlMapping.delete_by(token: token)
    else
      return_json[:error_message] = "Please pass in either the actual url or the token."
    end
    render :json => return_json
  end

  def generate_new_mapping!(actual_url)
    mapping = UrlMapping.new(actual_url: actual_url)
    mapping.generate_token
    mapping.save!
    return mapping
  end
end
