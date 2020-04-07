FROM centos:6

RUN yum install openldap-servers -y && yum clean all && \
    rm -rf /var/cache/yum

CMD /usr/sbin/slapd -h "ldap://$HOSTNAME ldaps://$HOSTNAME ldapi:///" -u ldap -g ldap -d -1

EXPOSE 389 636
