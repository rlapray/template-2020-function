#!/bin/sh
#define parameters which are passed in.

#define the template.
cat  << EOF
version: 0.0
Resources:
  - TargetService:
      Type: AWS::Lambda::Function
      Properties:
        name: "$SERVICE_NAME"
        alias: "$SERVICE_NAME"
        currentversion: "$CURRENT_VERSION"
        targetversion: "$TARGET_VERSION"
EOF