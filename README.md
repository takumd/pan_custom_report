pan_custom_report
=================

export and import custom report across devices and virtual systems.

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
