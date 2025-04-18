# Rsync SSH Server Docker container

[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/F8zvFL89rXf6pgQo3twuVc/9EdSg72sC2c7HqYzC8QdCn/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/F8zvFL89rXf6pgQo3twuVc/9EdSg72sC2c7HqYzC8QdCn/tree/main)

<a href="https://www.buymeacoffee.com/dciancu" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 42px !important;width: 151.9px !important;" ></a>

Run Rsync SSH server in Docker.

## Usage

Docker Hub Image: [dciancu/rsync-ssh-server](https://hub.docker.com/r/dciancu/rsync-ssh-server)  

Run `gen-ssh-host-keys.sh` script before starting container.  
Make sure to put the authorized ssh key in `data/ssh/key.pub`.  
Run the container using `docker compose` with the provided `docker-compose.yml`.

On remote host use `rsync -av --delete --progress --info=progress2 --stats -e 'ssh -p 2222' /source rsync@1.2.3.4:/target`.

## License

This project is open-source software licensed under the [Apache License, Version 2.0](https://opensource.org/license/apache-2-0).
