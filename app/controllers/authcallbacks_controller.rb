class AuthcallbacksController < ApplicationController

  def create

    omniauth_hash = request.env['omniauth.auth'].deep_symbolize_keys
    
    if current_user
      # connect current user to this credport profile if it doesnt have it already
      if current_user.credport_uid

      else
        current_user.credport_uid = omniauth_hash[:uid]
        current_user.credport_token = omniauth_hash[:credentials][:token]
        current_user.save

        # register our identity with Credport
        consumer = OAuth2::Client.new(Rails.configuration.credport_key, Rails.configuration.credport_secret, :site => ENV['CREDPORT_BASE_URL'] || "https://www.credport.org")
        access_token = OAuth2::AccessToken.new(consumer, current_user.credport_token)
        identity = {:uid => current_user.id, :url => user_url(current_user), :image => 'http://lorempixel.com/200/200/animals/', :name => current_user.name, :context_name => Rails.configuration.credport_identity_context_name, :subtitle => "#{current_user.name} on Marketplace X"}
        post_identity = access_token.post "/api/v1/users/#{current_user.credport_uid}/identities", {:body => identity.to_json, :headers => {'Content-Type' => 'application/json'}}
      end
      
      redirect_to user_path(current_user), :notice => "Credport Acccount connected"

    else
      # route to signup process
    end
  end

end
