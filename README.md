# ci-provider-center

# READ BEFORE CLONING #
This repository is for instant set-up of  the Dockerized promotion project

## Make sure you have your app passwords for your 2FA
* From your avatar in the bottom left, click Bitbucket settings.
* Click App passwords under Access management.
* Click Create app password.
* Input your name for the label
* Select the specific access and permissions you want this application password to have.
* Copy the generated password and either record or paste it into the application you want to give access.

## Make sure that you have at least Docker 18.06 version on your MAC
* Simply click the Docker icon on the upper left screen and choose Check for Updates...

## Run starter script to immediately set the project
`$ chmod u+x starter.sh && ./starter.sh`

# SERVICE ACCESS INFORMATION #

## female_ghost(pr-exercise_ci_cd API)
* URL: http://localhost:8005/female_ghost_charm/femaleghostcharm/"
* username: admin
* password: pass1234

## Real-time file change between local files and container
Simply comment out the volumes in docker-compose.yml like:
```
volumes:
    - ./{backend}:/usr/src/app/
```

## Build the images locally
`$ docker-compose build`

## Update the images from cloud registry
`$ docker-compose pull && docker-compose up -d --no-build`


## Update a specific image
`$ docker-compose pull <container_alias>` like `docker-compose pull campaign`

`$ docker-compose up -d`

## Update a front-end service
`$ <service>/.pull.sh`
or go to the folder then
`$ ./pull.sh`


## To ssh inside a container
`$ docker exec -it <container_id> bash`

`$ docker exec -it <container_id> ash`(for alpine tagged images)

You can also use compose like `$ docker-compose exec <container_alias> bash`

## To test a Docker's default container execution like `CMD` or `ENTRYPOINT`
* Go to ci-promotion folder
`$ docker-compose restart <container_alias>` like `docker-compose restart {backend}`

`$ docker-compose logs --tail=100 -f <container_alias>` like `docker-compose logs --tail=100 -f {backend}`

### Adding new projects in the ci
```
$ git checkout -b upgrade/implement-<project_name>
$ git submodule add <repository_url>
```
* Go to `.gitmodules` file and add `branch = master` like
* Update starter.sh
* Update README.md SERVICE ACCESS INFORMATION


### Adding a new project in your current project bundle
```
$ ./starter.sh
```
* If ever it is not successful, get some assistance with the Devops
