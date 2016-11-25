require 'octokit'

SCHEDULER.every '1h', :first_in => 0 do |job|
  client = Octokit::Client.new(:access_token => "4f4a31d01218f9810d212470c53f2766a2cae7e2")
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