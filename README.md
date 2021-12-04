# sue445/heroku-cli
Dockerfile for heroku deployment

[![Build Status](https://github.com/sue445/dockerfile-heroku-cli/workflows/build/badge.svg?branch=master)](https://github.com/sue445/dockerfile-heroku-cli/actions?query=workflow%3Abuild)
[![Build Status](https://github.com/sue445/dockerfile-heroku-cli/workflows/update_version/badge.svg?branch=master)](https://github.com/sue445/dockerfile-heroku-cli/actions?query=workflow%3Aupdate_version)
[![CircleCI](https://circleci.com/gh/sue445/dockerfile-heroku-cli/tree/master.svg?style=svg)](https://circleci.com/gh/sue445/dockerfile-heroku-cli/tree/master)

https://hub.docker.com/r/sue445/heroku-cli/

## Build
```bash
docker build --rm -t heroku-cli .
```

## Running
```bash
docker run -it --rm sue445/heroku-cli bash
```

## Example
### CircleCI 2.1+
Use https://circleci.com/orbs/registry/orb/circleci/heroku

`sue445/heroku-cli` is unnecessary

### CircleCI 2.0 (deprecated)
The following are deprecated.

```yml
# .circleci/config.yml
version: 2

jobs:
  deploy:
    docker:
      - image: sue445/heroku-cli
    working_directory: /home/circleci/app

    steps:
      - run:
          name: Setup Heroku
          command: |-
            cat > ~/.netrc << EOF
            machine git.heroku.com
              login $HEROKU_LOGIN
              password $HEROKU_API_KEY
            EOF

            mkdir -m 700 -p ~/.ssh/
            cat >> ~/.ssh/config << EOF
            StrictHostKeyChecking no
            EOF

      - checkout

      - add_ssh_keys:
          fingerprints:
            - "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"

      - run:
          name: Deploy to Heroku
          command: |-
            heroku config:add BUNDLE_WITHOUT="test:development" --app $HEROKU_APP_NAME
            
            heroku git:remote -a $HEROKU_APP_NAME 

            git push heroku $CIRCLE_SHA1:refs/heads/master

            heroku run rake db:migrate --app $HEROKU_APP_NAME

workflows:
  version: 2

  build-and-deploy:
    jobs:
      - deploy:
          filters:
            branches:
              only: master
```

### GitLab CI
```yml
# .gitlab-ci.yml
stages:
  - deploy

deploy:
  stage: deploy

  image: sue445/heroku-cli

  resource_group: heroku

  script:
    - heroku config:add BUNDLE_WITHOUT="test:development" --app ${HEROKU_APP_NAME}
    - git push https://heroku:${HEROKU_API_KEY}@git.heroku.com/${HEROKU_APP_NAME}.git ${CI_COMMIT_SHA}:master
    - heroku run rake db:migrate --app ${HEROKU_APP_NAME}

  only:
    - master
```
