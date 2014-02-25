pan_custom_report
=================

export and import custom report across devices and virtual systems.

How to use
=================
  Usage: pan_report [options]
      -h, --help                       Display this screen
      -a 'get|show|set|delete',        action
          --action
      -c, --cache FILE                 api_key cache_file
      -d, --device DEVICE_IP           target device
      -f, --file FILE                  xml file to be set
          --vsys vsys                  target vsys (ex) vsys1
      -u, --user user                  uesrname
      -p, --password password          password

      # NOTE
      get:   candidate config
      show:  running config

specify cache file of API_KEY with `-c`(use pre-generated api_key)
with `--vsys`, you can specify target vsys, if omitted, shared config is used for target.

## example

#### show/get
get:   candidate config
    $ ruby pan_report.rb  -d 1.2.3.4 -u admin -p admin -a get
show:  running config
    $ ruby pan_report.rb  -d 1.2.3.4 -u admin -p admin -a show

#### save current report config by redirecting output to file
    $ ruby pan_report.rb  -d 10.128.50.207 -u admin -p admin -a show -c password > test.xml

#### load exported report_config to specified vsys
    $ ruby pan_report.rb  -d 10.128.50.207 -u admin -p admin -a set -c password -f test.xml --vsys vsys2
