#!/bin/bash

cat > env <<-OEOF
#!/bin/bash
export BOSH_ENVIRONMENT=$(bosh int <(bucc vars) --path /bosh_target)
export BOSH_CA_CERT='$(bosh int <(bucc vars) --path /bosh_ca_cert)'
export BOSH_CLIENT=$(bosh int <(bucc vars) --path /bosh_client)
export BOSH_CLIENT_SECRET=$(bosh int <(bucc vars) --path /bosh_client_secret)
export BOSH_GW_USER=jumpbox
export BOSH_GW_HOST=$(bosh int <(bucc vars) --path /bosh_target)
export BOSH_GW_PRIVATE_KEY=\$(mktemp)
cat > \${BOSH_GW_PRIVATE_KEY} <<-EOF
$(bosh int vars/director-vars-store.yml --path /jumpbox_ssh/private_key)
EOF
export BOSH_ALL_PROXY_KEY=\$(mktemp)
cat > \${BOSH_ALL_PROXY_KEY} <<-EOF
$(bosh int vars/jumpbox-vars-store.yml --path /jumpbox_ssh/private_key)
EOF
export BOSH_ALL_PROXY=ssh+socks5://jumpbox@$(bosh int <(bucc vars) --path /jumpbox_url)?private-key=\${BOSH_ALL_PROXY_KEY}
export CREDHUB_PROXY=\${BOSH_ALL_PROXY}
export CREDHUB_SERVER=$(bosh int <(bucc vars) --path /credhub_url)
export CREDHUB_SECRET=$(bosh int <(bucc vars) --path /credhub_password)
export CREDHUB_CLIENT=$(bosh int <(bucc vars) --path /credhub_username)
export CREDHUB_CA_CERT='$(bosh int <(bucc vars) --path /bosh_ca_cert)'
OEOF
