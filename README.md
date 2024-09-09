# Low Code Way: Revisited

> Prompt: As a Seasoned Software engineer, Write a introduction for why it is the time to revisit a lot of tools, process, knowledge, and practices in the coming ai age. The main focus is on the new tools like ai integrated low-code tool, the education problems, and how to learn from public information.

```
The AI Age: Retooling for a New Era of Software Development
The software development landscape is undergoing a seismic shift. Artificial intelligence (AI) is rapidly transforming the way we build, test, and deploy applications.  While core programming principles remain essential, the tools, processes, and knowledge base we rely on are ripe for re-evaluation.

This is particularly true on three key fronts:

The Rise of AI-Integrated Low-Code Tools: Low-code development platforms, empowered by AI, are democratizing application creation. These tools are simplifying complex tasks and enabling citizen developers to contribute alongside professional programmers.  Seasoned engineers need to adapt and leverage these tools to improve efficiency and collaboration.

The Evolving Educational Landscape: Traditional software engineering education often focuses on languages and frameworks that may not be the most relevant in the AI age.  We need to embrace a more holistic approach, incorporating AI fundamentals, data science literacy, and continuous learning to stay ahead of the curve. Public information, once a secondary source, is now a powerful learning tool.

Learning from Public Information: The explosion of open-source projects, online tutorials, and AI-powered educational resources presents an unprecedented opportunity for continuous learning. Seasoned engineers must learn to effectively filter, curate, and learn from publicly available information to maintain and expand their skillsets.

The AI age presents both challenges and opportunities. By revisiting our toolkits, educational approaches, and information consumption habits, seasoned software engineers can ensure they remain valuable assets in this exciting new era.
```

> Prompt: As a college student, I find that I can't learn a lot in school, but I can learn a lot practical skills from internet,social media, or some video platfrorm? Why is it? But I can't understand why it happened, why there is a contradiction between the reality and my mom or father's idea about that everything I learned is from the school,the book? The trend is so clear in recent years, is there any theory to explain that?

- From: gemini
```
You're right, the way we learn is definitely changing! Here's why you might be finding the internet more engaging for practical skills:

**Reasons you learn more online:**

* **Focus on Practical Skills:** Online resources often cater to specific skills and applications, making them directly applicable to your interests.
* **Interactive and Engaging:** Online platforms like video tutorials and social media can be more interactive and visually engaging than traditional lectures.
* **Learn at Your Pace:** You can control the pace of learning online, pausing, rewinding, or fast-forwarding as needed. This personalized approach can be more effective for some learners.
* **Passionate Communities:** Online communities around specific skills can provide motivation, peer support, and access to experts.

**Why your parents might think school is the only source:**

* **Traditional Learning Model:**  Many parents grew up in an era where formal education was the primary source of knowledge.
* **Structured Learning Environment:** Schools offer a structured environment that can be beneficial for developing critical thinking and study skills.
* **Credentialing:** Degrees and certifications from traditional institutions are still important for many careers.

**Theories on Modern Learning:**

Here are some theories that support your observation:

* **Connectivism:** This theory by George Siemens emphasizes the importance of building connections between information sources and personal experiences. Online learning excels at this, allowing you to connect with diverse resources.
* **Self-Directed Learning:** This theory highlights the importance of taking ownership of your learning journey. Online platforms offer more flexibility and control for self-directed learners.

**Finding the Balance:**

The ideal approach might be a blend of both traditional and online learning. Here's how:

* **Supplement your studies:** Use online resources to practice and deepen your understanding of what you learn in school.
* **Find a balance:**  Don't rely solely on online learning. Utilize the structured environment of school to develop core academic skills.
* **Critical evaluation:**  Develop an  approach to critically evaluate online information sources to ensure their accuracy and credibility.

Ultimately, the best way to learn is the way that works best for you.  Embrace the changing landscape of education and find a learning style that keeps you engaged and motivated.
```

- From: perplexity

```

The contradiction you describe between learning primarily from school/books versus learning practical skills from the internet/social media/video platforms can be understood through the lens of critical theory, particularly the Frankfurt School's critique of traditional education systems.

Some key points from the critical theory perspective:

1. Traditional education systems tend to prioritize theoretical knowledge from textbooks and classroom instruction over practical, experiential learning. This creates a disconnect between what is taught and the real-world skills needed in modern society[1].

2. The internet, social media, and video platforms allow for more decentralized and democratized forms of knowledge sharing. They enable peer-to-peer learning, access to diverse perspectives, and the rapid dissemination of practical skills and information[2].

3. Critical theorists argue that traditional education often serves to reproduce existing power structures and ideologies rather than fostering critical thinking and emancipation. Online platforms can challenge this by providing alternative sources of knowledge[3].

4. The dialectical contradiction between the rigidity of traditional education and the dynamic, participatory nature of online learning reflects deeper tensions in society between established institutions and emerging forces of change[4].

5. From a critical pedagogy viewpoint, the hands-on, self-directed learning facilitated by online platforms aligns better with principles of active learning, student empowerment, and connecting education to lived experiences[5].

In essence, critical theory highlights how the internet and new media disrupt the monopoly traditional institutions had over knowledge production and dissemination. While schools still play an important role, online platforms enable more democratic access to practical skills relevant to the modern world.

This contradiction arises from the evolving social and technological context challenging traditional educational paradigms. Critical theorists would argue that embracing new modes of learning that bridge theory and practice is necessary for fostering critical consciousness and emancipatory social change.

Citations:
[1] https://link.springer.com/article/10.1007/s40753-021-00150-z
[2] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10920815/
[3] https://en.wikipedia.org/wiki/Frankfurt_School
[4] https://www.marxists.org/reference/archive/mao/selected-works/volume-1/mswv1_17.htm
[5] https://plato.stanford.edu/entries/critical-theory/
```

