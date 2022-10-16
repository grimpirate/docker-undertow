FROM alpine

RUN apk add --no-cache openjdk17-jdk maven binutils
RUN rm -rf /var/cache/apk/*

WORKDIR /home
RUN jlink --add-modules java.base,java.logging,java.management,java.naming,java.security.jgss,java.security.sasl,java.sql,java.xml,jdk.unsupported --no-header-files --no-man-pages --strip-debug --bind-services --ignore-signing-information --compress=2 --output jre
RUN rm -rf jre/legal
RUN rm jre/release
RUN mvn archetype:generate -DgroupId=com.grimpirate -DartifactId=undertow -DinteractiveMode=false
COPY App.java undertow/src/main/java/com/grimpirate/App.java
COPY pom.xml undertow/pom.xml

WORKDIR /home/undertow
RUN rm -rf src/test
RUN mvn clean package

FROM alpine

WORKDIR /home
RUN mkdir jre
COPY --from=0 /home/jre jre
COPY --from=0 /home/undertow/target/undertow-2022101501.jar .
RUN mkdir public
ADD index.html public/

WORKDIR /
#ADD configure.sh /
#RUN chmod +x configure.sh

VOLUME ["/home/public"]

#CMD ["./configure.sh"]
CMD ["/home/jre/bin/java", "-jar", "/home/undertow-2022101501.jar",  "0.0.0.0", "80", "/home/public"]

EXPOSE 80