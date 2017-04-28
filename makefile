hzip:
	gcc -O2 -g *.cpp -m32 -o hzip  -L. -lds_ssort -pthread
clean:
	rm -f hzip
