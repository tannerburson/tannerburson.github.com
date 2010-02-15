require 'rake'
require 'fileutils'
require 'yaml'

task :publish do |task, args|
  raise "please indicate post title with title=\"....\"" if args[:title].nil?
  title = args[:title].gsub(' ','-')
  Dir['_posts/*'+title+'*.*'].each do |f|
	puts "marking #{f} for publish..."
	post = nil
	File.open(f) do |p|
	  post = p.readlines
	end
	in_yml = false
	File.open(f,'w') do |p|
	  post.each do |line|
		in_yml = !in_yml if "---" == line.chomp.strip
		p.puts line unless (in_yml && "published: false" == line.chomp.strip)
	  end
	end
	now = Time.now
	parts = f.split('-')
	last = parts[3,parts.length].join("-")
	new_f = "_posts/" +now.year.to_s + '-' + now.month.to_s + '-' + now.day.to_s + '-' + last
	FileUtils.mv f, new_f if f != new_f
	puts "published #{f} as #{new_f}"
  end
end

#desc 'create new draft post'
task :post, :title do |task, args|
	raise "please indicate post title with title=<...>" if args[:title].nil?
	title = args[:title].gsub(' ','-')
	
	puts "creating new post #{title}"
	
	now = Time.now
	
	filename = now.year.to_s + '-' + now.month.to_s + '-' + now.day.to_s + '-' +  title + '.textile'
	
	File.new( '_posts/' + filename, 'w')
	
	File.open( '_posts/' + filename, 'w') do |file|
		file.puts "---"
		file.puts "layout: post"
		file.puts "title: #{title.gsub('-',' ')}"
		file.puts "tags: [random]"
		file.puts "author_name: Tanner Burson"
		file.puts "author_uri: http://twitter.com/tannerburson"
		file.puts "published: false"
		file.puts "---"
		file.puts ""
	end
	
	puts "\npost created, filename is _posts/#{filename}"
end

desc 'List all draft posts'
task :drafts do
    puts `grep -l 'published: false' _posts/*`
end

desc 'generate static content'
task :generate do
  system 'jekyll'
end

desc 'purge generated site'
task :purge do
  FileUtils.rm_rf '_site'
end
