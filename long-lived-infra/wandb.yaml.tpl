apiVersion: apps.wandb.com/v1
kind: WeightsAndBiases
metadata:
  labels:
    app.kubernetes.io/name: weightsandbiases
    app.kubernetes.io/instance: wandb
  name: wandb
  namespace: wandb-cr
spec:
  values:
    global:
      host: "https://${WAND_B_HOST}"
      bucket:
        name: "${S3_BUCKET}"
        provider: s3
        region: "${S3_REGION}"
      mysql:
        database: wandb
        host: "${DB_HOST}"
        name: wandb
        passwordSecret:
          name: wandb-db
          passwordKey: password
        port: 3306
        user: wandb
      license: "${LICENSE}"
    ingress:
      class: "alb"
      enabled: true
      annotations:
        kubernetes.io/ingress.class: alb
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
        alb.ingress.kubernetes.io/certificate-arn: "${ACM_ARN}"
