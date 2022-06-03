module Auth
  def get_headers(admin: 0)
    user = User.where(uid: 'teste@teste.com')
    user = User.create!(email: 'teste@teste.com',password: '123456',password_confirmation: '123456', role: admin) if user.blank?
    sign_in_header = {"Content-Type": "application/json"}
    post user_session_path, params: {:email => "teste@teste.com", :password => "123456"}.to_json, headers: sign_in_header
    headers = {
      "access-token" => response.headers['access-token'],
      "uid" => response.headers['uid'],
      "client" => response.headers['client']
    }
    return headers
  end
end