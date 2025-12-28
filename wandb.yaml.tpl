apiVersion: apps.wandb.com/v1
kind: WeightsAndBiases
metadata:
  labels:
    app.kubernetes.io/name: weightsandbiases
    app.kubernetes.io/instance: wandb
  name: wandb
  namespace: ${namespace}
spec:
  values:
    global:
      host: ${wandb_domain}
      bucket:
        name: ${artifact_bucket}
        provider: s3
        region: ${aws_region}
      mysql:
        database: wandb
        host: ${db_host}
        name: wandb
        passwordSecret:
          name: wandb-db
          passwordKey: password
        port: 3306
        user: wandb
      license: eyJhbGciOiJSUzI1NiIsImtpZCI6InUzaHgyQjQyQWhEUXM1M0xQY09yNnZhaTdoSlduYnF1bTRZTlZWd1VwSWM9In0.eyJjb25jdXJyZW50QWdlbnRzIjoxMCwidHJpYWwiOnRydWUsIm1heFN0b3JhZ2VHYiI6MTAwMDAwMCwibWF4VGVhbXMiOjUwLCJtYXhVc2VycyI6MTAwLCJtYXhWaWV3T25seVVzZXJzIjowLCJtYXhSZWdpc3RlcmVkTW9kZWxzIjo1LCJleHBpcmVzQXQiOiIyMDI2LTAxLTIxVDIwOjU3OjI3LjE2OFoiLCJkZXBsb3ltZW50SWQiOiIxZWFmMGUwMS02YzhlLTQ0YmItOTcyYS0yZTYwOGE1M2ZkNjEiLCJmbGFncyI6WyJOT1RJRklDQVRJT05TIiwic2xhY2siLCJub3RpZmljYXRpb25zIiwiU0NBTEFCTEUiLCJteXNxbCIsInMzIiwicmVkaXMiLCJNQU5BR0VNRU5UIiwib3JnX2Rhc2giLCJhdXRoMCIsImNvbGxlY3RfYXVkaXRfbG9ncyIsInJiYWMiXSwiY29udHJhY3RTdGFydERhdGUiOiIyMDI1LTEyLTIyVDIwOjU3OjI3LjE2OFoiLCJhY2Nlc3NLZXkiOiJkMGMxZmRhZC00NWM2LTQxMWMtOTEzMi0wYjJjMDgyMjJjNDUiLCJzZWF0cyI6MTAwLCJ2aWV3T25seVNlYXRzIjowLCJ0ZWFtcyI6NTAsInJlZ2lzdGVyZWRNb2RlbHMiOjUsInN0b3JhZ2VHaWdzIjoxMDAwMDAwLCJleHAiOjE3NjkwMjkwNDcsIndlYXZlTGltaXRzIjp7IndlYXZlTGltaXRCeXRlcyI6bnVsbCwid2VhdmVPdmVyYWdlQ29zdENlbnRzIjowLCJ3ZWF2ZU92ZXJhZ2VVbml0IjoiTUIifX0.0l4XQfSJxFNqKOcdebd6MbzD_pxcjw1vGq337UmcpoxZVhLLq01Ccs6EFu32zN4_bvbaeLjknaw2UunOYn5LpS8AlKWHZq803pTfs1On-c70srShguuREhf_6dO_Ff-alY0s41mS4iQuX30c6Atu6oUUDQ33V_MZ7-2ln1kmefZhFZtLrK5rB2JbLnhWePS2XBa6kbyu_c8efS8_F4ZdtScB3qhffLvYHwEFJRama7qLJ7J9ktwAssqFLRf4RwQOhlGWVtv5Tpt6yVM4agdyZQlPHghwKzbk8pzsqi2NCDpld6t_uim_8h_osnhLDADP3tiq3ZCqKVl-XPWswGTrSA
    ingress:
      class: "alb"
      enabled: true
      annotations:
        kubernetes.io/ingress.class: alb
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
        alb.ingress.kubernetes.io/certificate-arn: "${acm_certificate_arn}"