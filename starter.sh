#!/bin/bash  #general
set -e
docker login

# Variable section
docker_organization=hermandockerhub
provider_center=female_ghost


git submodule init
git submodule update --recursive --remote --merge --force

if [ ! -d "female_ghost-postgres" ]; then
  git submodule foreach --recursive git checkout master
  initial=true
  docker-compose pull female_ghost-postgres
  docker-compose up -d female_ghost-postgres
fi

docker-compose pull $provider_center
docker-compose up -d $provider_center

if [ "$initial" == true ]; then
echo "Waiting for database to load up"
sleep 90
echo "Creating Superuser.."
docker-compose exec $provider_center python manage.py makemigrations
docker-compose exec $provider_center python manage.py migrate
docker-compose exec $provider_center python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', '', 'pass1234')"  #dev
cat >> $provider_center-postgres/data/postgresql.conf <<EOF
log_min_duration_statement = 0
log_line_prefix = '{"Time":[%t], Host:%h} '
EOF
docker-compose exec female_ghost-postgres psql -U $provider_center -c "SELECT pg_reload_conf();"
fi


echo "Loading data in $provider_center"

docker-compose exec $provider_center sh ./loaddata.sh
echo "Loading static in $provider_center"
docker-compose exec $provider_center python manage.py collectstatic --noinput

docker-compose pull #dev

echo "Starting to create containers.."
docker-compose up -d  || true  #dev


# Service Access Information Section
echo "Kindly tests in your local:"
echo "$provider_center"
echo "-url: http://localhost:8005/female_ghost_charm/femaleghostcharm/"
echo "- admin username: admin"
echo "- admin password: pass1234"
echo "PLEASE WAIT PATIENTLY FOR THE FRONT-ENDS TO LOAD"