class UrlMappingsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    actual_url = params[:actual_url]
    mapping = UrlMapping.find_or_initialize_by(actual_url: actual_url)

    if mapping.save
      render :json => {:token => mapping.token,
                       :actual_url => mapping.actual_url,
                       :shortened_url => request.host_with_port+url_mapping_path(mapping.token)}
    else
      render :json => {:errors => mapping.errors.full_messages.join(",")}
    end
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
    # Here is for the html. Without it, it will try to render a HTML view
    return
  end

  def destroy
    token = params[:token]
    if token.present?
      UrlMapping.delete_by(token: token)
      render :json => {:token => token, :deleted => true}
    else
      render :json => {:error_message => "Please pass in either the actual url or the token."}
    end
  end
end
