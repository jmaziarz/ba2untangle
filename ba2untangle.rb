#!/usr/bin/env ruby

require 'csv'
require 'base64'
require 'digest/md5'
require 'digest/sha1'
require 'json'

untangle_users = { javaClass: "java.util.LinkedList", list: [] }

CSV.foreach("./data/volunteer-export.csv") do |row|
  user = { email: row[4], 
           firstName: row[1], 
           javaClass: "com.untangle.uvm.LocalDirectoryUser", 
           lastName: row[2], 
           passwordBase64Hash: Base64.strict_encode64(row[0]), 
           passwordMd5Hash: Digest::MD5.hexdigest(row[0]), 
           passwordShaHash: Digest::SHA1.hexdigest(row[0]), 
           username: row[3] }
 
  # Skip the header row 
  unless row[3] == 'Username'
    untangle_users[:list] << user
  end
end

puts JSON.pretty_generate(untangle_users)
