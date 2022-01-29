####################		COMANDOS PARA LA CRACION DE LA IMAGEN Y LEVANTAR EL DOCKER	#######################

Creacion de la imagen con nuestro Dockerfile:

	# docker build -t your_dockerhub_username/nodejs-image-demo .

Vemos la imagen que acabamos de crear:

	# docker images

Ejecute el siguiente comando para compilar el contenedor:

	# docker run --name nodejs-image-demo -p 80:8080 -d your_dockerhub_username/nodejs-image-demo

Vemos el docker:

	# docker ps

Y ahora nos vamos a nuestro navegador:

	http://your_server_ip 

Ahora vamos a trabajar con nuestro repositorio:


	# docker login -u your_dockerhub_username   

Cuando se indique, ingresamos la contraseña de la cuenta de Docker Hub. 
Iniciar sesión de esta manera creará un archivo ~/.docker/config.json en el directorio principal de su usuario con sus credenciales de Docker Hub.

	# docker push your_dockerhub_username/nodejs-image-demo


Para hacer la prueba, eliminamos el contenedor anterior y todas las imágenes, incluso las no utilizadas o pendientes, con el siguiente comando:

	# docker system prune -a

Con todas sus imágenes y contenedores eliminados, ahora, puede extraer la imagen de la aplicación de Docker Hub:

	# docker pull your_dockerhub_username/nodejs-image-demo

Vemos la imagenes otra vez:

	# docker images

Ahora, puede volver a compilar su contenedor usando el comando anterior:

	# docker run --name nodejs-image-demo -p 80:8080 -d your_dockerhub_username/nodejs-image-demo


