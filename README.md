# template-2020-service

## Intro

This project is a dependency for https://github.com/rlapray/template-2020-infrastructure.

This is a nodejs lambda reachable from interent managed by the previous project.

*WARNING* => it's dirty for now

## What's inside ?

- AppSpec is generated automatically
- Staging and production are terraform modules triggered by CodePipeline
- It's using the same Application Load Balancer as the environment in which it deploys, not another API Gateway you see usually.


