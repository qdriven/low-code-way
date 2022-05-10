# README

A low code way to sync different kind of data by leveraging exiting apis,data and cloud sheet service, and visualize these kinds of data.


## Where is the idea coming from?

In a short time of period, I was assigned to create an application which is for Quality and Productivity metrics for Software Development Department. Because all the department is using JIRA to track the whole development process, it is reasonable to leverage JIRA webhook to collect the operation data and build a mini data warehouse to get the whole metrics. 

The solution was plain simple:
1. recieve the webhook data, transfer it and save to a Database(mysql or postgresql what ever)
2. Build a dashboard or portal to visualize these data in different dimensions.
3. Provide some flexibility to user to do ad hoc query or exploration to find new truth beyond the defined dimensions

It is not easy actually, why? I think the main reason is that most of development is not full stack developer, it needs:

1. Front-end skill, either Vue or React
2. Domain Expertise, at least understand what the meaning of different data
3. Backend Skill, serve side coding skill, include api, batch job , SQL 

So I think I need at least 2 Developers, one is front-end, another one is backend. But the resource which I have actually only 1 backend developer. How to solve it?

Finally, after doing some research, I used a opensource BI tool like metabase to  solve it.

And during the research, I also found some interesting topic like low-code-development, data pipelin platform,etc. Based on my experience, I think it is really good thing to small group to use these kind of techonlogy to reduce the cost of software development. 

I was a developer in testing. After I tried and found these tools, I realized that what developer in testing doing should be done in this way, low-code way. And not only a developer in testing should do it , but also all the tester should do it. The high salary of the developer in tester should be ended by low-code tools. Why? Because it reduce costs,and it works for me. 

And then I start the repo, and try to do more research. 


## Low-code Tools

Following Low-code tools to hava a simple try: 

- ToolJet
  * [*] docker
  * [*] Create a Application
  * [] docs/tutorial
  * [] Rating file
- AppSmith
  * [*] docker
  * [] Create a Application
  * [] docs/tutorial
- [] cubejs
  * [*] docker
  * [] Create a Application
  * [] docs/tutorial
- [] NocoBase
  * [*] docker
  * [] Demo Application
- [] Nocodb
```sh
npx create-nocodb-app
```
- [] YaoApp
  * [] docker
  * [] Application
  * [] Tutorial
- [] open metabase
  * [*] Docker
  * [] Application
  * [] Tutorial
- [] supabase
- [] Retool
- [] JetAdmin
- [] Budibase
- [] DronaHQ
- [] NocoDB
- [] Baserow
- [] Frapper Framework
- [] Directus
- [] Convertigo
- [] Saltcon
- []  ROWY
- [] Motor Admin
- [] Frappe




## OpenApi Practice

- [openapi](openapi-workspace)