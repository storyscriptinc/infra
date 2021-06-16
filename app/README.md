### Story AI App

These TF scripts exist to create the necessary GCP infrastructure to host app.story.ai

```
env TF_VAR_credentials=(cat /tmp/tf.json | string split0) TF_VAR_cert_privkey=<privkey.pem> TF_VAR_cert_fullchain=<fullchain.pem> terraform apply
```

The state file is stored in Terraform Cloud. The cert keys are in LastPass.
