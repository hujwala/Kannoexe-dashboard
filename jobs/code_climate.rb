require 'net/http'
require 'json'
require 'pry'

SCHEDULER.every '10s', :first_in => 0 do |job|
  repo_id = "58368748b4a890008c001b47"
  api_token = "255887c05d5a64ea167e4d3455f63d8f71574536"
  uri = URI.parse("https://codeclimate.com/api/repos/#{repo_id}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request.set_form_data({api_token: api_token})
  response = http.request(request)
  stats = JSON.parse(response.body)
  current_gpa = stats['last_snapshot']['gpa'].to_f
  covered_percent = stats['last_snapshot']['covered_percent'].to_f
  send_event("code-climate", {current: current_gpa, percent_covered: covered_percent})
end



# CODECLIMATE_REPO_TOKEN=4b83522bcc0c0471a90ae45e94e6b965f6b322bac7e4e525791aaf20b63adda2 bundle exec codeclimate-test-reporter