for D in `find . -mindepth 1 -type d`
do
    cd $D
    pwd
    echo ""
    if iverilog -f files.txt; then
	    diff <(./a.out) output.txt
	else
		echo "Failed to compile"
	fi

    echo ""
    cd ..
done