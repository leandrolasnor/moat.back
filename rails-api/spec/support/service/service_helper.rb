module Service
  def successful_body_content
    "{\"code\":0,\"message\":\"ok\"}"
  end

  def successful_response
    {:content=>{:code=>0, :message=>"ok"}, :status=>:ok}
  end
end