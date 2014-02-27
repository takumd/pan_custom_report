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
with `--vsys`, you can specify target vsys, if omitted, `Shared` is used for target.

## example

#### retrieve custom report config as xml
get( candidate config )

    $ ruby pan_report.rb  -d 1.2.3.4 -u admin -p admin -a get > report.xml

show( running config )
    $ ruby pan_report.rb  -d 1.2.3.4 -u admin -p admin -a show > report.xml

#### load saved report_config to vsys2
    $ ruby pan_report.rb  -d 1.2.3.4 -a set -c password -f report.xml --vsys vsys2
