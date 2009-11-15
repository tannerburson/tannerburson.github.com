require 'rake'
require 'net/sftp'
require 'fileutils'
require 'yaml'

USERNAME = ''
PASSWORD = ''
HOST = ''
REMOTE_ROOT = '/home/public/'

task :default => :upload

#desc 'create new post'
task :post, :title do |task, args|
	title = args[:title]
	
	puts "creating new post #{title[1,title.length].gsub('-',' ')}"
	
	now = Time.now
	
	filename = now.year.to_s + '-' + now.month.to_s + '-' + now.day.to_s + title + '.textile'
	
	File.new( '_posts/' + filename, 'w')
	
	File.open( '_posts/' + filename, 'w') do |file|
		file.puts "---"
		file.puts "layout: post"
		file.puts "title: #{title[1,title.length].gsub('-',' ')}"
		file.puts "tags: [random]"
		file.puts "author_name: Bruno A"
		file.puts "author_uri: http://twitter.com/sardaukar_siet"
		file.puts "---"
		file.puts ""
	end
	
	puts "\npost created, filename is _posts/#{filename}"
end

desc 'generate static content'
task :generate do
  system 'jekyll'
end

desc 'purge generated site'
task :purge do
  FileUtils.rm_rf '_site'
end

desc 'upload to NFS'
task :upload do	
	puts "deleting generated site"
	Rake::Task['purge'].execute
	
	puts "generating site"
  Rake::Task['generate'].execute
    
  Dir.chdir('_site')

	Net::SSH.start(HOST, USERNAME, :password => PASSWORD ) do |ssh|
		puts "SSH login successful!"
		
		ssh.sftp.connect do |sftp|
			puts "SFTP login successful!"
			
			["Rakefile","iruel.net.kpf"].each {|e| puts "deleting #{e}"; File.delete e }
			
			FileList['**/*'].each do |file|
				if File.directory? file
					puts "creating dir #{file}"
					begin
						sftp.mkdir! REMOTE_ROOT + file
					rescue Net::SFTP::StatusException
						puts "WARNING: removing #{file}"
						ssh.exec! 'rm -Rf ' + REMOTE_ROOT + file
						retry
					end
				else
					puts "uploading file #{file}"
					begin
						sftp.upload! file, REMOTE_ROOT + file
					rescue Net::SFTP::StatusException
						puts "WARNING: removing #{file}"
						ssh.exec! 'rm -Rf ' + REMOTE_ROOT + file
					end
				end
			end

		end
	end
	
	Dir.chdir('..')
		
	puts "deleting generated site"
	Rake::Task['purge'].execute
	
	puts "done!"
end
