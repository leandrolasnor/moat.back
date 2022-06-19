module Auth
  SIGN_IN_HEADER = {"Content-Type": "application/json"}
  def sign_in(user: nil)
    user = {email: 'teste@teste.com', password: '123456'} if user.nil?
    post user_session_path, params: {:email => user[:email], :password => user[:password]}.to_json, headers: SIGN_IN_HEADER
    {body: JSON.parse(response.body, symbolize_names: true), headers: response.headers }
  end
end