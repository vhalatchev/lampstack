tr --delete '\n' <password.txt >.strippedpassword.txt && mv .strippedpassword.txt password.txt
kubectl create -f https://raw.githubusercontent.com/fjudith/docker-wordpress/master/kubernetes/local-volumes.yaml
kubectl create secret generic wp-mysql-pass --from-file=password.txt
curl https://raw.githubusercontent.com/fjudith/docker-wordpress/master/kubernetes/mysql-deployment.yaml | conduit inject --skip-outbound-ports=3306 - | kubectl apply -f -
curl https://raw.githubusercontent.com/fjudith/docker-wordpress/master/kubernetes/wordpress-deployment.yaml | conduit inject --skip-outbound-ports=9000,11211 | kubectl apply -f -

kubectl get svc nginx -n default -o jsonpath="{.status.loadBalancer.ingress[0].*}"