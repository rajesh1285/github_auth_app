class GithubController < ApplicationController

	def sign_in
		@client_id = ENV["CLIENT_ID"]
		@client_secret = ENV["CLIENT_SECRET"]
		@redirect_uri = 'http://localhost:3000/github/auth_callback'
	end

	def auth_callback
	  code = params[:code]
	  @client_id = ENV["CLIENT_ID"]
	  @client_secret = ENV["CLIENT_SECRET"]
	  redirect_uri = "http://localhost:3000/github/auth_callback"
	  response = HTTParty.post("https://github.com/login/oauth/access_token?client_id=#{@client_id}&client_secret=#{@client_secret}&code=#{code}&redirect_uri=#{redirect_uri}")
	  data = Rack::Utils.parse_nested_query(response.parsed_response)
	  session[:access_token] = data['access_token']
	  session[:token_type] = data['token_type'] 
	  redirect_to '/github/user_repos'
	end

	def user_repos
	  response = HTTParty.get('https://api.github.com/user', headers: {"Authorization" => "#{session[:token_type]} #{session[:access_token]}", "User-Agent" => "test"})
	  @data = response.parsed_response
	  response = HTTParty.get("https://api.github.com/user/repos", headers: {"Authorization" => "#{session[:token_type]} #{session[:access_token]}", "User-Agent" => "test"})
	  @repos = response.parsed_response
	end
end



