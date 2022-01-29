#################################		INSTALACION Y CONFIGURACION DE ANSIBLE		#############################

Primero vamos a crear nuestro fichero Vagrantfile para levantar el entorno de maquinas virtuales que vamos a usar en esta 
practica.

Editamos Vagrantfile y ponemos (podemos copiar el Vagrantfile de antes o lanzar vagrant init para que nos genere uno en 
el directorio donde estemos):

config.vm.box = "bento/ubuntu-20.04"

  config.vm.define "ansible" do |ansible|
    ansible.vm.hostname = "ansible"
    ansible.vm.network "private_network", ip: "10.20.1.3"
  end


  config.vm.define "balancer" do |balancer|
    balancer.vm.hostname = "balancer"
    balancer.vm.network "private_network", ip: "10.20.1.10"
  end

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.network "private_network", ip: "10.20.1.11"
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
    node2.vm.network "private_network", ip: "10.20.1.12"
  end


Luego nos logearemos en la maquina que hemos definido como ansible

 	# vagrant ssh ansible

Ahora instalamos ansible:

	# sudo apt update
	# sudo apt install ansible -y


Ahora dentro de nuestro directio de /vagrant vamos a configurar nuestro entorno de ansible (lo hacemos aquí para que cuando apaguemos o eliminemos 
las maquinas podamos ver todo lo que hemos hecho)

Configurar el archivo de inventario:

Aquí vamos a crear varios grupos de servidores:

[all]
10.20.1.10
10.20.1.11
10.20.1.12

[balanceadores]
10.20.1.10

[servers]
10.20.1.11
10.20.1.12

lo vamos a guardar como hosts y luego tendremos que configurar nuestro fichero ansible.cfg para decirle que use este fichero de inventario. 
Para nuestro fichero anisble.cfg vamos a copiar el que se genera al hacer la instalacion en /etc/ansible/ansible.cfg y lo pegamos en /vagrant

	# cp /etc/ansible/ansible.cfg . 

Ahora lo editamos:

[defaults]

# some basic default values...

inventory      = /vagrant/hosts

Con esto ya tenemos configurado nuestro inventario. Ahora tenemos que configurar los usuarios para que podamos conectarnos por ssh al resto de 
servidores que vamos a administrar desde Ansible. Ansible usa ssh para llevar a cabo sus tareas, con lo cual tenemos que crear un usuario que se 
conecte de forma segura con el resto de las maquinas. Como en este entorno ya tenemos creado en todas las maquinas el usuario vagrant vamos a usar
este, de lo contrario tendríamos que crear un usuario nuevo "ansible" en todos los servidores. 
Ya que tenemos el usuario, tendremos que pasarle las claves públicas (OJO LAS PRIVADAS NO SE COMPARTEN NUNCA) para poder conectarnos desde el 
servidor de Ansible al resto:

	1) generamos las claves de ssh para el user vagrant.

	# ssh-keygen
	
	*** no le pondremos ninguna passwd, porque sino nos la pediría siempre. 

	2) pasamos las claves al resto de servidores, nos pedirá la passwd solo la primera vez (el usuario sera vagrant y la clave vagrant)

	# ssh-copy-id ip_servidor

Ya tendremos acceso a los servidores sin tener que poner passwd:

	# ssh -l vagrant ip_servidor

Ahora para que ansible pueda instalar necesitara tener permisos de root, para ello tendremos que usar el modulo "become", en nuestro fichero 
de configuración de ansible, ansible.cfg tenemos que editar el bloque privilege_escalation y dejarlo tal que así. 

[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False

Además para que esto funcione nuestro usuario debe de estar dentro de sudoers, para que pueda hacer sudo. Para ello vamos a /etc/sudoers.d/
Y añadimos un fichero (en este caso ya tenemos al usuario vagrant) y añadiriamos: 


	vagrant ALL=(ALL) NOPASSWD:ALL

	*** OJO, ESTA CONFIGURACIÓN TENEMOS QUE HACERLA EN TODOS LOS SERVIDORES QUE QUERAMOS ADMINISTRAR. 


Ahora ya podemos empezar a lanzar comandos desde nuestro servidor de Ansible. 

Comandos de ansible ad-hoc:


	# ansible all -m ping
 

Los facts de ansible: son toda la información que recoge ansible de los servidores, que luego podemos usar. Ejemplo:

	# ansible Client -m setup -a "filter=ansible_distribution*"
	# ansible all -m setup -a "filter=ansible_kernel"
	# ansible all -m setup -a "filter=ansible_hostname"

	Para ver todos los facts que podemos usar : 

	# ansible all -m setup    


Para saber como usar los modulos de ansible (con ejemplos y todo):

	# ansible-doc nombre_modulo 
	# ansible-doc user 


Si queremos usar tuberias y redirecciones cuando usamos comandos ad-hoc, tenemos que usar el modulo shell

	# ansible all -m shell -a 'ps -fe| grep nginx'


Podemos rebotar servidores:

	# ansible servers -a "/sbin/reboot" 



#################################################################################################################################################

	INSTALACION DE JENKINS PARA AUTOMATIZAR TAREAS DE SISTEMAS

Para llevar a cabo la instalación de jenkins vamos a realizar un script (así praticamos)

Una vez lo tengamos instalado podemos ver como ejecutar algunos jobs con ansible ad-hoc y luego pasaremos a realizar playbooks de Ansible. 

Tendremos que crear un usuario credentials, añadir el pluging de SSH, dar de alta el host (configure), etc, etc... 

#################################################################################################################################################


Playbooks de Ansible:

Son ficheros Yaml donde definimos las tareas que queremos hacer y donde queremos hacerlas (inventario) en nuestro directorio de /vagrant dentro 
del servidor de Ansible vamos a crear los yaml que luego ejecutaremos con ansible-playbook.


Dentro de nuestro servidor de ansible:

Vamos a crear un playbook sencillo para crear un usuario llamado sistemas, lo añadiremos al grupo adm para que tenga permisos de root y le daremos 
una passwd. Para ello tenemos que instalar un programa llamado whois para crear la passwd encriptada.

	# sudo apt install whois

	# mkpasswd --method=sha-512

		Nos pedirá la passwd. 

Luego crearemos en /vagrant el fichero user.yaml
vi user.yaml   --> aquí añadimos lo siguiente y en password ponemos el hash que hemos creado anteriormente. 

---
- hosts: all
  tasks:
          - name: creacion de usuario sistemas
            user:
                    name: sistemas
                    password: $6$ObARBbvdtRnv$3NgVZ1nmBabfNTYFga1Wlvp7FnrYp9ZRcaa.XJonRKQnmNFcHEjMnfsggldn4ip2NvsOOWu2rqCyLMcncaZGi.
                    comment: sistemas
                    shell: /bin/bash
                    uid: 1040
                    groups: adm,sudo
...

Para comprobar que no tenemos errores de syntax

	# ansible-playbook user.yaml --syntax-check

Ahora crearemos los ficheros YAML para la instalación de nuestro Load Balancer y nuestro servidor web nodejs 




