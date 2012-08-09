
# Change these paths to match your installation
# Alternatively, you can call 'make' overriding variable values, E.g.:
#     make FREELINGDIR=/my/freeling/dir SWIGDIR=/my/swig/dir JAVADIR=/my/java/dir

FREELINGDIR = /usr/local/Cellar/freeling/HEAD
SWIGDIR = /usr/local/Cellar/swig/2.0.4/share/swig/2.0.4
JAVADIR = /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

# you may change the package name if you want
PACKAGE = edu/upc/freeling
JPACKAGE = edu.upc.freeling

# Change your compiler, if necessary.
GCC=g++

all: freeling_javaAPI.cxx libfreeling_javaAPI.so

.PHONY: all

# Compile the C++ API
libfreeling_javaAPI.so: freeling_javaAPI.cxx
	$(GCC) -shared -o libfreeling_javaAPI.so freeling_javaAPI.cxx -lfreeling -L$(FREELINGDIR)/lib -I$(FREELINGDIR)/include -I$(JAVADIR)/include -I$(JAVADIR)/include/linux -I/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers -I/usr/local/Cellar/icu4c/4.8.1.1/include -fPIC
	javac $(PACKAGE)/*.java
	jar -cf freeling.jar $(PACKAGE)

# Build the Java JNI wrapper classes.
freeling_javaAPI.cxx: freeling_javaAPI.i ../common/freeling.i
	rm -rf $(PACKAGE)
	mkdir -p $(PACKAGE)
	swig -java -c++ -package $(JPACKAGE) -outdir $(PACKAGE) -o freeling_javaAPI.cxx -I$(SWIGDIR)/java -I$(SWIGDIR)/std -I$(SWIGDIR) freeling_javaAPI.i

clean:
	rm -rf *.jar *.so *.cxx *.class edu
