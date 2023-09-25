# How to Build A Test Case Management System in One day

The scope of this tes case management system is: 

- Upload Test Case Module
- Test Case Management: Create/Delete/Update/Delete
- Test Scenario Management: Combine different Test Cases as different test scenarios
- Test Plan/Test Run: Test Case Scope for A Test plan
- Test Record/Test Result: Tracking the testing prograss overtime

But Only one day include frontend and backend? Is it possible?

It is not possible to build a perfect project in one day from scratch, but
yes it is possible to leverage some low code framework to build a just working system.

## 1.Choose A Framework

Use [erupts](https://www.yuque.com/erupts/erupt) as a low code tool to build
application, why? Becuase building a modern frontend app is time comsuming, there is no way for me to build all the features in one day. But Use erupts, I can.

The main advantage of [erupts](https://www.yuque.com/erupts/erupt) is that:
- Almost Zero Frontend coding
- backend code controll all the frontend layout and display
- Very easy to build a just working internal tool system by a JAVA Bean

More details about ***erupts***, you can find the erupts docs. It is a really good documentation in my opinion.

Erupts is a Springboot based project. If you have a basic java and springboot knowledge, you can ramp up very very quickly.

## 2.Start An Erupt Application

As  a springboot project, you can use ***maven*** or ***gradle*** to build a project. There is no different.

### 2.1 Setup MAVEN Project

dependencies and build setting:

```xml
<dependencies>
        <!--用户权限管理-->
        <dependency>
            <groupId>xyz.erupt</groupId>
            <artifactId>erupt-upms</artifactId>
            <version>${erupt.version}</version>
        </dependency>
        <!--接口数据安全-->
        <dependency>
            <groupId>xyz.erupt</groupId>
            <artifactId>erupt-security</artifactId>
            <version>${erupt.version}</version>
        </dependency>
        <!--后台WEB界面-->
        <dependency>
            <groupId>xyz.erupt</groupId>
            <artifactId>erupt-web</artifactId>
            <version>${erupt.version}</version>
            <exclusions>
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-tomcat</artifactId>
            </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-undertow</artifactId>
            <version>2.7.12</version>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>${postgresql.version}</version>
        </dependency>
        <dependency>
            <groupId>javax.xml.bind</groupId>
            <artifactId>jaxb-api</artifactId>
            <version>2.3.1</version>
        </dependency>
        <dependency>
            <groupId>com.github.xiaoymin</groupId>
            <artifactId>knife4j-openapi2-spring-boot-starter</artifactId>
            <version>4.3.0</version>
        </dependency>

    </dependencies>
    <build>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <groupId>org.apache.maven.plugins</groupId>
                <version>3.10.1</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.7.2</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

### 2.2 Run the application

App class:

```java
mport org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableAsync;
import xyz.erupt.core.annotation.EruptScan;

@SpringBootApplication
@EntityScan(basePackages = {"io.fluentqa"})
@EruptScan(value = {"io.fluentqa"})
@EnableAsync
@ComponentScan(basePackages = {"io.fluentqa"})
public class QAWorkspaceApp {
    public static void main(String[] args) {
        SpringApplication.run(QAWorkspaceApp.class);
    }
}
```

### 2.3 Database and  settings

- Run Postgresql Database in docker
- Create Database in postgresql:
![](./database.png)
- setup Spingboot Application Configuration file

```yaml
erupt-app:
  # 是否开启水印，1.12.0 及以上版本支持
  waterMark: false
  # 登录失败几次出现验证码，值为0时表示一直需要登录验证码
  verifyCodeCount: 2
  # 登录密码是否加密传输，特殊场景如：LDAP登录可关闭该功能获取密码明文
  pwdTransferEncrypt: true
  # 多语言配置，默认支持：简体中文、繁体中文、英文、日文；具体配置详见erupt-i18n模块
  locales: [ "zh-CN","zh-TW","en-US","ja-JP" ]
erupt:
  # 是否开启csrf防御
  csrfInspect: true
  # 是否开启redis方式存储session，默认false，开启后需在配置文件中添加redis配置（同 spring boot）
  redisSession: false
  # 附件上传存储路径, 默认路径为：/opt/erupt-attachment
  uploadPath: ./data/temp
  # 是否保留上传文件原始名称
  keepUploadFileName: false
  # 登录session时长（redisSession为true时有效）
  upms.expireTimeByLogin: 120
  # 是否记录操作日志，默认true，该功能开启后可在【系统管理 → 操作日志】中查看操作日志
  security.recordOperateLog: false

spring:
  datasource:
    url: jdbc:postgresql://127.0.0.1:7432/qa_workspace
    username: postgres
    password: changeit
  jpa:
    show-sql: true
    generate-ddl: true
    database-platform: org.hibernate.dialect.PostgreSQLDialect
    database: postgresql

  mail:
    username: xxxx@qq.com
    password: xxxxxxx
    host: smtp.qq.com
    properties:
      mail.smtp.ssl.auth: true
      mail.smtp.ssl.enable: true
      mail.smtp.ssl.required: true
  servlet:
    multipart:
      max-file-size: 100MB
      max-request-size: 100MB

```

### 2.4. Packing and Run the application

- packaging the application
```sh
 mvn clean package -Dmaven.test.skip=true
```
- run the application
```sh
java -jar server-1.0-SNAPSHOT.jar
```
- debug in intelj idea
- some errors: check the database setting

```
Caused by: org.postgresql.util.PSQLException: FATAL: database "qa_workspace" does not exis`
```

### 3. Run the application 

- visit: http://localhost:9090/#/
![](login.png)
default user: erupt/erupt
- change password
![](home-page.png)

Have a Try for the basic functions.

### 4. What Learned

1. How to Create A MAVEN erupt/springboot project
2. How to Packaging Run a Springboot project
3. How to Setup Database connection 
4. The bonus is how to add API docs for the springboot project