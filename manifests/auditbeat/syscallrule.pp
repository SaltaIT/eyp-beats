# Syscall rules take the general form of:
#
# -a action,list -S syscall -F field=value -k keyname
#
define beats::auditbeat::syscallrule(
                                      $actions,
                                      $syscalls,
                                      $keyname    = $name,
                                      $fields     = [],
                                      $fields_eq  = {},
                                      $fields_neq = {},
                                      $audit_file = '/etc/auditbeat/audit.rules.d/syscall_rules.conf',
                                      $order      = '42',
                                    ) {
  if(!defined(Concat[$audit_file]))
  {
    concat { $audit_file:
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      notify => Class['::beats::auditbeat::service'],
    }
  }

  concat::fragment{ "${audit_file} syscallrule ${name} ${syscalls} ${keyname} ${actions}":
    target  => $audit_file,
    order   => $order,
    content => template("${module_name}/auditbeat/syscallrule.erb"),
  }
}
