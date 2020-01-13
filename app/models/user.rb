class User < ApplicationRecord
  def self.identify_user(graph_user, session)
    user = User.find_by(email: graph_user.user_principal_name)
    user ||= User.create(email: graph_user.user_principal_name, name: graph_user.given_name, last_name: graph_user.surname)
    user_session = Session.find_by(session_id: session.id)
    user_session.update_columns(user_id: user.id) unless user_session.user_id == user.id
  end
end
