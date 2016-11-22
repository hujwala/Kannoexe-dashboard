require 'octokit'

SCHEDULER.every '20m', :first_in => 0 do |job|
  client = Octokit::Client.new(:access_token => "a1602c4c2172421200f240d3823ce527d1a58dd1")
  my_organization = "Qwinix"
  repos = "konnexe-rails"

  open_pull_requests = [repos].inject([]) { |pulls, repo|
    client.pull_requests("Qwinix/konnexe-rails", :state => 'open').each do |pull|
      pulls.push({
        title: pull.title,
        repo: repo,
        updated_at: pull.updated_at.strftime("%b %-d %Y"),
        creator: "@" + pull.user.login,
        })
    end
    pulls[0..4]

  }

  send_event('github', { header: "Open Pull Requests", pulls: open_pull_requests })
end