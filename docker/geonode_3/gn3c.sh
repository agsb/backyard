

# @agsb 06/2020 modificado de https://docs.geonode.org/en/3.0/install/basic/index.html

sudo su geonode

geonode_tag=geonode_3

git clone https://github.com/GeoNode/geonode-project.git -b 3.x

# Ubuntu
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
mkvirtualenv --python=/usr/bin/python3 $geonode_tag
pip install Django==2.2.12

# CentOS
virtualenv -p python3 $geonode_tag
source $geonode_tag/bin/activate

django-admin startproject --template=./geonode-project -e py,sh,md,rst,json,yml,ini,env,sample -n monitoring-cron -n Dockerfile $geonode_tag

# If the previous command does not work for some reason, try the following one
# python -m django startproject --template=./geonode-project -e py,sh,md,rst,json,yml,ini,env,sample -n monitoring-cron -n Dockerfile $geonode_tag

cd $geonode_tag

sed -i -e 's;\(build: ./docker/letsencrypt/\);\1\n\tcontainer_name: letsencrypt4${COMPOSE_PROJECT_NAME};' docker-compose.yml

./docker-build.sh
