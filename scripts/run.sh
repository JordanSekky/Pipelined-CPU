#! /bin/bash
set -e

pushd $(dirname $0)/../processor/ > /dev/null

if [ "$#" \< 1 ] || [ "$#" \> 2 ]; then
    echo "Usage: run [ hello | fibonacci | mergesort | test [ branch | jump | add | unit ]]"
    exit 1
fi

path=""
outFile=""
dumpFile=""

if [ "$#" = 1 ]; then

    dumpFile="..\/bin\/$1\/$1.vcd"
    outFile="../bin/$1/$1.out"

    if [ $1 = "hello" ]; then
        path='..\/programs\/hello_world\/hello_world.bin'
    elif [ $1 = "fibonacci" ]; then
        path='..\/programs\/fibonacci\/fibonacci.bin'
    elif [ $1 = "mergesort" ]; then
        echo "NOTE: Mergesort is not currently working entirely"
        path='..\/programs\/mergesort\/mergesort.bin'
    elif [ $1 = "clean" ]; then
        rm -rf ../bin/
        exit
    else
        echo "Error: arg1 must be 'hello' or 'fibonacci' or 'mergesort'"
        exit 1
    fi
else
    if [ $1 = "test" ]; then

        dumpFile="..\/bin\/$1\/$2\/$2.vcd"
        outFile="../bin/$1/$2/$2.out"

        if [ $2 = "add" ] || [ $2 = "jump" ] || [ $2 = "branch" ]; then
            path="..\/tests\/integration\/$2_test\/$2_test.bin"
        elif [ $2 = "unit" ]; then
            pushd ../scripts > /dev/null
            ./unittests.sh
            popd > /dev/null
            exit
        else
            echo "Error: invalid arg2 '$2'"
            exit 1
        fi
    else
        echo "Error: invalid arg1 '$1'"
        exit 1
    fi
fi

mkdir -p $(dirname $outFile)
sed -i "s/\$readmemh\(.*\);/\$readmemh(\"$path\", memory);/g" ../modules/MEMORY.v > /dev/null
sed -i "s/\$dumpfile\(.*\);/\$dumpfile(\"$dumpFile\");/g" ManBearPig.v > /dev/null

sed -i '' "s/\$readmemh\(.*\);/\$readmemh(\"$path\", memory);/g" ../modules/MEMORY.v > /dev/null
sed -i '' "s/\$dumpfile\(.*\);/\$dumpfile(\"$dumpFile\");/g" ManBearPig.v > /dev/null
iverilog -f files.txt -o $outFile

$outFile

echo

popd > /dev/null

exit
