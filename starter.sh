#!/bin/bash  #general
set -e
docker login

# Variable section
docker_organization=hermandockerhub
backend=female_ghost


git submodule init
git submodule update --recursive --remote --merge --force

if [ ! -d "female_ghost-postgres" ]; then
  git submodule foreach --recursive git checkout master
  initial=true
  docker-compose pull female_ghost-postgres
  docker-compose up -d female_ghost-postgres
fi

docker-compose pull $backend
docker-compose up -d $backend

if [ "$initial" == true ]; then
echo "Waiting for database to load up"
sleep 90
echo "Creating Superuser.."
docker-compose exec $backend python manage.py makemigrations
docker-compose exec $backend python manage.py migrate
docker-compose exec $backend python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', '', 'pass1234')"  #dev
cat >> $backend-postgres/data/postgresql.conf <<EOF
log_min_duration_statement = 0
log_line_prefix = '{"Time":[%t], Host:%h} '
EOF
docker-compose exec female_ghost-postgres psql -U $backend -c "SELECT pg_reload_conf();"
fi


echo "Loading data in $backend"

docker-compose exec $backend sh ./loaddata.sh
echo "Loading static in $backend"
docker-compose exec $backend python manage.py collectstatic --noinput

docker-compose pull #dev

echo "Starting to create containers.."
docker-compose up -d  || true  #dev


# Service Access Information Section
echo "Kindly tests in your local:"
echo "$backend"
echo "-url: http://localhost:8000/female_ghost_charm/femaleghostcharm/"
echo "- admin username: admin"
echo "- admin password: pass1234"
echo "PLEASE WAIT PATIENTLY FOR THE FRONT-ENDS TO LOAD"