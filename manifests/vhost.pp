# Class: java_web_application_server
#
# This class installs a java web application onto a tomcat instance
#
# Parameters:
#   (string) application
#              - The application this instance should host
#   (hash)   available_applications
#              - The applications available to host
#   (has)    available_resources
#              - The resources available to the applications
#   (int)    tomcat_http_port
#              - HTTP port this application can be found on
#   (int)    tomcat_ajp_port
#               - If AJP is used the web front end can integrate here
#   (int)    tomcat_server_port
#               - The server control port for Tomcat
#   (string) balancer
#               - Name of the balancer tomcat instance is assigned to
#   (enum)   ensure
#               - present, running, installed, stopped or absent
#   (string) instance_basedir
#               - The directory the tomcat instance will be installed
#
# Actions:
#   Install tomcat instance
#   Install application
#   Restart tomcat service
#
# Requires:
#   puppetlabs/tomcat
#
define balancer::vhost (
  $port,
  $servername,
  $docroot     = '/var/www') {

  ::apache::vhost { $name:
    port       => $port,
    servername => $servername,
    docroot    => $docroot,
    proxy_pass => [
      { 'path' => '/', 'url' => "balancer://${name}/"},
      { 'path' => '/*', 'url' => "balancer://${name}/"},
    ],
  }

  ::apache::balancer { $name:
    collect_exported => true,
    proxy_set => {'stickysession' => 'JSESSIONID', 'nofailover' => 'On'},
  }
}