# Introduction

Welcome to low code way! Less Code, More Productivity.

- AI Toolkits
- Prompts
- Project Management
- Internal Tools
- Integration Tools
- Build Customer Tools Quickly

Everything in this repo is based my own experiments, it my works for me,but not works for you.
But anyway, it is worthy to have a try.

## Prompts


## Project Management

1. What's the purpose of the project management in Software QA lifecycle?
2. How to do it in cost-effeciency way?
3. What to achieve? and how to improve overtime?

- [project management and wiki](agile-ci-cd/agile)
  - [X] [openproject](./qa-lowcode/project-management/openproject/openproject.md)
  - [X] [飞书文档](./qa-lowcode/project-management/feishu/feishu-table.md)
  - [] [多维表格-Vika/APITABLE]

## Backend Api

- Database Table as API
  - [] [prest]()
  - [] [pocketbase]()
  - [] [Supabase]()


## Infra - Docker Scripts

- [database](db-ops/db) database scripts
  - [bytebase](db-ops/bytebase) db script wokflow
  - [postgresql]()
- [agile-ci-cd](agile-ci-cd) agile-ci-cd:
  - [gitlab](agile-ci-cd/gitlab) gitlab install scripts
  - [sonar](agile-ci-cd/sonar/)

## Testing tools

- [mock server: stubby](testing/mock-server/stubby/) stubby: easy to setup mock for both HTTP and HTTP2
- [mock server: hoverfly](testing/mock-server/hoverfly) capture and mock api traffic, here is [intro](docs/qa-lowcode/mock/hoverfly.md)

## Interal Tools Builder

