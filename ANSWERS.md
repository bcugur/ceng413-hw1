# ANSWERS

## AI Assistant Note
I used an AI assistant to help understand Docker layer caching and to help outline the initial project files. I tested all commands myself, wrote these answers in my own words, and understand how every part of the Dockerfile works.

## 1. Order of instructions
In my Dockerfile, I start by setting the base image and workdir, then I copy `requirements.txt` and run `pip install` before copying the rest of my application code. Docker builds images layer by layer and caches each step as long as the files in that step haven't changed. Since dependencies rarely change compared to application code, putting `pip install` first allows Docker to reuse the cached layer during rebuilds. If I changed the order and copied all the source code before `pip install`, every single code edit in `app.py` would invalidate the cache. This would force Docker to download and reinstall all dependencies from scratch on every build, making build times much longer.

## 2. Data in containers
When an application writes files inside a container, they are saved in the container's temporary writable layer. Once the container is stopped and removed with `docker rm`, this layer is deleted and all data written inside is completely lost. To keep data safe, we use Docker volumes—like the `-v hw1data:/data` flag I used in the run command—which stores the data on the host machine outside the container. For real-world production apps, containers should stay stateless and important persistent state should be stored in an external database or cloud storage.

## 3. The latest tag
The `latest` tag is not a frozen version; it simply points to the most recent image pushed by the maintainers. This hurts reproducibility because building the same Dockerfile on different days or different computers might download different underlying software versions, which can easily break the app without warning. To prevent this, I pinned my base image to `python:3.12-slim`, locked the package versions inside `requirements.txt` (`flask==3.1.3` and `gunicorn==23.0.0`), and tagged my finished image as `hw1:1.0`.

## Image size note
Checking `docker images` shows my final image size is around 200 MB (48.8 MB compressed). Using `python:3.12-slim` instead of the standard Python image saved a lot of disk space, since the default full Python base image is over 1 GB.

