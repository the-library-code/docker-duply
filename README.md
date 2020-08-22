# Duply

[Duply](https://duply.net/) is a backup tool based on [duplicity](http://duplicity.nongnu.org). It uses GnuPG to encrypt backups and can connect to multiple backends.

## Building the image

Building the image should be easy. You can use the following command: `docker build -t duply <path to the Dockerfile>` or fetch [thelibrarycode/duply](https://hub.docker.com/r/thelibrarycode/duply) from Docker Hub.


## Using the image

The docker iamge expects three volumes. One to store duply's configuration, at least one for the data to backup, and another one for duply's archive directory. As you will need to edit the configuration, you should use a bind mount or a named volume for it. Add all data that shall be backuped as named volume or bind mount. We created an empty directory `/backup` as place to mount those. You can use an unamed volume for the archive directory. The archive directory stores unencrypted metadata of backups to make incremental backpus easier. This data is not absolutely necessary, but it help to avoid to have to load and unencrypt parts of backups, when creating new incremental ones. In duply's configuration template, you can find more details about the archive directory and possible backup targets.

Duply uses profiles to store different backup jobs. Almost every duply command names the profile that shall be used. Mount a volume to persist duply's configuration into the container as `/etc/duply`. Within the contain Duply runs as root, so that unix file permissions and ownership do not prohibit to access the files to backup. As duply runs as root user, it checks `/etc/duply` to find its configuration an the profiles.

## Create a new profile

To create your configuration you must run `duply <profile-name> create` within the container. You can use the following command to spin up the container and run that command: `docker run --rm -it -v "$(pwd)"/volumes/duply_config:/etc/duply:cached duply kosmos_docker_volumes create`. This would put duply's configuration into a folder `volumes/duply_config` in your current working directory and mount that into the container. Please change this accordingly to your needs. After creating the profile edit its configuration. It will be in the volume or directory in a subfolder named as you named your profile. The configuration you just created contains a lot of helpful information and documentation about what and how to configure.

## Use duply

Once you created the configuration and edited it, you should be good to go for your first backup. Run `docker run --rm -it -v "$(pwd)"/volumes/duply_config:/etc/duply:cached duply kosmos_docker_volumes backup`. To see usage information of duply run `docker run --rm -it -v "$(pwd)"/volumes/duply_config:/etc/duply:cached duply usage`.
