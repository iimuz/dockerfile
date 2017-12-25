FROM java:8-jre
LABEL maintainer iimuz

ENV GITBUCKET_VERSION 4.20.0
ADD https://github.com/gitbucket/gitbucket/releases/download/${GITBUCKET_VERSION}/gitbucket.war /opt/gitbucket.war

RUN ln -s /gitbucket /root/.gitbucket

VOLUME /gitbucket

# Port for web page
EXPOSE 8080
# Port for SSH access to git repository (Optional)
EXPOSE 29418

CMD ["java", "-jar", "/opt/gitbucket.war"]