- [illa-builder](fullstack-lowcode/illa-builder)
- [form-ai](https://github.com/AOT-Technologies/forms-flow-ai.git)
## Draw tools

- [excalidraw](https://github.com/excalidraw/excalidraw)
## Test Ops

- [ansible-scipts](tester-ops/ansible)
- [docker-compose files](tester-ops/dockers)
  -
## Reference

Some of this project are from:
- [tester-ops-collections](http://github.com/qdriven/tester-ops-collections)
- [startpack](https://github.com/tldr-devops/startpack.git)


A Collection of Personal Projects for learning and tutorials, here is main purposes:

1. revisit my software qa path to reflect the good, bad and ugly of the past and now
   - build some starter project to quick start a new project
   - collect some common used libs to re-use
   - build Software QA backoffice application in low-code way
   - write some tutorials to speed up learning process
2. fulfill my curiosity
3. learn how to make products from a simple ideas
4. learn how to articulate things well



## 1. QA-Revisited


### 1.1. starters: Template Projects For different lanagues

***[Devops/Testops projects](https://github.com/fluent-qa/fluent-project-templates)***:
- [ansible-playbook-template](https://github.com/qdriven/ansible-playbook-templates)
- [fluentqa-mdocs-template](https://github.com/fluent-qa/fluentqa-md-docs-template.git)
- [python-templates](https://github.com/qdriven/fluent-pypro-template)
- [nextr-docs-templates](https://github.com/qdriven/docs-templates)
- [golang-template project](https://github.com/fluent-qa/fluentqa-gotpl.git) golang template project
- [ts-vite-template project](https://github.com/fluent-qa/ts-lib-starter.git) typescript lib template project
- [starter-cli-app](https://github.com/qdriven/qfluent-go.git)

### 1.2. Simplify QA: Simplify QA Process/Development

Simplify QA Project is to answer following question:

1. Simplify: If you restart your Software QA career, What would you do this time? And Why do you do in this way this time?
2. Re-Use: If you start a new position, what kind of codes, you could be used in your next position/company?

Projects:

- [fluentqa-workspace](https://github.com/fluent-qa/fluentqa-workspace.git) QA Workspace/Collections of JAVA QA Daily Used Libs
- [fluentqa-python](https://github.com/fluent-qa/fluent-qa/fluentqa-python.git) QA Daily Python Libs

### 1.3. Lessons: Different Short Tutorials for Different Languages

- [X] [QA-Revisited](https://github.com/qdriven/qa-revistied-slides.git) Daily Case Study
- [] JAVA: QA JAVA Lessons
- [] Python: QA Python Lessons
- [] Golang: QA Golang Lessons
- [] Javascript/Typescript; QA Typescript Lessons
- [] chains: QA Blockchain Lessons

### 1.4.Teck-Stack: Different Infrastructure tools for different scenarioes

Low code tools and tutorials to build Software QA Infra for daily work.

- [low-code-way](https://qa-lowcode.vercel.app/) Low Code Way

## 2. Beyond: fulfill my curiosity

Projects beyond software QA, but to fulfill my curiosity. Try and learn.


### 2.1. AI: 2.1 Demos

***API and agents***

|Category|Name|Repos|Desc|
|---|---|---|---|
|***Agent***|fluentqa-entity|[fluentqa-entity](beyond/demos/fluentqa-entity/README.md)|My first Ever AI Application to generate code by SQL,JSON and Any other structured data|
|***Proxy***|chatgpt-proxy-nextjs|[chatgpt-proxy-nextjs](beyond/demos/chatgpt-proxies/fluentqa-chatgpt-proxy/)|nextjs chatgpt proxy|
|***Proxy***|chatgpt-go-proxy|[chatgpt-go-proxy](beyond/demos/chatgpt-proxies/chatgpt-go-proxy/)|Golang Chatgpt Proxy|

## 3. Collectors

Collector Different Data and information.


# Self-Making Side Projects

A Collection of Personal Projects for learning and tutorials, here is main purposes:

1. revisit my software qa path to reflect the good, bad and ugly of the past and now
   - build some starter project to quick start a new project
   - collect some common used libs to re-use
   - build Software QA backoffice application in low-code way
   - write some tutorials to speed up learning process
2. fulfill my curiosity
3. learn how to make products from a simple ideas
4. learn how to articulate things well

## 1. QA-Revisited


### 1.1. starters: Template Projects For different lanagues

***[Devops/Testops projects](https://github.com/fluent-qa/fluent-project-templates)***:
- [ansible-playbook-template](https://github.com/qdriven/ansible-playbook-templates)
- [fluentqa-mdocs-template](https://github.com/fluent-qa/fluentqa-md-docs-template.git)
- [python-templates](https://github.com/qdriven/fluent-pypro-template)
- [nextr-docs-templates](https://github.com/qdriven/docs-templates)
- [golang-template project](https://github.com/fluent-qa/fluentqa-gotpl.git) golang template project
- [ts-vite-template project](https://github.com/fluent-qa/ts-lib-starter.git) typescript lib template project
- [starter-cli-app](https://github.com/qdriven/qfluent-go.git)

### 1.2. Simplify QA: Simplify QA Process/Development

Simplify QA Project is to answer following question:

1. Simplify: If you restart your Software QA career, What would you do this time? And Why do you do in this way this time?
2. Re-Use: If you start a new position, what kind of codes, you could be used in your next position/company?

Projects:

- [fluentqa-workspace](https://github.com/fluent-qa/fluentqa-workspace.git) QA Workspace/Collections of JAVA QA Daily Used Libs
- [fluentqa-python](https://github.com/fluent-qa/fluent-qa/fluentqa-python.git) QA Daily Python Libs

### 1.3. Lessons: Different Short Tutorials for Different Languages

- [X] [QA-Revisited](https://github.com/qdriven/qa-revistied-slides.git) Daily Case Study
- [] JAVA: QA JAVA Lessons
- [] Python: QA Python Lessons
- [] Golang: QA Golang Lessons
- [] Javascript/Typescript; QA Typescript Lessons
- [] chains: QA Blockchain Lessons

### 1.4.Teck-Stack: Different Infrastructure tools for different scenarioes

Low code tools and tutorials to build Software QA Infra for daily work.

- [low-code-way](https://qa-lowcode.vercel.app/) Low Code Way

## 2. Beyond: fulfill my curiosity

Projects beyond software QA, but to fulfill my curiosity. Try and learn.


### 2.1. AI: 2.1 Demos

***API and agents***

|Category|Name|Repos|Desc|
|---|---|---|---|
|***Agent***|fluentqa-entity|[fluentqa-entity](beyond/demos/fluentqa-entity/README.md)|My first Ever AI Application to generate code by SQL,JSON and Any other structured data|
|***Proxy***|chatgpt-proxy-nextjs|[chatgpt-proxy-nextjs](beyond/demos/chatgpt-proxies/fluentqa-chatgpt-proxy/)|nextjs chatgpt proxy|
|***Proxy***|chatgpt-go-proxy|[chatgpt-go-proxy](beyond/demos/chatgpt-proxies/chatgpt-go-proxy/)|Golang Chatgpt Proxy|

## 3. Collectors

Collector Different Data and informations