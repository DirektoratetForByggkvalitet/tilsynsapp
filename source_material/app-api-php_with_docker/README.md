# Running the app-api with Docker #

[Docker](https://docker.com) is very well suited to run the web API, although it can be a bit bothersome to find a suitable PHP image to use.

To ease this, we have created a Dockerfile, enabling you to make your own web-server-with-PHP image to run the app-api application.

With Docker installed, first build a custom image using the included Dockerfile:

```shell
cd [path-to-Dockerfile-directory]
docker build -t webserverimage ./
```

Then, with the app-api-php directory at hand, you can run a fully functional API server:
```shell 
docker run -d --name api-server -p 8080:80 -v path-to-app-api-php:/var/www/html webserverimage
```

Of course, there's a little bit more to it:
* You must rename the file _htaccess inside app-api-php to .htaccess to get the RESTful URLs to work. Wih other servers than Apache, other measures are necessary.
* For HTTPS access, you must change settings for Apache inside the container or run the docker container behind a reverse proxy.