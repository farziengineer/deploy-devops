#!/usr/bin/perl
# Install iiidevops applications script
#
use FindBin qw($Bin);
my $p_config = "$Bin/../env.pl";
if (!-e $p_config) {
	print("The configuration file [$p_config] does not exist!\n");
	exit;
}
require($p_config);

# Deploy Redmine on kubernetes cluster
# Modify redmine/redmine-postgresql/redmine-postgresql.yml.tmpl <- {{redmine_db_passwd}} {{nfs_ip}}
$yaml_path = "$Bin/../redmine/redmine-postgresql/";
$yaml_file = $yaml_path.'redmine-postgresql.yml';
$tmpl_file = $yaml_file.'.tmpl';
if (!-e $tmpl_file) {
	print("The template file [$tmpl_file] does not exist!\n");
	exit;
}
$template = `cat $tmpl_file`;
$template =~ s/{{redmine_db_passwd}}/$redmine_db_passwd/g;
$template =~ s/{{nfs_ip}}/$nfs_ip/g;
#print("-----\n$template\n-----\n\n");
open(FH, '>', $yaml_file) or die $!;
print FH $template;
close(FH);
$cmd = "kubectl apply -f $yaml_path";
print("Deploy redmine-postgresql..\n");
$cmd_msg = `$cmd`;
print("-----\n$cmd_msg\n-----\n\n");

# Modify redmine/redmine/redmine-deployment.yml.tmpl <- {{redmine_db_passwd}}
$yaml_path = "$Bin/../redmine/redmine/";
$yaml_file = $yaml_path.'redmine-deployment.yml';
$tmpl_file = $yaml_file.'.tmpl';
if (!-e $tmpl_file) {
	print("The template file [$tmpl_file] does not exist!\n");
	exit;
}
$template = `cat $tmpl_file`;
$template =~ s/{{redmine_db_passwd}}/$redmine_db_passwd/g;
#print("-----\n$template\n-----\n\n");
open(FH, '>', $yaml_file) or die $!;
print FH $template;
close(FH);
$cmd = "kubectl apply -f $yaml_path";
print("Deploy redmine..\n");
$cmd_msg = `$cmd`;
print("-----\n$cmd_msg\n-----\n\n");

# Deploy SonarQube Server on kubernetes cluster
# Modify sonarqube/sonar-server-deployment.yaml.tmpl <- {{nfs_ip}}
$yaml_path = "$Bin/../sonarqube/";
$yaml_file = $yaml_path.'sonar-server-deployment.yaml';
$tmpl_file = $yaml_file.'.tmpl';
if (!-e $tmpl_file) {
	print("The template file [$tmpl_file] does not exist!\n");
	exit;
}
$template = `cat $tmpl_file`;
$template =~ s/{{nfs_ip}}/$nfs_ip/g;
#print("-----\n$template\n-----\n\n");
open(FH, '>', $yaml_file) or die $!;
print FH $template;
close(FH);
$cmd = "kubectl apply -f $yaml_path";
print("Deploy sonarqube..\n");
$cmd_msg = `$cmd`;
print("-----\n$cmd_msg\n-----\n\n");
