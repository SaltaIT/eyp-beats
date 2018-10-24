# File System
#     File System rules are sometimes called watches. These rules are used to audit access to particular files or directories that  you  may  be
#     interested in. If the path given in the rule is a directory, then the rule used is recursive to the bottom of the directory tree excluding
#     any directories that may be mount points. The syntax of these rules generally follow this format:
#
#     -w path-to-file -p permissions -k keyname
#
#     where the permission are any one of the following:
#
#            r - read of the file
#            w - write to the file
#            x - execute the file
#            a - change in the file's attribute
#
define beats::auditbeat::fsrule (
                                  $path,
                                  $permissions,
                                  $keyname    = $name,
                                  $audit_file = '/etc/auditbeat/audit.rules.d/fs_rules.conf',
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

  concat::fragment{ "${audit_file} fsrule ${name} ${path} ${keyname}":
    target  => $audit_file,
    order   => $order,
    content => template("${module_name}/auditbeat/fsrule.erb"),
  }
}
