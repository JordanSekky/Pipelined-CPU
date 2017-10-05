for D in `find . -mindepth 1 -type d`
do
    pushd $D > /dev/null
    if [ -f files.txt ]; then
        if iverilog -f files.txt; then
            output=$(diff <(./a.out) output.txt)
    	    if [ $? == 0 ]; then
                echo "Test successful for $(pwd)"
                echo
            else
                echo -ne '\033[91m'
                echo "Unexpected output for $(pwd): "
                echo -e '\033[0m'
                echo "$output"
                echo
            fi
    	else
    		echo "Failed to compile $(pwd)"
    	fi
    else
        echo -ne '\033[93m'
        echo "No tests found for $(pwd)"
        echo -e '\033[0m'
    fi
    popd > /dev/null
done
exit 0
