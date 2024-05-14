echo ${TOKEN}
echo $TOKEN
ifconfig
kubectl create secret generic group01-token --from-literal=token=$TOKEN -n group01
kubectl create token cicd
kubectl describe secret group01
kubectl describe secret group01 -n group01
kubectl get secret -n group01
microk8s config
microk8s config -l
microk8s kubectl -n group01 get sa/group01
microk8s kubectl -n group01 get secret
microk8s kubectl -n group01 get secret $(microk8s kubectl -n group01 get sa/group01 -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
microk8s kubectl -n group01 get secret group01
microk8s kubectl -n group01 get secret group01-token
microk8s kubectl -n group01 get secret group01-token -oyaml
microk8s kubectl -n group1 get secret $(microk8s kubectl -n group1 get sa/group1-user -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
microk8s kubectl config get-users
microk8s kubectl config view
microk8s kubectl config view --raw | grep certificate-authority-data
microk8s kubectl create rolebinding group01-binding --role=group01-role --serviceaccount=group01:group01 -n group01
microk8s kubectl create sa group01 -n group01
microk8s kubectl create secret generic group01-token --from-literal=token=$TOKEN -n group01
microk8s kubectl create serviceaccount group01 -n group01
microk8s kubectl create token group01
microk8s kubectl create token group01 -n group01
microk8s kubectl create token group01-token -n group01
microk8s kubectl delete sa group01 -n group01
microk8s kubectl describe secret group01
microk8s kubectl describe secret group01 -n group01
microk8s kubectl get role,rolebinding -n group01
microk8s kubectl get sa
microk8s kubectl get sa -n group01
microk8s kubectl get sa group01
microk8s kubectl get sa group01 -n group01 -o yaml
microk8s kubectl get sa group01 -oyaml
microk8s kubectl get sa group01 -oyaml -n group01
microk8s kubectl get sa group01 -oyml
microk8s kubectl get secrets
microk8s kubectl get secrets -n group01
microk8s kubectl get serviceaccount
microk8s kubectl get serviceaccount -n group01
TOKEN=$(head -c 16 /dev/urandom | base64)
TOKEN=$(microk8s kubectl -n group01 get secret $(microk8s kubectl -n group01 get sa/group01 -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode)
