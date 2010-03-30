#
# Configuration for building a war file
# By Robert Egglestone
#    Fausto Lelli
#
require 'util'
require 'action_mailer/adv_attr_accessor'

module War
  class Configuration
    include Singleton

    # allow a getter to be used as a setter as well, makes config files sane
    include ActionMailer::AdvAttrAccessor
    class << self
      alias attr_accessor adv_attr_accessor
    end

    # the name of the project
    attr_accessor :name
    # the path and name of the war_file
    attr_accessor :war_file
    # path to the staging directory
    attr_accessor :staging
    # a list of patterns of excluded files
    attr_accessor :excludes
    # project java libraries are stored here
    attr_accessor :local_java_lib
    # servlet to use for running Rails
    attr_accessor :servlet
    # enable jndi support?
    attr_accessor :datasource_jndi
    attr_accessor :datasource_jndi_name

    # external locations
    attr_accessor :jruby_home
    attr_accessor :maven_local_repository
    attr_accessor :maven_remote_repository

    # compile ruby files? currently only preparses files, but has problems with paths
    attr_accessor :compile_ruby
    # keep source if compiling ruby files?
    attr_accessor :keep_source
    # if you set this to false gems will fail to load if their dependencies aren't available
    attr_accessor :add_gem_dependencies
    # standalone?
    attr_accessor :standalone
    # rails environment?
    attr_accessor :rails_env
    # rails environment to use when running with an embedded server?
    attr_accessor :rails_env_embedded

    # files to include in the package
    attr_accessor :files
    # java libraries to include in the package
    attr_accessor :java_libraries
    # gem libraries to include in the package
    attr_accessor :gem_libraries
    # jetty libraries, used for running the war
    attr_accessor :jetty_libraries

    # the real separator for the operating system
    attr_accessor :os_separator
    attr_accessor :os_path_separator
    
    attr_accessor :jetty_port
    attr_accessor :jetty_java_opts
    
    # custom tasks to run when assembling the war
    attr_accessor :custom_tasks

    def initialize
      WLog.debug("Initializing configuration ...")
      
      # initialize variables
      @excludes = []
      @files = {}
      @custom_tasks = []
      
      # defaults
      @name = File.basename(File.expand_path(RAILS_ROOT))
      @staging = RAILS_ROOT
      @local_java_lib = File.join('lib', 'java')

      # default build properties
      @compile_ruby = false
      @keep_source =  false
      @add_gem_dependencies = true
      @servlet = 'org.jruby.webapp.RailsServlet'
      @rails_env = 'production'
      @rails_env_embedded = ENV['RAILS_ENV'] || 'development'
      @datasource_jndi = false

      home = ENV['HOME'] || ENV['USERPROFILE']
      @jruby_home = ENV['JRUBY_HOME']
      @maven_local_repository = ENV['MAVEN2_REPO'] # should be in settings.xml, but I need an override
      @maven_local_repository ||= File.join(home, '.m2', 'repository') if home
      @maven_remote_repository = 'http://repo1.maven.org/maven2'

      # default java libraries
      @java_libraries = {}
      add_library('goldspike', :version => '1.6.1', :group => 'org.jruby.extras')
      add_library('activation', :version => '1.1', :group => 'javax.activation')
      add_library('commons-pool', :version => '1.3', :group => 'commons-pool')
      #add_library('bcprov-jdk14', :version => '124', :group => 'bouncycastle')

      # default gems
      @gem_libraries = {}
      add_gem('rails', rails_version) unless File.exists?('vendor/rails')
      add_gem('activerecord-jdbc-adapter') if Dir['vendor/{gems/,}{activerecord-jdbc-adapter,ActiveRecord-JDBC}'].empty?

      # default jetty settings
      @jetty_libraries = {}
      @jetty_port = 8080
      @jetty_java_opts = ENV['JETTY_OPTS'] || ENV['JAVA_OPTS'] || ''
      jetty_version '6.1.5'
      
      # separators
      if RUBY_PLATFORM =~ /(mswin)|(cygwin)/i # watch out for darwin
        @os_separator = '\\'
        @os_path_separator = ';'
      elsif RUBY_PLATFORM =~ /java/i
        @os_separator = java.io.File.separator
        @os_path_separator = java.io.File.pathSeparator
      else
        @os_separator = File::SEPARATOR
        @os_path_separator = File::PATH_SEPARATOR
      end

      # load user configuration
      WLog.debug("Loading user configuration ...")
      load_user_configuration

      @add_jruby_complete = true
      
      add_library('jruby-complete', :version => '1.1', :group => 'org.jruby') if @add_jruby_complete
    end # initialize
    
    def war_file(value = @war_file)
      @war_file = value
      @war_file || "#{name}.war"
    end
    
    def exclude_files(pattern)
      @excludes << pattern
    end

    def datasource_jndi_name
      @datasource_jndi_name || "jdbc/#{name}"
    end
    
    def jetty_version(version)
      for name in %w(start jetty jetty-util jetty-plus jetty-naming servlet-api-2.5) do
        add_jetty_library(:name => name, :version => version, :group => 'org.mortbay.jetty')
      end
    end

    # Get the rails version from environment.rb, or default to the latest version
    # This can be overriden by using add_gem 'rails', ...
    def rails_version
      environment_without_comments = IO.readlines(File.join('config', 'environment.rb')).reject { |l| l =~ /^#/ }.join
      environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
      version = $1
      version ? "= #{version}" : nil
    end

    def load_user_configuration
      user_config = ENV['WAR_CONFIG'] || File.join(RAILS_ROOT, 'config', 'war.rb')
      if File.exists?(user_config)
        begin
          instance_eval(File.read(user_config), user_config)
        rescue => e
          WLog.error("Error reading user configuration (#{e.message}), using defaults")
          puts e.backtrace.join("\n")
        end
      end
    end

    def java_library(name, version)
      # exists for backwards compatibility
      add_library(name, :version => version)
    end

    def maven_library(group, name, version)
      # exists for backwards compatibility
      add_library(name, :group => group, :version => version)
    end

    def local_jruby(local=true)
      if local
        add_library("jruby-complete", :version => '1.1')
        @add_jruby_complete = false
      end
    end
    
    def add_library(*args)
      lib = create_library(*args)
      @java_libraries[lib.name] = lib
    end
    
    def remove_library(name, properties={})
      # remove a library that matches name and all specified properties
      @java_libraries.delete_if {|k,v| k == name && v == v.merge(properties) }
    end

    def add_jetty_library(*args)
      lib = create_library(*args)
      @jetty_libraries[lib.name] = lib
    end

    def remove_jetty_library(name, properties={})
      # remove a library that matches name and all specified properties
      @jetty_libraries.delete_if {|k,v| k == name && v == v.merge(properties) }
    end

    def add_gem(name, match_version=nil)
      @gem_libraries[name] = match_version
    end

    def remove_gem(name)
      @gem_libraries.delete(name)
    end

    def add_file(name, info)
      @files[name] = {:location => "war/#{name}", :directory => :classes }.merge(info)
    end
    
    def remove_file(name)
      @files.delete_if {|k,v| k == name }
    end

    def add_custom_task(&task)
      @custom_tasks << task
    end

    # method hook for default behaviour when an unknown property is met.
    # Just ignore it and print a warning message.
    def method_missing(name, *args)
      WLog.warn("Property '#{name}' in config file is not defined, ignoring it...")
    end

    private
    
      def create_library(*args)
        properties = {}
        # optional first arg is name
        if !args.empty? && args[0].is_a?(String)
          properties[:name] = args.shift
        end
        # followed by a hash of properties
        if !args.empty?
          unless args[0].is_a?(Hash)
            WLog.warn("Skipping add_library due to syntax error: add_library(#{args.join(', ')})")
            return
          end
          properties.merge!(args[0])
        end
      
        name = properties[:name]
        group = properties[:group]
        version = properties[:version]
        if group
          WLog.debug("add maven library: #{group} #{name} #{version}")
          lib = MavenLibrary.new(group, name, version, self)
        else
          WLog.debug("add java library: #{name} #{version}")
          lib = JavaLibrary.new(name, version, self)
        end
      end

  end #class
end #module
