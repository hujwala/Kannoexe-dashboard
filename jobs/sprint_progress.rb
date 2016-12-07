require 'jira-ruby'
require 'pry'

SCHEDULER.every '10s', :first_in => 0 do |job|

    client = JIRA::Client.new({
    :username => "upatel",
    :password => "Qwinix123",
    :site => "https://qwinix.atlassian.net/secure/RapidBoard.jspa?rapidView=288/",
    :auth_type => :basic,
    :context_path => ""
  })
  closed_points = client.Issue.jql("sprint in openSprints() and status = \"QUALITY CHECKED IN ST\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  s1 = closed_points.inject(0, :+)
  total_points = client.Issue.jql("sprint in openSprints()").map{ |issue| issue.fields['customfield_10004']}.compact
  s2 = total_points.inject(0, :+)

  if s1 == 0
    percentage = 0
    moreinfo = "No sprint currently in progress"
  else
    percentage = ((s1/s2)*100).to_i
    moreinfo = "#{s1.to_i} / #{s2.to_i}"
  end

  send_event('sprint_progress', { title: "Sprint Progress", min: 0, value: percentage, max: 100, moreinfo: moreinfo })
end