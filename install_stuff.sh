#!/usr/bin/env bash
 
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8
 
sudo apt-get update
printf "\n*****************************\n"
printf "* Installing Essential Stuff*\n "
printf  "*****************************\n"
sudo apt-get install -y build-essential curl libxslt1-dev libxml2-dev python-software-properties mc vim 

printf "\n*********************************************\n"
printf "* Setting default password to mysql to        *\n"
printf "* 'pass123456789' and installing lamp-servern *\n "
printf  "**********************************************\n"

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass123456789'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass123456789'

sudo apt-get install lamp-server^


printf "\n******************************************************************\n"
printf "* Added JAVA 8 Repo. Will accept the liscense for u and install it *\n"
printf "* start boiling water there is a long way to go                    *\n"
printf "******************************************************************\n"


sudo apt-add-repository ppa:webupd8team/java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get update
sudo apt-get install -y oracle-java8-installer oracle-java8-unlimited-jce-policy

printf "\n******************************************************************\n"
printf "* Done With JAVA, Installing java related stuff: maven and jenkins *\n"
printf "*                                                                  *\n"
printf "********************************************************************\n"

#Install JAVA dependent stuff
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo "deb http://pkg.jenkins-ci.org/debian binary/ " | sudo tee -a /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins maven
 
# postgres

printf "\n*********************************************************************\n"
printf "* Installing and Configuring Postgress, This is going to take a while*\n"
printf "**********************************************************************\n"
 
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main " | sudo tee -a /etc/apt/sources.list.d/pgdg.list
sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-9.3 libpq-dev
echo '# "local" is for Unix domain socket connections only
local   all             all                                  trust
# IPv4 local connections:
host    all             all             0.0.0.0/0            trust
# IPv6 local connections:
host    all             all             ::/0                 trust' | sudo tee /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf
sudo /etc/init.d/postgresql restart
sudo su - postgres -c 'createuser -s vagrant'

# Mongo Installation
printf "\n***********************************************************************************************\n"
printf "* Done With postgress, This will install mongo from official repo, so youll have to wait again*\n"
printf "**********************************************************************************************\n"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update

sudo apt-get install -y mongodb

#NodeJs Installation
printf "\n**************************************************************************\n"
printf "*Done installing database software, will proceed with nodejs environment *\n"
printf "* Is watter ready? Remember that for Mate, water shouldn't  boil     *\n"
printf "**************************************************************************\n"

curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get update
sudo apt-get install --yes nodejs

printf "\n**********************************************************************************************************\n"
printf "* You think we finished. We are not, Ill try to install rvm. and jruby as default ruby version.          *\n"
printf "* Since we are JVM lovers                                                                                *\n"
printf "* 												         *\n"
printf "**********************************************************************************************************\n" 
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash
curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby --gems=rails,bundler,jruby-pageant,net-ssh

