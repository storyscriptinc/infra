### Story Pages CI

These TF scripts exist to create the necessary GCP infrastructure to host pages-ci.storyscript-ci.com

```
env GOOGLE_APPLICATION_CREDENTIALS=/tmp/tf.json TF_VAR_credentials=(cat /tmp/tf.json | string split0) TF_VAR_cert_privkey=<privkey.pem> TF_VAR_cert_fullchain=<fullchain.pem> terraform apply
```

> **⚠️** Use the `story-ai-ci` service account credentials here **⚠️**

The state file is stored in Terraform Cloud. The cert keys are in LastPass.
