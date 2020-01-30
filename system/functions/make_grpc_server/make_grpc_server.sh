make_grpc_server() {
  app_name=$1
  full_path=$(pwd)/$app_name
  mkdir $app_name
  cd $app_name
  mkdir protos
  touch protos/$app_name.proto
  touch ${$app_name}_server.py
  touch ${$app_name}_client.py
  cp ~/.dotfiles/home/.gitignore_global .gitignore
}
