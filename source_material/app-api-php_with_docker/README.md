# Running the app-api with Docker #

[Docker](https://docker.com) is very well suited to run the web API, although it can be a bit bothersome to find a suitable PHP image to use.

To ease this, we have created a Dockerfile, enabling you to make your own web-server-with-PHP image to run the app-api application.

With Docker installed, first build a custom image using the included Dockerfile:

```shell
cd [path-to-Dockerfile-directory]
docker build -t imagename ./
```