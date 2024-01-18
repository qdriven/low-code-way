"""
pipenv install docker to install docker client
Docker Script for tester:
main conceptions docker:
- image
  * pull
  * rmi
  * find image
- container
  * run
  * list
  * stop
  * rm
"""

import docker

client = docker.from_env()


def run_container(image_name, detach=True):
    container = client.containers.run(image_name, detach=detach)
    return container.id


def view_container_log(container_name):
    containers = client.containers
    for container in containers:
        if container.attrs['name'] == container_name:
            for line in container.logs(stream=True):
                print(line)
            break


def get_images():
    return client.images.list()


def pull_image(image_name):
    return client.images.pull(image_name)

def stop_container(container_name):
    container = client.containers.get(container_id=container_name)
    container.stop()

if __name__ == '__main__':
    get_images()