OUT_PATH="../definitions"

rm $OUT_PATH

mkdir $OUT_PATH

python \
  -m grpc_tools.protoc \
  -I. \
  --python_out=$OUT_PATH \
  --grpc_python_out=$OUT_PATH \
  running_message.proto