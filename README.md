# Fluent QA Statup Stack: Low Code Way

Over the years as Software QA, I have experienced a lot of tools in different categories.
Many of these tools provider too much functionalities which is too expesensive to learn and explore. I think most QA engineer may just use less than 20% of the whole functionalities provided.

After the improvement of dev language, framework and so on, the cost of devlop back-office service is decreased significant. The proof of the cost reduced is that the opensource tools, and low-code tools. I tried some of these tools, and find out , actually I can use different tools to replace different commercial tools. Why it works? In most cases, I only use the 20% of the functionalities.
Different little tools can provide these 20% functionalities with less cost. And most complex functionalities which can be replaced by in-house tools which is eventually developed, as it is highly organization related. 

## Solve Problem with less cost

In startup company, how to solve problem with less cost?

1. what's kind of problem you want to solve?
2. Is there any existing opensouce tool to solve it?
3. How to use the opensource tool?
4. How to integrate different tools
## Less struggling for QA in small starup company 

This is for QA who struggling in a small startup company to build some tools to help productivities.
Because of the limitation of the budget, leverage some opensource tools is the only way to achieve it.

There are some tool categories:

1. Infra
   * Database
   * Management
2. CI-CD tools
   * Docker
   * K8S
   * Pipeline
3. internal-tools: 
   1. backend-lowcode
   2. fronted-lowcode
   3. headless-cms

## Infra - Docker Scripts

- [database](db-ops/db) database scripts
  - [bytebase](db-ops/bytebase) db script wokflow
  - [postgresql]()
- [agile-ci-cd](agile-ci-cd) agile-ci-cd:
  - [gitlab](agile-ci-cd/gitlab) gitlab install scripts
  - [sonar](agile-ci-cd/sonar/)
  - [project management and wiki](agile-ci-cd/agile)
    - [] [openproject]
    - [] [飞书文档]
    - [] [多维表格-Vika/APITABLE]

## Testing tools

- [mock server: stubby](testing/mock-server/stubby/) stubby: easy to setup mock for both HTTP and HTTP2
- [mock server: hoverfly](testing/mock-server/hoverfly) capture and mock api traffic, here is [intro](docs/qa-lowcode/mock/hoverfly.md)

## Interal Tools Builder

- [illa-builder](fullstack-lowcode/illa-builder)
- [form-ai](https://github.com/AOT-Technologies/forms-flow-ai.git)
## Draw tools

- [excalidraw](https://github.com/excalidraw/excalidraw)
## QA Tools

- [Mock Server](qa-lowcode/mockp-server)
- [k8s-for-docker-desktop](qa-lowcode/k8s-docker)

## Test Ops

- [ansible-scipts](tester-ops/ansible)
- [docker-compose files](tester-ops/dockers)
  - 
## Reference

Some of this project are from:
- [tester-ops-collections](http://github.com/qdriven/tester-ops-collections)
- [startpack](https://github.com/tldr-devops/startpack.git)

