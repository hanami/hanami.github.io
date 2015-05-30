require 'rubygems'
require 'bundler/setup'
require 'httparty'
require 'uri'

module Lotus
  class Changelog

    Issue = Struct.new(:title, :pull_url, :user) do
      def user_name
        user.name == '' ? user.login : user.name
      end

      def user_url
        user.profile_url
      end
    end
    User = Struct.new(:login, :name, :profile_url)
    RubyGem = Struct.new(:name, :built_at, :version)
    PullRequest = Struct.new(:title, :pull_url, :user) do
      def user_name
        user.name == '' ? user.login : user.name
      end

      def user_url
        user.profile_url
      end
    end

    REPOS = ['lotus', 'controller', 'view', 'model', 'utils', 'validations', 'router', 'helpers']
    GEMS = ['lotusrb', 'lotus-controller', 'lotus-view', 'lotus-model', 'lotus-utils', 'lotus-validations', 'lotus-router', 'lotus-helpers', 'lotus-assets']

    BLOG_POST = <<EOF
---
title: Weekly Changelog
date: %{date}
tags: changelog
author: %{author}
excerpt: >
  Changelog from %{from} to %{to}
---

## Releases

%{release}

## Completed

%{completed}

## Development

%{development}

## Roadmap

[Trello board](http://bit.ly/lotusrb-roadmap)

EOF

    # @param from [Date] the merged at lower limit
    # @param to [Date] the merged at upper limit
    # @param author [String] name of the post author
    def initialize(from, to = DateTime.now.to_date, author = "Trung Lê")
      @from = from
      @to   = to
      @author = author

      @users = {}
    end

    def generate_all
      output = BLOG_POST % {date: date, from: from_date, author: author, to: to_date, release: releases_list, completed: completed_list, development: development_list}

      file = "source/blog/#{DateTime.now.strftime('%F')}-weekly-changelog.html.markdown"
      puts "Write to file #{file} ..."

      File.open(file, 'w') do |f|
        f.write(output)
      end
    end

    private

    attr_reader :from, :to, :author
    attr_accessor :users

    def date
      DateTime.now.strftime('%F %R UTC')
    end

    def from_date
      from.strftime('%h %d %Y')
    end

    def to_date
      to.strftime('%h %d %Y')
    end

    def completed_list
      get_completed_prs.join("\n")
    end

    def development_list
      get_devel_prs.join("\n")
    end

    def releases_list
      get_gem_releases.join("\n")
    end

    def get_completed_prs
      issues = []

      puts "Building Completed List .."

      get_completed_issues.each do |i|
        login = i['user']['login']

        unless users[login]
          u = get_user_profile_for(login)
          users[login] = User.new(u['login'], u['name'], u['html_url'])
        end
        issues << Issue.new(i['title'], i['html_url'], users[login])
      end

      issues.map { |i| "  * [[#{i.user_name}](#{i.user_url})] #{i.title} [[details](#{i.pull_url})]" }
    end

    def get_devel_prs
      pulls = []

      puts "Building Development List .."

      REPOS.each do |repo|
        puts "Collecting data from repo lotus/#{repo}"

        get_open_pulls_for(repo).each do |i|
          login = i['head']['user']['login']

          unless users[login]
            u = get_user_profile_for(login)
            users[login] = User.new(u['login'], u['name'], u['html_url'])
          end
          pulls << PullRequest.new(i['title'], i['html_url'], users[login])
        end

      end

      pulls.map { |p| "  * [[#{p.user_name}](#{p.user_url})] #{p.title} [[details](#{p.pull_url})]" }
    end

    def get_gem_releases
      gems = []

      puts "Building Releases List .."

      GEMS.each do |gem_name|
        puts "Collecting data from gem #{gem_name}"

        gems << get_info_for(gem_name).map { |g| RubyGem.new(gem_name, g['built_at'], g['number']) }.max { |a, b| a.built_at <=> b.built_at }
      end

      gems.map { |g| "  * Released #{g.name} #{g.version}" }
    end

    def issues_url
      repo_query = REPOS.map { |r| "repo:lotus/#{r}" }.join('+')
      merged_query = "merged:>=#{from.strftime('%F')}+merged:<=#{to.strftime('%F')}"
      URI::HTTPS.build(host: 'api.github.com', path: '/search/issues', query: "q=#{repo_query}+#{merged_query}").to_s
    end

    def pulls_url_for(repo)
      URI::HTTPS.build(host: 'api.github.com', path: "/repos/lotus/#{repo}/pulls", query: 'state=open').to_s
    end

    def user_profile_url_for(login)
      URI::HTTPS.build(host: 'api.github.com', path: "/users/#{login}").to_s
    end

    def gem_url_for(gem_name)
      URI::HTTPS.build(host: 'rubygems.org', path: "/api/v1/versions/#{gem_name}.json").to_s
    end

    def get_user_profile_for(login)
      response = HTTParty.get(user_profile_url_for(login))

      if response.success?
        response
      else
        raise "Could not query user #{login}"
      end
    end

    def get_completed_issues
      response = HTTParty.get(issues_url)

      if response.success?
        response['items']
      else
        raise "Could not query #{issues_url}"
      end
    end

    def get_info_for(gem_name)
      response = HTTParty.get(gem_url_for(gem_name))

      if response.success?
        response
      else
        raise "Could not query gem #{gem_name}"
      end
    end

    def get_open_pulls_for(repo)
      response = HTTParty.get(pulls_url_for(repo))

      if response.success?
        response
      else
        raise "Could not query PRs for #{repo}"
      end
    end

  end
end
