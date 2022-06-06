class UserLoginSerializer < ActiveModel::Serializer
  attributes :uid, :email, :name, :role, :ws_token

  def ws_token
    @instance_options[:ws_token]
  end

end