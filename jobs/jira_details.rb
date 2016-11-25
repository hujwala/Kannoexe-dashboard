require 'jira-ruby'

SCHEDULER.every '1h', :first_in => 0 do |job|
  client = JIRA::Client.new({
    :username => "upatel",
    :password => "Qwinix123",
    :site => "https://qwinix.atlassian.net/secure/RapidBoard.jspa?rapidView=288",
    :auth_type => :basic,
    :context_path => ""
  })


  todo_points = client.Issue.jql("sprint in openSprints() and status = \"To Do\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  progress_points = client.Issue.jql("sprint in openSprints() and status = \"In Progress\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  qa_points = client.Issue.jql("sprint in openSprints() and status = \"QA\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0

  send_event('jira_details', { title: "Jira Story Point Details", progress: progress_points, todo: todo_points, qa: qa_points })
end