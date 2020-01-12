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
    'Mail.Read'
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
end
