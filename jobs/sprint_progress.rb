require 'jira-ruby'
require 'pry'

SCHEDULER.every '1h', :first_in => 0 do |job|

    client = JIRA::Client.new({
    :username => "upatel",
    :password => "Qwinix123",
    :site => "https://qwinix.atlassian.net/secure/RapidBoard.jspa?rapidView=288/",
    :auth_type => :basic,
    :context_path => ""
  })
  inprogress_points = client.Issue.jql("sprint in openSprints() and status = \"IN PROGRESS\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  inprogress = inprogress_points.inject(0, :+)

   todo_points = client.Issue.jql("sprint in openSprints() and status = \"TO DO\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  todo = todo_points.inject(0, :+)

  qa_points = client.Issue.jql("sprint in openSprints() and status = \"QA\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  qa1_points = client.Issue.jql("sprint in openSprints() and status = \"READY FOR QA\"").map{ |issue| issue.fields['customfield_10004'] }.compact

  qa = qa_points.inject(0, :+) + qa1_points.inject(0, :+)


  st_points = client.Issue.jql("sprint in openSprints() and status = \"QUALITY CHECKED IN ST\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  st = st_points.inject(0, :+)

    reopened_points = client.Issue.jql("sprint in openSprints() and status = \"Reopened\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  reopened = reopened_points.inject(0, :+)

  # QUALITY CHECKED IN ST
  # Reopened

  total_points = client.Issue.jql("sprint in openSprints()").map{ |issue| issue.fields['customfield_10004']}.compact
  totalpoints = total_points.inject(0, :+)




if totalpoints == 0
    moreinfo = "No sprint currently in progress"
  else
    percentage_todo = ((todo/totalpoints)*100).to_i
    percentage_qa = ((qa/totalpoints)*100).to_i
    percentage_inprogress = ((inprogress/totalpoints)*100).to_i
    percentage_st = ((st/totalpoints)*100).to_i
    percentage_reopened = ((reopened/totalpoints)*100).to_i
  end


  send_event('sprint_progress', { title: "Sprint Progress", min: 0, value: percentage_todo, progress_in: percentage_inprogress, progress_qa: percentage_qa, progress_st: percentage_st, progress_reopen: percentage_reopened,  max: 100, moreinfo: moreinfo })
end