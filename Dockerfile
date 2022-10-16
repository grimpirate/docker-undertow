FROM alpine

RUN apk add --no-cache openjdk17-jdk maven binutils && rm -rf /var/cache/apk/*

WORKDIR /home
RUN jlink --add-modules java.base,java.logging,java.management,java.naming,java.security.jgss,java.security.sasl,java.sql,java.xml,jdk.unsupported --no-header-files --no-man-pages --strip-debug --bind-services --ignore-signing-information --compress=2 --output jre
RUN rm -rf jre/legal && rm jre/release
RUN mvn archetype:generate -DgroupId=com.grimpirate -DartifactId=undertow -DinteractiveMode=false
COPY App.java undertow/src/main/java/com/grimpirate/App.java
COPY pom.xml undertow/pom.xml

WORKDIR /home/undertow
RUN mvn clean package -Dmaven.test.skip=true

FROM alpine

RUN mkdir /home/jre && mkdir /home/public
COPY --from=0 /home/jre /home/jre
COPY --from=0 /home/undertow/target/undertow-2022101501.jar /home
ADD index.html /home/public

VOLUME ["/home/public"]

CMD ["/home/jre/bin/java", "-jar", "/home/undertow-2022101501.jar",  "0.0.0.0", "80", "/home/public"]

EXPOSE 80