#!/bin/bash 
set -x 
POD_POLICY_UID="$(kubectl get pods -n $1 $2 -o=jsonpath='{.metadata.ownerReferences[0].uid}')"
APP_POLICY_UID="$(cf app $3 --guid)"


cf curl -X POST /networking/v1/external/policies -d '{"policies": [{"source":{"id":"'$APP_POLICY_UID'"},"destination":{"id":"'$POD_POLICY_UID'","protocol": "tcp","ports": {"start": 1,"end": 65335}}},{"source":{"id":"'$APP_POLICY_UID'"},"destination":{"id":"'$POD_POLICY_UID'","protocol": "udp","ports": {"start": 1,"end": 65335}}}]}'
