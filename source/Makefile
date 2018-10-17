dnptools=binstrings corrprofile diprofile

all: $(dnptools) fourier

$(dnptools): % : %.cpp
	gcc -std=c++11 -std=c++14 -pthread -I include/ $< -lstdc++ -lrt -lm -o $@  

fourier: Fourier_Transform.cpp
	gcc Fourier_Transform.cpp -lm -o fourier

