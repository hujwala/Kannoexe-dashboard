require 'jira-ruby'
require 'pry'

# SCHEDULER.every '10s', :first_in => 0 do |job|

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

  qa_points = client.Issue.jql("sprint in openSprints() and status = \"READY FOR QA\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  qa = qa_points.inject(0, :+)

  st_points = client.Issue.jql("sprint in openSprints() and status = \"QUALITY CHECKED IN ST\"").map{ |issue| issue.fields['customfield_10004'] }.compact
  st = st_points.inject(0, :+)


  total_points = client.Issue.jql("sprint in openSprints()").map{ |issue| issue.fields['customfield_10004']}.compact
  totalpoints = total_points.inject(0, :+)


    percentage_todo = ((todo/totalpoints)*100).to_i
    percentage_qa = ((qa/totalpoints)*100).to_i
    percentage_inprogress = ((inprogress/totalpoints)*100).to_i
    if st == 0
      moreinfo = 0
    else
    percentage_st = ((st/totalpoints)*100).to_i
    end


  send_event('sprint_progress', { title: "Sprint Progress", min: 0, value: percentage_todo, progress: percentage_inprogress, progress_qa: percentage_qa, progress_st: percentage_st, max: 100 })
# end