
# /bin/bash
# comando para levantar rancher con docker
# una vez desplegado podemos conectarnos a rancher desde la web https://localhost
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged   rancher/rancher:latest

#ESTA ES LA OPCIÓN BUENA PORQUE TENDREMOS LOS DATOS PERSISTENTES Y PODEMOS HACER BACKUPS
# docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --privileged rancher/rancher


#Creamos un cluster nuevo siguiendo los pasos de Rancher: https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/deployment/quickstart-manual-setup/

#Este es el comando que tenemos que lanzar para añadir nodos control-plane con ETCD, para ello tenemos que tener instalado docker 
#en los servers que vamos a usar.

# docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5.8 --server https://10.108.240.74 --token qhngq8btr7ldp727rgw6qhtrpqm5crp2vtr2dwgv5bbf9mw4vks7fv --ca-checksum 68315a6541625d0de039b2863ddbad2e52f4bc20c7f51aee9048a26ef35b1790 --etcd --controlplane 



#Para la instalación de kubectl seguimos la propia web https://kubernetes.io/es/docs/tasks/tools/install-kubectl/ y el .kube/config de los cluster los tenemos que 
#coger de Rancher. 
