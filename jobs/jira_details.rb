require 'jira-ruby'

SCHEDULER.every '2m', :first_in => 0 do |job|
  client = JIRA::Client.new({
    :username => "upatel",
    :password => "Qwinix",
    :site => "qwinix.atlassian.net/secure/RapidBoard.jspa?rapidView=288&view=planning.nodetail",
    :auth_type => :basic,
    :context_path => ""
  })


  closed_points = client.Issue.jql("sprint in openSprints() and status = \"Done\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  todo_points = client.Issue.jql("sprint in openSprints() and status = \"To Do\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  progress_points = client.Issue.jql("sprint in openSprints() and status = \"In Progress\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  qa_points = client.Issue.jql("sprint in openSprints() and status = \"Assign to QA\"").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0
  total_points = client.Issue.jql("sprint in openSprints()").map{ |issue| issue.fields['customfield_10004'] }.reduce(:+) || 0

  send_event('jira_details', { title: "Jira Story Point Details", value: closed_points, total: total_points, progress: progress_points, todo: todo_points, qa: qa_points })
end