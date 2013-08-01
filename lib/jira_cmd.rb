require 'nokogiri'
require 'open-uri'
require 'mixlib/cli'

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class JiraOptions
  include Mixlib::CLI

  option :mine,
    long: '--mine',
    short: '-m'

  option :issue,
    long: '--issue ISSUE',
    short: '-i ISSUE'

  option :user,
    long: '--user USER',
    short: '-u USER'

  option :release,
    long: '--release RELEASE',
    short: '-r RELEASE'

  option :server,
    long: '--server SERVER',
    short: '-s SERVER'

  option :current_user,
    long: '--current_user CURRENT_USER',
    short: '-c CURRENT_USER'

end

class JiraQuery

  attr_accessor :issues

  def initialize(params={})
    @search_url = params[:url]
    @issues = []
  end

  def process
    @document = Nokogiri::XML(open(@search_url))
    # puts @document
    @document.xpath('//item').each do |item|
      @issues << "#{item.css('status').first.content.chomp.ljust(20)} #{item.css('title').first.content.chomp}"
    end
  end
end

class JiraCmd

  attr_accessor :server, :user

  def intialize(_server, _user)
    @server = _server
    @user = _user
  end

  def get_mine
    get_user user
  end

  def get_user(user)
    my_issues_url = "https://#{server}/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?jqlQuery=assignee+%3d+'#{user}'+and+status+!%3d+'closed'"
    jira = JiraQuery.new url: my_issues_url
    jira.process
    puts "#{user.upcase} ISSUES"
    puts jira.issues
  end

  def get_issue(issue)
    my_issues_url = "https://#{server}/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?jqlQuery=key+%3d+'#{issue}'"
    jira = JiraQuery.new url: my_issues_url
    jira.process
    puts jira.issues
  end

  def get_in_release(release)
    return if release.nil? || release.empty?

    all_in_release="https://#{server}/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?jqlQuery=project+%3d+CTII+and+fixVersion+%3d+#{release}+and+status+%3d+%22Todo/User+Story%22+and+type+!%3d+%22Automated+Test%22+order+by+priority"
    all_jira = JiraQuery.new url: all_in_release
    all_jira.process

    puts "IN #{release}"
    puts all_jira.issues
  end

end


