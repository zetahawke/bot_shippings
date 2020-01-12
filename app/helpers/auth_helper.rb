module AuthHelper
  # App's client ID. Register the app in Application Registration Portal to get this value.
  CLIENT_ID = Rails.configuration.carolina_bot_azure_token
  # App's client secret. Register the app in Application Registration Portal to get this value.
  CLIENT_SECRET = Rails.configuration.carolina_bot_azure_client_secret

  # Scopes required by the app
  SCOPES = [
    'openid',
    'profile',
    'User.Read',
    'Mail.Read',
    'offline_access'
  ].freeze

  REDIRECT_URI = 'http://localhost:3000/authorize'.freeze # Temporary!

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    client.auth_code.authorize_url(redirect_uri: REDIRECT_URI, scope: SCOPES.join(' '))
  end

  # Exchanges an authorization code for a token
  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    client.auth_code.get_token(auth_code,
                                            redirect_uri: authorize_url,
                                            scope: SCOPES.join(' '))
  end

  # Gets the current access token
  def get_access_token
    # Get the current token hash from session
    token_hash = session[:azure_token]

    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                site: 'https://login.microsoftonline.com',
                                authorize_url: '/common/oauth2/v2.0/authorize',
                                token_url: '/common/oauth2/v2.0/token')

    token = OAuth2::AccessToken.from_hash(client, token_hash)

    # Check if token is expired, refresh if so
    if token.expired?
      new_token = token.refresh!
      # Save new token
      session[:azure_token] = new_token.to_hash
      new_token.token
    else
      token.token
    end
  end
end
