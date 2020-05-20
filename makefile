-include cross_conf.mk

INCDIRS = -I.

#BOOST_INC_PATH='../'
#BOOST_LIB_PATH='/.'

OPENCV_CFLAG = `pkg-config opencv4 --cflags`
OPENCV_LIBS = `pkg-config opencv4 --libs`

TARGET = test

CC = gcc
LD = gcc

CXXFLAGS  = $(OPENCV_CFLAG) $(INCDIRS)
CXXFLAGS += -O3 -Wall -std=c++11 -fopenmp -openmp


#LIBS = -L$(BOOST_LIB_PATH) -Xlinker --start-group -lpthread -ldl -lm -lrt -lc -lstdc++ -lboost_system -lboost_thread -lboost_filesystem -lboost_regex -lboost_date_time -lgomp -lstdc++fs -Xlinker --end-group $(OPENCV_LIBS)
LIBS = -Xlinker --start-group -lpthread -ldl -lm -lrt -lc -lstdc++ -lboost_system -lboost_thread -lboost_filesystem -lboost_regex -lboost_date_time -lboost_program_options -lgomp -lstdc++fs -lzbar -Xlinker --end-group $(OPENCV_LIBS)

SRCDIRS		= .
						
VPATH = . $(SRCDIRS)

SRCS = $(foreach dir, . $(SRCDIRS),$(wildcard $(dir)/*.cpp))

OBJS = $(SRCS:.cpp=.o)
OBJS := $(notdir $(OBJS))

all: $(TARGET)

$(TARGET) : $(OBJS)
	-rm -f $(TARGET)
	$(CC) $(CXXFLAGS) $^ -o $(TARGET) $(LIBS)

%.o:%.cpp
	$(CC) -Wall $(CXXFLAGS) -c $< -o $@

clean:
	-rm -rf $(OBJS)
	-rm -f $(TARGET)
	-rm -f depend

depend: $(SRCS)
	mkdir $(arch)
	$(SRCS) 
	$(CC) -M $(CXXFLAGS) $^ > $@ 

-include depend

#depend: .depend
#
#.depend: $(SRCS) $(VERSIONNUM)
#	rm -f ./.depend
#	$(CC) $(CXXFLAGS) -MM $^ > $(notdir $@) -MF  ./.depend;
#	echo "HAHAHAH = " $(CC) $(CXXFLAGS) -MM $^ > $(notdir $@) -MF  ./.depend;
#	#$(CC) $(CFLAGS) -MM $^ -MF  ./.depend;
#
#-include .depend
