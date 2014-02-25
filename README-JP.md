pan_custom_report
=================

デバイス、vsys に対して、カスタムレポート定義をエクスポート/インポート

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

-c はAPIキーのキャッシュ用ファイルを指定。(2回目以降、keygen の手間が省けて高速)
--vsys で vsys 指定可能。指定しない場合は shared config が対象になる。
