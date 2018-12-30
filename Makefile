JAVAC=javac
JAVADOC=javadoc
JAR=jar
OPT=-O -g
VERSION=1.5
CLASS= \
./net/davidashen/text/Hyphenator.class \
./net/davidashen/util/ErrorHandler.class \
./net/davidashen/util/Hashtable.class \
./net/davidashen/util/Applicator.class \
./net/davidashen/util/List.class

.SUFFIXES: .java .class .jar


.java.class:
	${JAVAC} ${OPT} $<

all: jar docs

jar: texhyphj.jar

docs: javadoc

javadoc: doc/api/index.html

doc/api/index.html: net/davidashen/text/Hyphenator.java
	${JAVADOC} -d doc/api net/davidashen/text/Hyphenator.java

texhyphj.jar: ${CLASS}
	${JAR} cvf texhyphj.jar `find net/davidashen -name '*.class' -print`

package: texhyphj.zip

texhyphj.zip: all
	-rm texhyphj.zip
	-mkdir texhyphj texhyphj/doc
	cp LICENSE Makefile texhyphj/.
	cp texhyphj.jar texhyphj/.
	echo "see doc/README" > texhyphj/doc/INSTALL
	cp doc/README texhyphj/doc
	find net -name '*.java' -print | cpio -dumpv texhyphj/.
	find doc/api etc -name CVS -prune -o -print | cpio -dumpv texhyphj/.
	-zip -r texhyphj-${VERSION}.zip texhyphj
	-tar cvf - texhyphj | gzip --best > texhyphj-${VERSION}.tar.gz
	rm -rf texhyphj

clean: 
	-rm -f texhyphj*.zip
	-rm -f texhyphj*.tar.gz
	-rm -rf texhyphj
	-rm -f texhyphj.jar
	find . -name '*.class' -exec rm -f {} \;
	find doc/api -name '*.html' -o -name '*.css' | xargs rm -f
