#!/usr/bin/env ruby

require 'csv'
require 'base64'
require 'digest/md5'
require 'digest/sha1'
require 'json'

untangle_users = { javaClass: "java.util.LinkedList", list: [] }
usernames = []

CSV.foreach("./data/volunteer-export.csv") do |row|
  # firstName, lastName, and username can only be alphanumeric (including underscore)
  password  = row[0]
  first_name = row[1].gsub(/\W/, '')
  last_name  = row[2].gsub(/\W/, '')
  username  = row[3].gsub(/\W/, '')

  # Skip the header row
  if username == 'Username'
    next
  end

  # Skip duplicates
  if usernames.include?(username)
    next
  else
    usernames << username
  end

  user = { email: row[4], 
           firstName: first_name, 
           javaClass: "com.untangle.uvm.LocalDirectoryUser", 
           lastName: last_name, 
           passwordBase64Hash: Base64.strict_encode64(password), 
           passwordMd5Hash: Digest::MD5.hexdigest(password), 
           passwordShaHash: Digest::SHA1.hexdigest(password), 
           username: username }
 
  untangle_users[:list] << user
end

puts JSON.pretty_generate(untangle_users)
