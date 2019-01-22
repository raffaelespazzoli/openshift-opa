# Open Policy Agent

## Install

Instructions to deploy on OpenShift:

Indetify the value of the openshift service caBundle.
One way to do is to run:
```
SECRET=$(oc describe sa default -n default | grep 'Tokens:' | awk '{print $2}')
CA_BUNDLE=$(oc get secret $SECRET -n default -o "jsonpath={.data['service-ca\.crt']}")
```

Deploy the helm chart:
```
oc new-project opa
helm template ./charts/open-policy-agent --namespace opa --set kubernetes_policy_controller.image_tag=2.0 --set kubernetes_policy_controller.image=quay.io/raffaelespazzoli/kubernetes-policy-controller --set caBundle=$CA_BUNDLE --set log-leve=debug | oc apply -f -
```
### Enable authorization

If you want to enable authorization, you need to do the following:

1. Copy the ocp-policy-controller.kubeconfig file to the `/etc/origin/master` directory in each of your masters.
2. Edit the master-config.yaml file adding the following:

```
kubernetesMasterConfig:
...
  apiServerArguments:
...
    authorization-mode:
    - Node
    - Webhook
    - RBAC
    authorization-webhook-config-file:
    - /etc/origin/master/opa-policy-controller.kubeconfig  
```

These steps are intentionally left manual because the are significnaly differetn between the 3.x and 4.x version of OCP.

```
oc new-project opa-test
oc label ns opa-test opa-controlled=true
```

## Examples

### no IfnotPresent image pull policy and latest images

```
oc create configmap no-ifnotpresent-latest-rule --from-file=./examples/latest_and_IfNotPresent.rego -n opa
```