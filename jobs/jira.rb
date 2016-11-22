require 'jira-ruby'

host = "qwinix.atlassian.net/secure/RapidBoard.jspa?rapidView=288&view=planning.nodetail"
username = "upatel"
password = "Qwinix123"
 project = "Konnexe"
status = "OPEN"

options = {
            :username => username,
            :password => password,
            :context_path => '',
            :site     => host,
            :auth_type => :basic
          }

SCHEDULER.every '1h', :first_in => 0 do |job|

  client = JIRA::Client.new(options)
  num = 0;

  client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{status}\"").each do |issue|
      num+=1
  end
  send_event('jira', { current: num})
end


