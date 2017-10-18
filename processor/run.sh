#! /bin/bash
set -e

pushd $(dirname $0)/ > /dev/null

if [ "$#" -ne 1 ]; then
    echo "Usage: run [ hello | fibonacci | mergesort ]"
    exit 1
fi

path=""

if [ $1 = "hello" ]; then
    path='..\/mips\/hello_world_test\/hello_world_test.bin'
elif [ $1 = "fibonacci" ]; then
    path='..\/mips\/fibonacci_test\/fibonacci_test.bin'
elif [ $1 = "mergesort" ]; then
    path='..\/mips\/merge_test\/merge_test.bin'
else
    echo "Error: arg1 must be 'hello' or 'fibonacci' or 'mergesort'"
    exit 1
fi

mkdir -p $1

sed -i '' "s/\$readmemh\(.*\);/\$readmemh(\"$path\", memory);/g" ../modules/MEMORY.v
sed -i '' "s/\$dumpfile\(.*\);/\$dumpfile(\"$1\/$1.vcd\");/g" ManBearPig.v

iverilog -f files.txt -o "$1/$1.out"

./$1/$1.out

echo

popd > /dev/null
