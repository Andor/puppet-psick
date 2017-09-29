# This class manages tp::test for PE Agents
#
class psick::puppet::pe_agent (
  Boolean $test_enable        = false,
  Boolean $manage_environment = false,
  Boolean $manage_noop        = false,
  Boolean $manage_service     = false,
  Boolean $noop_mode          = false,
  Hash $settings              = {},
) {

  if $test_enable {
    Tp::Test {
      cli_enable => true,
      template   => '',
    }
    tp::test { 'puppet-agent': settings_hash => $settings }
  }

  # Manage Puppet agent service
  if $manage_service {
    service { 'puppet':
      ensure => 'running',
      enable => true,
    }
    $service_notify = 'Service[puppet]'
  } else {
    $service_notify = undef
  }

  # Set environment
  if $manage_environment {
    pe_ini_setting { 'agent conf file environment':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'agent',
      setting => 'environment',
      value   => $environment,
      notify  => $service_notify,
    }
  }

  # Set noop mode
  if $manage_noop {
    pe_ini_setting { 'agent conf file noop':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'agent',
      setting => 'noop',
      value   => $noop_mode,
      notify  => $service_notify,
    }
  }
}
