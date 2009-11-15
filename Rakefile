require 'rake'
require 'net/sftp'
require 'fileutils'
require 'yaml'

conf = YAML.load(IO.read('host.yml'))

USERNAME = conf['host']['user']
HOST = conf['host']['url']
REMOTE_ROOT = conf['host']['root']
print "SSH password: " unless conf['host'].has_key?('pass')
PASSWORD = conf['host'].has_key?('pass') ? conf['host']['pass'] : STDIN.gets.strip!

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
	_start = Time.now
	
	puts "\ndeleting generated site"
	Rake::Task['purge'].execute
	
	puts "\ngenerating site"
  Rake::Task['generate'].execute
    
  Dir.chdir('_site')

	Net::SSH.start(HOST, USERNAME, :password => PASSWORD ) do |ssh|
		puts "\nSSH login successful!"
		
		ssh.sftp.connect do |sftp|
			puts "SFTP login successful!"
			
			puts "\nremoving local files"
			
			["Rakefile","iruel.net.kpf","README.textile","host.yml","new_post","new_post.cyg.sh"].each {|e| puts "\tdeleting #{e}"; File.delete e }
			
			puts "\ninitiating upload..."
			
			FileList['**/*'].each do |file|
				if File.directory? file
					puts "\tcreating dir #{file}"
					begin
						sftp.mkdir! REMOTE_ROOT + file
					rescue Net::SFTP::StatusException
						puts "\tWARNING: removing #{file}"
						ssh.exec! 'rm -Rf ' + REMOTE_ROOT + file
						retry
					end
				else
					puts "\tuploading file #{file}"
					begin
						sftp.upload! file, REMOTE_ROOT + file
					rescue Net::SFTP::StatusException
						puts "\tWARNING: removing #{file}"
						ssh.exec! 'rm -Rf ' + REMOTE_ROOT + file
					end
				end
			end

		end
	end
	
	Dir.chdir('..')
		
	puts "\ndeleting generated site"
	Rake::Task['purge'].execute
	
	puts "\ndone! (#{(Time.now - _start).to_s})"
end
